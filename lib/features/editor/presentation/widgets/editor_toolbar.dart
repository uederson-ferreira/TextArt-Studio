import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/editor_bloc.dart';
import '../bloc/editor_event.dart';
import '../bloc/editor_state.dart';
import '../../domain/entities/text_element.dart';
import '../../domain/entities/sticker_element.dart';
import '../../domain/entities/project.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../fonts/presentation/pages/font_picker_page.dart';

enum ToolbarTab { text, sticker, background, export }

class EditorBottomToolbar extends StatefulWidget {
  final VoidCallback onExport;

  const EditorBottomToolbar({super.key, required this.onExport});

  @override
  State<EditorBottomToolbar> createState() => _EditorBottomToolbarState();
}

class _EditorBottomToolbarState extends State<EditorBottomToolbar> {
  ToolbarTab? _activeTab;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_activeTab != null) _buildPanel(context, state),
            _buildTabBar(context, state),
          ],
        );
      },
    );
  }

  void _toggleTab(ToolbarTab tab) {
    setState(() {
      _activeTab = _activeTab == tab ? null : tab;
    });
  }

  Widget _buildTabBar(BuildContext context, EditorState state) {
    return Container(
      height: AppSizes.toolbarBottomHeight,
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(top: BorderSide(color: AppColors.dividerDark)),
      ),
      child: Row(
        children: [
          _ToolbarButton(
            icon: Icons.text_fields,
            label: 'Texto',
            isActive: _activeTab == ToolbarTab.text,
            onTap: () => _toggleTab(ToolbarTab.text),
          ),
          _ToolbarButton(
            icon: Icons.emoji_emotions_outlined,
            label: 'Stickers',
            isActive: _activeTab == ToolbarTab.sticker,
            onTap: () => _toggleTab(ToolbarTab.sticker),
          ),
          _ToolbarButton(
            icon: Icons.palette_outlined,
            label: 'Fundo',
            isActive: _activeTab == ToolbarTab.background,
            onTap: () => _toggleTab(ToolbarTab.background),
          ),
          _ToolbarButton(
            icon: Icons.download_outlined,
            label: 'Exportar',
            isActive: false,
            onTap: widget.onExport,
          ),
        ],
      ),
    );
  }

  Widget _buildPanel(BuildContext context, EditorState state) {
    switch (_activeTab) {
      case ToolbarTab.text:
        // If a text element is selected, show its edit panel
        final selectedText = state.selectedElementId != null
            ? state.textElements
                .where((e) => e.id == state.selectedElementId)
                .firstOrNull
            : null;

        if (selectedText != null) {
          return _EditTextPanel(
            element: selectedText,
            onClose: () => setState(() => _activeTab = null),
          );
        }
        return _AddTextPanel(onClose: () => setState(() => _activeTab = null));

      case ToolbarTab.sticker:
        return _StickerPanel(onClose: () => setState(() => _activeTab = null));

      case ToolbarTab.background:
        return _BackgroundPanel(
            onClose: () => setState(() => _activeTab = null));

      default:
        return const SizedBox.shrink();
    }
  }
}

// ---------------------------------------------------------------------------
// ADD TEXT PANEL
// ---------------------------------------------------------------------------

class _AddTextPanel extends StatefulWidget {
  final VoidCallback onClose;

  const _AddTextPanel({required this.onClose});

  @override
  State<_AddTextPanel> createState() => _AddTextPanelState();
}

class _AddTextPanelState extends State<_AddTextPanel> {
  final _controller = TextEditingController(text: 'Seu texto aqui');
  double _fontSize = 32;
  String? _fontFamily;
  Color _color = Colors.white;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewStyle = _fontStyle();

    return Container(
      padding: const EdgeInsets.all(AppSizes.space16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        border: Border(top: BorderSide(color: AppColors.dividerDark)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Adicionar Texto', style: AppTypography.titleMedium()),
              IconButton(
                icon: const Icon(Icons.close,
                    color: AppColors.textSecondaryDark),
                onPressed: widget.onClose,
              ),
            ],
          ),

          // Text input
          TextField(
            controller: _controller,
            style: previewStyle.copyWith(
              color: AppColors.textPrimaryDark,
              fontSize: 16,
            ),
            decoration:
                const InputDecoration(hintText: 'Digite seu texto...'),
            maxLines: 2,
          ),
          const SizedBox(height: AppSizes.space12),

          // Font picker row
          _FontSelectorRow(
            fontFamily: _fontFamily,
            previewText: _controller.text,
            onFontSelected: (family) =>
                setState(() => _fontFamily = family),
          ),
          const SizedBox(height: AppSizes.space12),

          // Font size
          Row(
            children: [
              Text('Tamanho:', style: AppTypography.labelMedium()),
              const SizedBox(width: AppSizes.space8),
              Text('${_fontSize.round()}pt',
                  style: AppTypography.labelMedium(
                      color: AppColors.primary)),
            ],
          ),
          Slider(
            value: _fontSize,
            min: 12,
            max: 120,
            divisions: 54,
            onChanged: (v) => setState(() => _fontSize = v),
          ),

          // Color picker
          _ColorPickerRow(
            selectedColor: _color,
            onColorChanged: (c) => setState(() => _color = c),
          ),
          const SizedBox(height: AppSizes.space12),

          // Add button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addText,
              child: const Text('Adicionar ao Canvas'),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _fontStyle() {
    if (_fontFamily == null) return const TextStyle();
    try {
      return GoogleFonts.getFont(_fontFamily!);
    } catch (_) {
      return const TextStyle();
    }
  }

  void _addText() {
    if (_controller.text.trim().isEmpty) return;
    final element = TextElement.create(
      text: _controller.text,
      fontSize: _fontSize,
      color: _color,
      fontFamily: _fontFamily ?? 'Poppins',
    );
    context.read<EditorBloc>().add(EditorAddText(element));
    widget.onClose();
  }
}

// ---------------------------------------------------------------------------
// EDIT TEXT PANEL  (for already-placed text elements)
// ---------------------------------------------------------------------------

class _EditTextPanel extends StatefulWidget {
  final TextElement element;
  final VoidCallback onClose;

  const _EditTextPanel({
    required this.element,
    required this.onClose,
  });

  @override
  State<_EditTextPanel> createState() => _EditTextPanelState();
}

class _EditTextPanelState extends State<_EditTextPanel> {
  late TextEditingController _controller;
  late double _fontSize;
  late String _fontFamily;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.element.text);
    _fontSize = widget.element.fontSize;
    _fontFamily = widget.element.fontFamily;
    _color = widget.element.color;
  }

  @override
  void didUpdateWidget(_EditTextPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.element.id != widget.element.id) {
      _controller.text = widget.element.text;
      _fontSize = widget.element.fontSize;
      _fontFamily = widget.element.fontFamily;
      _color = widget.element.color;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.space16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        border: Border(top: BorderSide(color: AppColors.dividerDark)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Editar Texto', style: AppTypography.titleMedium()),
              Row(
                children: [
                  TextButton(
                    onPressed: _applyChanges,
                    child: const Text('Aplicar'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.textSecondaryDark),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ],
          ),

          // Text input
          TextField(
            controller: _controller,
            style: const TextStyle(
                color: AppColors.textPrimaryDark, fontSize: 16),
            decoration:
                const InputDecoration(hintText: 'Digite seu texto...'),
            maxLines: 2,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSizes.space12),

          // Font picker
          _FontSelectorRow(
            fontFamily: _fontFamily,
            previewText: _controller.text,
            onFontSelected: (family) {
              setState(() => _fontFamily = family);
              _applyChanges();
            },
          ),
          const SizedBox(height: AppSizes.space12),

          // Font size
          Row(
            children: [
              Text('Tamanho:', style: AppTypography.labelMedium()),
              const SizedBox(width: AppSizes.space8),
              Text('${_fontSize.round()}pt',
                  style: AppTypography.labelMedium(
                      color: AppColors.primary)),
            ],
          ),
          Slider(
            value: _fontSize,
            min: 12,
            max: 120,
            divisions: 54,
            onChanged: (v) {
              setState(() => _fontSize = v);
              _applyChanges();
            },
          ),

          // Color picker
          _ColorPickerRow(
            selectedColor: _color,
            onColorChanged: (c) {
              setState(() => _color = c);
              _applyChanges();
            },
          ),
        ],
      ),
    );
  }

  void _applyChanges() {
    final updated = widget.element.copyWith(
      text: _controller.text.isEmpty ? widget.element.text : _controller.text,
      fontSize: _fontSize,
      fontFamily: _fontFamily,
      color: _color,
    );
    context.read<EditorBloc>().add(EditorUpdateText(updated));
  }
}

// ---------------------------------------------------------------------------
// SHARED: FONT SELECTOR ROW
// ---------------------------------------------------------------------------

class _FontSelectorRow extends StatelessWidget {
  final String? fontFamily;
  final String previewText;
  final ValueChanged<String> onFontSelected;

  const _FontSelectorRow({
    required this.fontFamily,
    required this.previewText,
    required this.onFontSelected,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle;
    try {
      labelStyle = fontFamily != null
          ? GoogleFonts.getFont(fontFamily!, fontSize: 14,
              color: AppColors.textPrimaryDark)
          : TextStyle(fontSize: 14, color: AppColors.textPrimaryDark);
    } catch (_) {
      labelStyle =
          const TextStyle(fontSize: 14, color: AppColors.textPrimaryDark);
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FontPickerPage(
              previewText:
                  previewText.trim().isEmpty ? 'Exemplo de Texto' : previewText,
              currentFamily: fontFamily,
              onFontSelected: onFontSelected,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.space12, vertical: AppSizes.space8),
        decoration: BoxDecoration(
          color: AppColors.surfaceHighDark,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.dividerDark),
        ),
        child: Row(
          children: [
            const Icon(Icons.font_download_outlined,
                size: 20, color: AppColors.textSecondaryDark),
            const SizedBox(width: AppSizes.space8),
            Expanded(
              child: Text(
                fontFamily ?? 'Escolher Fonte',
                style: labelStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textSecondaryDark),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SHARED: COLOR PICKER ROW
// ---------------------------------------------------------------------------

class _ColorPickerRow extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const _ColorPickerRow({
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.quickColors.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppSizes.space8),
        itemBuilder: (context, i) {
          final color = Color(AppConstants.quickColors[i]);
          final isSelected = selectedColor.toARGB32() ==
              AppConstants.quickColors[i];
          return GestureDetector(
            onTap: () => onColorChanged(color),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.dividerDark,
                  width: isSelected ? 2.5 : 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// STICKER PANEL
// ---------------------------------------------------------------------------

class _StickerPanel extends StatelessWidget {
  final VoidCallback onClose;

  const _StickerPanel({required this.onClose});

  static const _emojis = [
    '⭐', '❤️', '🔥', '✨', '💫', '🎉', '🎨', '🎭',
    '🌈', '🦋', '🌺', '🍀', '💎', '🏆', '🎸', '🚀',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.space16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        border: Border(top: BorderSide(color: AppColors.dividerDark)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Stickers', style: AppTypography.titleMedium()),
              IconButton(
                icon: const Icon(Icons.close,
                    color: AppColors.textSecondaryDark),
                onPressed: onClose,
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _emojis.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final sticker = StickerElement.create(
                    assetPath: _emojis[index],
                    type: StickerType.emoji,
                  );
                  context.read<EditorBloc>().add(EditorAddSticker(sticker));
                  onClose();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighDark,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Center(
                    child: Text(_emojis[index],
                        style: const TextStyle(fontSize: 24)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BACKGROUND PANEL
// ---------------------------------------------------------------------------

class _BackgroundPanel extends StatelessWidget {
  final VoidCallback onClose;

  const _BackgroundPanel({required this.onClose});

  static const _colors = [
    0xFF000000, 0xFF1A1A2E, 0xFF0A0A0F, 0xFF1C1C2A,
    0xFF7C3AED, 0xFFEC4899, 0xFF3B82F6, 0xFF22C55E,
    0xFFEF4444, 0xFFF97316, 0xFFEAB308, 0xFFFFFFFF,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.space16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        border: Border(top: BorderSide(color: AppColors.dividerDark)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Fundo', style: AppTypography.titleMedium()),
              IconButton(
                icon: const Icon(Icons.close,
                    color: AppColors.textSecondaryDark),
                onPressed: onClose,
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _colors.length,
            itemBuilder: (context, index) {
              final color = _colors[index];
              return GestureDetector(
                onTap: () {
                  context.read<EditorBloc>().add(EditorSetBackground(
                        type: CanvasBackground.color,
                        color: color,
                      ));
                  onClose();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(color),
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(color: AppColors.dividerDark),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOOLBAR BUTTON
// ---------------------------------------------------------------------------

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? AppColors.primary : AppColors.textSecondaryDark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppSizes.toolbarIconSize),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.labelSmall(color: color)),
          ],
        ),
      ),
    );
  }
}
