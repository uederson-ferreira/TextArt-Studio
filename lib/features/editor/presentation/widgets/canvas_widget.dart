import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/editor_bloc.dart';
import '../bloc/editor_event.dart';
import '../bloc/editor_state.dart';
import '../../domain/entities/text_element.dart';
import '../../domain/entities/sticker_element.dart';
import '../../domain/entities/project.dart';
import 'element_controls_overlay.dart';

class CanvasWidget extends StatefulWidget {
  final GlobalKey repaintKey;

  const CanvasWidget({super.key, required this.repaintKey});

  @override
  State<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<EditorBloc>().add(const EditorSelectElement(null));
          },
          child: RepaintBoundary(
            key: widget.repaintKey,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: _resolveBackground(state),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background image
                  if (state.project.backgroundImagePath != null)
                    Positioned.fill(
                      child: Image.asset(
                        state.project.backgroundImagePath!,
                        fit: BoxFit.cover,
                      ),
                    ),

                  // Sticker elements
                  for (final sticker in state.stickerElements)
                    _StickerElementWidget(
                      sticker: sticker,
                      isSelected: sticker.id == state.selectedElementId,
                    ),

                  // Text elements
                  for (final text in state.textElements)
                    _TextElementWidget(
                      element: text,
                      isSelected: text.id == state.selectedElementId,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _resolveBackground(EditorState state) {
    if (state.project.backgroundType == CanvasBackground.transparent) {
      return Colors.transparent;
    }
    return Color(state.project.backgroundColor);
  }
}

// ---------------------------------------------------------------------------
// TEXT ELEMENT WIDGET
// ---------------------------------------------------------------------------

class _TextElementWidget extends StatefulWidget {
  final TextElement element;
  final bool isSelected;

  const _TextElementWidget({
    required this.element,
    required this.isSelected,
  });

  @override
  State<_TextElementWidget> createState() => _TextElementWidgetState();
}

class _TextElementWidgetState extends State<_TextElementWidget> {
  late Offset _position;
  late double _scale;
  late double _rotation;
  double _baseScale = 1.0;
  double _baseRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _position = widget.element.position;
    _scale = widget.element.scale;
    _rotation = widget.element.rotation;
  }

  @override
  void didUpdateWidget(_TextElementWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.element != widget.element) {
      _position = widget.element.position;
      _scale = widget.element.scale;
      _rotation = widget.element.rotation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: () {
          bloc.add(EditorSelectElement(widget.element.id));
        },
        onScaleStart: (details) {
          _baseScale = _scale;
          _baseRotation = _rotation;
        },
        onScaleUpdate: (details) {
          setState(() {
            _position = _position + details.focalPointDelta;
            _scale = (_baseScale * details.scale).clamp(0.2, 5.0);
            _rotation = _baseRotation + details.rotation;
          });
          bloc.add(EditorMoveElement(widget.element.id, _position));
          bloc.add(EditorScaleElement(widget.element.id, _scale));
          bloc.add(EditorRotateElement(widget.element.id, _rotation));
        },
        child: Transform.rotate(
          angle: _rotation,
          child: Transform.scale(
            scale: _scale,
            child: Stack(
              children: [
                _buildText(),
                if (widget.isSelected)
                  ElementControlsOverlay(
                    elementId: widget.element.id,
                    onDelete: () =>
                        bloc.add(EditorRemoveText(widget.element.id)),
                    onDuplicate: () =>
                        bloc.add(EditorDuplicateText(widget.element.id)),
                    onResizeUpdate: (details) {
                      final delta = details.delta.dx + details.delta.dy;
                      final newScale = (_scale + delta * 0.01).clamp(0.2, 5.0);
                      setState(() => _scale = newScale);
                      bloc.add(EditorScaleElement(widget.element.id, newScale));
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    final el = widget.element;

    Widget textWidget = Text(
      el.text,
      textAlign: _toTextAlign(el.alignment),
      style: _buildTextStyle(el),
    );

    if (el.gradientColors != null && el.gradientColors!.length >= 2) {
      textWidget = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          colors: el.gradientColors!,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: textWidget,
      );
    }

    return Opacity(
      opacity: el.opacity,
      child: Container(
        decoration: el.backgroundColor != null
            ? BoxDecoration(
                color: el.backgroundColor,
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        padding: el.backgroundColor != null
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : null,
        child: textWidget,
      ),
    );
  }

  TextStyle _buildTextStyle(TextElement el) {
    TextStyle base;
    try {
      base = GoogleFonts.getFont(
        el.fontFamily,
        fontSize: el.fontSize,
        fontWeight: el.fontWeight,
        fontStyle: el.fontStyle,
        color: el.hasStroke ? null : el.color,
        shadows: el.hasShadow
            ? [
                Shadow(
                  blurRadius: 8,
                  color: Colors.black.withValues(alpha: 0.6),
                  offset: const Offset(2, 2),
                )
              ]
            : null,
        foreground: el.hasStroke
            ? (Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = el.strokeWidth
              ..color = el.strokeColor)
            : null,
      );
    } catch (_) {
      base = TextStyle(
        fontSize: el.fontSize,
        fontWeight: el.fontWeight,
        fontStyle: el.fontStyle,
        color: el.hasStroke ? null : el.color,
      );
    }
    return base;
  }

  TextAlign _toTextAlign(TextAlignment alignment) {
    switch (alignment) {
      case TextAlignment.left:
        return TextAlign.left;
      case TextAlignment.center:
        return TextAlign.center;
      case TextAlignment.right:
        return TextAlign.right;
    }
  }
}

// ---------------------------------------------------------------------------
// STICKER ELEMENT WIDGET
// ---------------------------------------------------------------------------

class _StickerElementWidget extends StatefulWidget {
  final StickerElement sticker;
  final bool isSelected;

  const _StickerElementWidget({
    required this.sticker,
    required this.isSelected,
  });

  @override
  State<_StickerElementWidget> createState() => _StickerElementWidgetState();
}

class _StickerElementWidgetState extends State<_StickerElementWidget> {
  late Offset _position;
  late double _scale;
  late double _rotation;
  double _baseScale = 1.0;
  double _baseRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _position = widget.sticker.position;
    _scale = widget.sticker.scale;
    _rotation = widget.sticker.rotation;
  }

  @override
  void didUpdateWidget(_StickerElementWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sticker != widget.sticker) {
      _position = widget.sticker.position;
      _scale = widget.sticker.scale;
      _rotation = widget.sticker.rotation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: () {
          bloc.add(EditorSelectElement(widget.sticker.id));
        },
        onScaleStart: (details) {
          _baseScale = _scale;
          _baseRotation = _rotation;
        },
        onScaleUpdate: (details) {
          setState(() {
            _position = _position + details.focalPointDelta;
            _scale = (_baseScale * details.scale).clamp(0.2, 5.0);
            _rotation = _baseRotation + details.rotation;
          });
          bloc.add(EditorMoveElement(widget.sticker.id, _position));
          bloc.add(EditorScaleElement(widget.sticker.id, _scale));
          bloc.add(EditorRotateElement(widget.sticker.id, _rotation));
        },
        child: Transform.rotate(
          angle: _rotation,
          child: Transform.scale(
            scale: _scale,
            child: Stack(
              children: [
                Opacity(
                  opacity: widget.sticker.opacity,
                  child: SizedBox(
                    width: widget.sticker.size,
                    height: widget.sticker.size,
                    child: _buildStickerContent(),
                  ),
                ),
                if (widget.isSelected)
                  ElementControlsOverlay(
                    elementId: widget.sticker.id,
                    onDelete: () =>
                        bloc.add(EditorRemoveSticker(widget.sticker.id)),
                    onDuplicate: () =>
                        bloc.add(EditorDuplicateSticker(widget.sticker.id)),
                    onResizeUpdate: (details) {
                      final delta = details.delta.dx + details.delta.dy;
                      final newScale = (_scale + delta * 0.01).clamp(0.2, 5.0);
                      setState(() => _scale = newScale);
                      bloc.add(EditorScaleElement(widget.sticker.id, newScale));
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickerContent() {
    switch (widget.sticker.type) {
      case StickerType.svg:
        return SvgPicture.string(
          widget.sticker.assetPath,
          width: widget.sticker.size,
          height: widget.sticker.size,
          fit: BoxFit.contain,
        );
      case StickerType.emoji:
      default:
        return Center(
          child: Text(
            widget.sticker.assetPath,
            style: TextStyle(fontSize: widget.sticker.size * 0.8),
            textAlign: TextAlign.center,
          ),
        );
    }
  }
}
