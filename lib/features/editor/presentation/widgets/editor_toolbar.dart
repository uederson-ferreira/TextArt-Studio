import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../../../stickers/data/repositories/local_svg_stickers.dart';
import '../../../stickers/domain/entities/sticker_entity.dart';
import '../../../stickers/presentation/pages/sticker_picker_page.dart';
import '../../../stickers/presentation/pages/svg_repo_search_page.dart';
import '../../../stickers/presentation/pages/giphy_search_page.dart';

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
  List<Color>? _gradientColors;
  final double _gradientAngle = 0.0;

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

          // Enhanced color picker
          _EnhancedColorPickerSection(
            selectedColor: _color,
            gradientColors: _gradientColors,
            onColorChanged: (c) => setState(() => _color = c),
            onGradientChanged: (colors) =>
                setState(() => _gradientColors = colors),
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
      gradientColors: _gradientColors,
      gradientAngle: _gradientAngle,
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
  List<Color>? _gradientColors;
  double _gradientAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.element.text);
    _fontSize = widget.element.fontSize;
    _fontFamily = widget.element.fontFamily;
    _color = widget.element.color;
    _gradientColors = widget.element.gradientColors;
    _gradientAngle = widget.element.gradientAngle;
  }

  @override
  void didUpdateWidget(_EditTextPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.element.id != widget.element.id) {
      _controller.text = widget.element.text;
      _fontSize = widget.element.fontSize;
      _fontFamily = widget.element.fontFamily;
      _color = widget.element.color;
      _gradientColors = widget.element.gradientColors;
      _gradientAngle = widget.element.gradientAngle;
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

          // Enhanced color picker
          _EnhancedColorPickerSection(
            selectedColor: _color,
            gradientColors: _gradientColors,
            onColorChanged: (c) {
              setState(() => _color = c);
              _applyChanges();
            },
            onGradientChanged: (colors) {
              setState(() => _gradientColors = colors);
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
      gradientColors: _gradientColors,
      clearGradient: _gradientColors == null,
      gradientAngle: _gradientAngle,
    );
    context.read<EditorBloc>().add(EditorUpdateText(updated));
  }
}

// ---------------------------------------------------------------------------
// ENHANCED COLOR PICKER SECTION (color + gradient)
// ---------------------------------------------------------------------------

class _EnhancedColorPickerSection extends StatelessWidget {
  final Color selectedColor;
  final List<Color>? gradientColors;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<List<Color>?> onGradientChanged;

  const _EnhancedColorPickerSection({
    required this.selectedColor,
    required this.gradientColors,
    required this.onColorChanged,
    required this.onGradientChanged,
  });

  void _openColorPicker(BuildContext context) {
    Color pickerColor = selectedColor;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevatedDark,
        title: Text('Escolher Cor', style: AppTypography.titleMedium()),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (c) => pickerColor = c,
            enableAlpha: false,
            hexInputBar: true,
            labelTypes: const [],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              onColorChanged(pickerColor);
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Color section ---
        Row(
          children: [
            Text('Cor do Texto', style: AppTypography.labelMedium()),
            const SizedBox(width: AppSizes.space8),
            // Selected color indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: gradientColors != null && gradientColors!.length >= 2
                    ? null
                    : selectedColor,
                gradient: gradientColors != null && gradientColors!.length >= 2
                    ? LinearGradient(colors: gradientColors!)
                    : null,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.dividerDark),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.space8),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Quick color swatches
              ...AppConstants.quickColors.map((colorInt) {
                final color = Color(colorInt);
                final isSelected = gradientColors == null &&
                    selectedColor.toARGB32() == colorInt;
                return GestureDetector(
                  onTap: () {
                    onColorChanged(color);
                    onGradientChanged(null); // clear gradient
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: AppSizes.space8),
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
              }),
              // "+" custom color button
              GestureDetector(
                onTap: () => _openColorPicker(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighDark,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.dividerDark),
                  ),
                  child: const Icon(Icons.add,
                      size: 18, color: AppColors.textSecondaryDark),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSizes.space12),

        // --- Gradient section ---
        Text('Gradiente', style: AppTypography.labelMedium()),
        const SizedBox(height: AppSizes.space8),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // "Nenhum" pill
              GestureDetector(
                onTap: () => onGradientChanged(null),
                child: Container(
                  margin: const EdgeInsets.only(right: AppSizes.space8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.space12, vertical: 4),
                  decoration: BoxDecoration(
                    color: gradientColors == null
                        ? AppColors.primary
                        : AppColors.surfaceHighDark,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusCircle),
                    border: Border.all(
                      color: gradientColors == null
                          ? AppColors.primary
                          : AppColors.dividerDark,
                    ),
                  ),
                  child: Text(
                    'Nenhum',
                    style: AppTypography.labelSmall(
                      color: gradientColors == null
                          ? Colors.white
                          : AppColors.textSecondaryDark,
                    ),
                  ),
                ),
              ),
              // Gradient preset swatches
              ...AppConstants.gradientPresets.map((preset) {
                final colors = preset.map((v) => Color(v)).toList();
                final isSelected = gradientColors != null &&
                    gradientColors!.length == colors.length &&
                    _listsEqual(
                      gradientColors!
                          .map((c) => c.toARGB32())
                          .toList(),
                      preset,
                    );
                return GestureDetector(
                  onTap: () => onGradientChanged(colors),
                  child: Container(
                    width: 48,
                    height: 28,
                    margin: const EdgeInsets.only(right: AppSizes.space8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.dividerDark,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  bool _listsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
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
// STICKER PANEL
// ---------------------------------------------------------------------------

class _StickerPanel extends StatefulWidget {
  final VoidCallback onClose;

  const _StickerPanel({required this.onClose});

  @override
  State<_StickerPanel> createState() => _StickerPanelState();
}

class _StickerPanelState extends State<_StickerPanel> {
  int _tab = 0; // 0 = SVG, 1 = Emoji

  static const _emojis = [
    '⭐', '❤️', '🔥', '✨', '💫', '🎉', '🎨', '🎭',
    '🌈', '🦋', '🌺', '🍀', '💎', '🏆', '🎸', '🚀',
    '😍', '😎', '🥳', '💪', '👑', '🌟', '💥', '🎯',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 320),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        border: Border(top: BorderSide(color: AppColors.dividerDark)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.space16, AppSizes.space12, AppSizes.space8, 0),
            child: Row(
              children: [
                _tabChip('Artes', 0),
                const SizedBox(width: AppSizes.space8),
                _tabChip('Emojis', 1),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _openFullPicker(context),
                  icon: const Icon(Icons.grid_view, size: 16),
                  label: const Text('Ver todos'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(fontSize: 13),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close,
                      color: AppColors.textSecondaryDark, size: 20),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),
          // Search buttons row
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.space12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openSvgRepoSearch(context),
                    icon: const Icon(Icons.search, size: 15),
                    label: const Text('Ícones (200k+)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openGiphySearch(context),
                    icon: const Icon(Icons.gif_box_outlined, size: 15),
                    label: const Text('GIFs Animados'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purpleAccent,
                      side: const BorderSide(color: Colors.purpleAccent),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: _tab == 0 ? _buildSvgGrid(context) : _buildEmojiGrid(context),
          ),
        ],
      ),
    );
  }

  void _openGiphySearch(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    widget.onClose();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GiphySearchPage(
          onStickerSelected: (sticker) {
            final element = StickerElement.create(
              assetPath: sticker.assetPath,
              type: StickerType.gif,
            );
            bloc.add(EditorAddSticker(element));
          },
        ),
      ),
    );
  }

  void _openSvgRepoSearch(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    widget.onClose();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SvgRepoSearchPage(
          onStickerSelected: (sticker) {
            final element = StickerElement.create(
              assetPath: sticker.assetPath,
              type: StickerType.svg,
            );
            bloc.add(EditorAddSticker(element));
          },
        ),
      ),
    );
  }

  void _openFullPicker(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    widget.onClose();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => ClipRRect(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
          child: StickerPickerPage(
            onStickerSelected: (sticker) {
              final element = StickerElement.create(
                assetPath: sticker.assetPath,
                type: sticker.renderType == StickerRenderType.svg
                    ? StickerType.svg
                    : StickerType.emoji,
              );
              bloc.add(EditorAddSticker(element));
            },
          ),
        ),
      ),
    );
  }

  Widget _tabChip(String label, int index) {
    final active = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceHighDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textSecondaryDark,
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSvgGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.space12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: localSvgStickers.length,
      itemBuilder: (context, index) {
        final svgData = localSvgStickers[index].assetPath;
        final name = localSvgStickers[index].name;
        return GestureDetector(
          onTap: () {
            final sticker = StickerElement.create(
              assetPath: svgData,
              type: StickerType.svg,
            );
            context.read<EditorBloc>().add(EditorAddSticker(sticker));
            widget.onClose();
          },
          child: Tooltip(
            message: name,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceHighDark,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              padding: const EdgeInsets.all(4),
              child: SvgPicture.string(svgData, fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmojiGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.space12),
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
            widget.onClose();
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceHighDark,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child:
                Center(child: Text(_emojis[index], style: const TextStyle(fontSize: 24))),
          ),
        );
      },
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
