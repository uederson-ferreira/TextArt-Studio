import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sticker_bloc.dart';
import '../bloc/sticker_event.dart';
import '../bloc/sticker_state.dart';
import '../../domain/entities/sticker_entity.dart';
import '../../data/repositories/sticker_repository_impl.dart';
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
    ('Rostos', StickerCategory.faces),
    ('Gestos', StickerCategory.gestures),
    ('Objetos', StickerCategory.objects),
    ('Animais', StickerCategory.animals),
    ('Comida', StickerCategory.food),
    ('Símbolos', StickerCategory.symbols),
    ('Formas', StickerCategory.shapes),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<StickerBloc>().add(
              StickerLoadByCategory(_categories[_tabController.index].$2),
            );
      }
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
          tabs: _categories.map((c) => Tab(text: c.$1)).toList(),
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
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusMd),
                    border:
                        Border.all(color: AppColors.dividerDark),
                  ),
                  child: Center(
                    child: Text(
                      sticker.assetPath,
                      style: const TextStyle(fontSize: 36),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
