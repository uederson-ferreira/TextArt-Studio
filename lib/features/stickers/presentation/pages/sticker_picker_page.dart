import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/sticker_bloc.dart';
import '../bloc/sticker_event.dart';
import '../bloc/sticker_state.dart';
import '../../domain/entities/sticker_entity.dart';
import '../../data/repositories/sticker_repository_impl.dart';
import '../../data/repositories/all_emojis.dart';
import '../../data/repositories/local_svg_stickers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';

class StickerPickerPage extends StatelessWidget {
  final ValueChanged<StickerEntity> onStickerSelected;

  const StickerPickerPage({super.key, required this.onStickerSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StickerBloc(repository: StickerRepositoryImpl()),
      child: _StickerPickerView(onStickerSelected: onStickerSelected),
    );
  }
}

class _StickerPickerView extends StatefulWidget {
  final ValueChanged<StickerEntity> onStickerSelected;

  const _StickerPickerView({required this.onStickerSelected});

  @override
  State<_StickerPickerView> createState() => _StickerPickerViewState();
}

class _StickerPickerViewState extends State<_StickerPickerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _categories = [
    ('Todos', StickerCategory.all),
    ('Artes SVG', StickerCategory.shapes),
    ('Rostos', StickerCategory.faces),
    ('Gestos', StickerCategory.gestures),
    ('Objetos', StickerCategory.objects),
    ('Animais', StickerCategory.animals),
    ('Comida', StickerCategory.food),
    ('Símbolos', StickerCategory.symbols),
  ];

  late final List<String> _categoryTitles;

  @override
  void initState() {
    super.initState();

    _categoryTitles = _categories.map((c) {
      final name = c.$1;
      final cat = c.$2;
      final int count;
      if (cat == StickerCategory.all) {
        count = allEmojis.length + localSvgStickers.length;
      } else if (cat == StickerCategory.shapes) {
        count = localSvgStickers.length;
      } else {
        count = allEmojis.where((s) => s.category == cat).length;
      }
      return '$name ($count)';
    }).toList();

    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<StickerBloc>().add(
              StickerLoadByCategory(_categories[_tabController.index].$2),
            );
      }
    });

    // Start on the SVG tab (index 1) so user sees shapes first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.animateTo(1);
      context
          .read<StickerBloc>()
          .add(StickerLoadByCategory(StickerCategory.shapes));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Stickers', style: AppTypography.titleLarge()),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: _categoryTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: BlocBuilder<StickerBloc, StickerState>(
        builder: (context, state) {
          if (state.status == StickerStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.stickers.isEmpty) {
            return Center(
              child: Text('Nenhum sticker encontrado',
                  style: AppTypography.bodyMedium()),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(AppSizes.space16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: AppSizes.space8,
              crossAxisSpacing: AppSizes.space8,
            ),
            itemCount: state.stickers.length,
            itemBuilder: (context, index) {
              final sticker = state.stickers[index];
              return GestureDetector(
                onTap: () {
                  widget.onStickerSelected(sticker);
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighDark,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(color: AppColors.dividerDark),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Center(child: _buildStickerPreview(sticker)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStickerPreview(StickerEntity sticker) {
    if (sticker.renderType == StickerRenderType.svg) {
      return SvgPicture.string(
        sticker.assetPath,
        width: 52,
        height: 52,
        fit: BoxFit.contain,
      );
    }
    return Text(
      sticker.assetPath,
      style: const TextStyle(fontSize: 36),
      textAlign: TextAlign.center,
    );
  }
}
