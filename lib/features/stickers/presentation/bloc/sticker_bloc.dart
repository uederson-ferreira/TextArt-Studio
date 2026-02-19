import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/sticker_entity.dart';
import '../../domain/repositories/sticker_repository.dart';
import 'sticker_event.dart';
import 'sticker_state.dart';

class StickerBloc extends Bloc<StickerEvent, StickerState> {
  final StickerRepository _repository;

  StickerBloc({required StickerRepository repository})
      : _repository = repository,
        super(const StickerState()) {
    on<StickerLoadByCategory>(_onLoadByCategory);
    on<StickerSearch>(_onSearch);

    add(const StickerLoadByCategory(StickerCategory.all));
  }

  Future<void> _onLoadByCategory(
      StickerLoadByCategory event, Emitter<StickerState> emit) async {
    emit(state.copyWith(
      status: StickerStatus.loading,
      selectedCategory: event.category,
    ));
    try {
      final stickers =
          await _repository.getStickersByCategory(event.category);
      emit(state.copyWith(status: StickerStatus.loaded, stickers: stickers));
    } catch (e) {
      emit(state.copyWith(
          status: StickerStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onSearch(
      StickerSearch event, Emitter<StickerState> emit) async {
    emit(state.copyWith(status: StickerStatus.loading));
    try {
      final stickers = event.query.isEmpty
          ? await _repository.getStickersByCategory(state.selectedCategory)
          : await _repository.searchStickers(event.query);
      emit(state.copyWith(status: StickerStatus.loaded, stickers: stickers));
    } catch (e) {
      emit(state.copyWith(
          status: StickerStatus.error, errorMessage: e.toString()));
    }
  }
}
