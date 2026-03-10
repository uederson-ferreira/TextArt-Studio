import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/font_bloc.dart';
import '../bloc/font_event.dart';
import '../bloc/font_state.dart';
import '../../domain/entities/font_entity.dart';
import '../../data/repositories/font_repository_impl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';

class FontPickerPage extends StatelessWidget {
  final String previewText;
  final String? currentFamily;
  final ValueChanged<String> onFontSelected;

  const FontPickerPage({
    super.key,
    required this.previewText,
    this.currentFamily,
    required this.onFontSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FontBloc(repository: FontRepositoryImpl()),
      child: _FontPickerView(
        previewText: previewText,
        currentFamily: currentFamily,
        onFontSelected: onFontSelected,
      ),
    );
  }
}

class _FontPickerView extends StatefulWidget {
  final String previewText;
  final String? currentFamily;
  final ValueChanged<String> onFontSelected;

  const _FontPickerView({
    required this.previewText,
    this.currentFamily,
    required this.onFontSelected,
  });

  @override
  State<_FontPickerView> createState() => _FontPickerViewState();
}

class _FontPickerViewState extends State<_FontPickerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  // "Destaques" tab is index 0; category tabs start at index 1
  static const _categories = [
    ('Todos', FontCategory.all),
    ('Sem Serifa', FontCategory.sansSerif),
    ('Com Serifa', FontCategory.serif),
    ('Manuscrita', FontCategory.handwriting),
    ('Display', FontCategory.display),
    ('Mono', FontCategory.monospace),
  ];

  // Total tabs = 1 (Destaques) + _categories.length
  static const int _featuredTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 1 + _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final index = _tabController.index;
        if (index == _featuredTabIndex) {
          context.read<FontBloc>().add(const FontLoadFeatured());
        } else {
          context.read<FontBloc>().add(
                FontLoadByCategory(
                    _categories[index - 1].$2),
              );
        }
      }
    });
    // Load featured fonts initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FontBloc>().add(const FontLoadFeatured());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Escolher Fonte', style: AppTypography.titleLarge()),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            const Tab(text: 'Destaques ⭐'),
            ..._categories.map((c) => Tab(text: c.$1)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSizes.space16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar fonte...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (q) {
                context.read<FontBloc>().add(FontSearch(q));
              },
            ),
          ),

          // Font list
          Expanded(
            child: BlocBuilder<FontBloc, FontState>(
              builder: (context, state) {
                if (state.status == FontStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.fonts.isEmpty) {
                  return Center(
                    child: Text('Nenhuma fonte encontrada',
                        style: AppTypography.bodyMedium()),
                  );
                }
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.space16),
                  itemCount: state.fonts.length,
                  itemBuilder: (context, index) {
                    final font = state.fonts[index];
                    final isSelected =
                        font.family == (state.selectedFamily ?? widget.currentFamily);

                    return _FontListTile(
                      font: font,
                      previewText: widget.previewText,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<FontBloc>().add(FontSelect(font.family));
                        widget.onFontSelected(font.family);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FontListTile extends StatelessWidget {
  final FontEntity font;
  final String previewText;
  final bool isSelected;
  final VoidCallback onTap;

  const _FontListTile({
    required this.font,
    required this.previewText,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    late final TextStyle previewStyle;
    try {
      previewStyle = GoogleFonts.getFont(font.family, fontSize: 20);
    } catch (_) {
      previewStyle = const TextStyle(fontSize: 20);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.space8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryWithOpacity(0.15)
            : AppColors.surfaceHighDark,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.dividerDark,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          previewText.isEmpty ? font.family : previewText,
          style: previewStyle.copyWith(color: AppColors.textPrimaryDark),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          font.family,
          style: AppTypography.labelSmall(),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppColors.primary)
            : null,
      ),
    );
  }
}
