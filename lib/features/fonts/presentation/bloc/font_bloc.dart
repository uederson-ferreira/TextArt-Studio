import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/font_entity.dart';
import '../../domain/repositories/font_repository.dart';
import 'font_event.dart';
import 'font_state.dart';

class FontBloc extends Bloc<FontEvent, FontState> {
  final FontRepository _repository;

  FontBloc({required FontRepository repository})
      : _repository = repository,
        super(const FontState()) {
    on<FontLoadByCategory>(_onLoadByCategory);
    on<FontSearch>(_onSearch);
    on<FontSelect>(_onSelect);

    add(const FontLoadByCategory(FontCategory.all));
  }

  Future<void> _onLoadByCategory(
      FontLoadByCategory event, Emitter<FontState> emit) async {
    emit(state.copyWith(
      status: FontStatus.loading,
      selectedCategory: event.category,
    ));
    try {
      final fonts = await _repository.getFontsByCategory(event.category);
      emit(state.copyWith(status: FontStatus.loaded, fonts: fonts));
    } catch (e) {
      emit(state.copyWith(
          status: FontStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onSearch(FontSearch event, Emitter<FontState> emit) async {
    emit(state.copyWith(status: FontStatus.loading, searchQuery: event.query));
    try {
      final fonts = event.query.isEmpty
          ? await _repository.getFontsByCategory(state.selectedCategory)
          : await _repository.searchFonts(event.query);
      emit(state.copyWith(status: FontStatus.loaded, fonts: fonts));
    } catch (e) {
      emit(state.copyWith(
          status: FontStatus.error, errorMessage: e.toString()));
    }
  }

  void _onSelect(FontSelect event, Emitter<FontState> emit) {
    emit(state.copyWith(selectedFamily: event.family));
  }
}
