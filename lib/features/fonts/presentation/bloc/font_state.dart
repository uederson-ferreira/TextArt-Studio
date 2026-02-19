import 'package:equatable/equatable.dart';
import '../../domain/entities/font_entity.dart';

enum FontStatus { initial, loading, loaded, error }

class FontState extends Equatable {
  final FontStatus status;
  final List<FontEntity> fonts;
  final FontCategory selectedCategory;
  final String searchQuery;
  final String? selectedFamily;
  final String? errorMessage;

  const FontState({
    this.status = FontStatus.initial,
    this.fonts = const [],
    this.selectedCategory = FontCategory.all,
    this.searchQuery = '',
    this.selectedFamily,
    this.errorMessage,
  });

  FontState copyWith({
    FontStatus? status,
    List<FontEntity>? fonts,
    FontCategory? selectedCategory,
    String? searchQuery,
    String? selectedFamily,
    String? errorMessage,
  }) {
    return FontState(
      status: status ?? this.status,
      fonts: fonts ?? this.fonts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFamily: selectedFamily ?? this.selectedFamily,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        fonts,
        selectedCategory,
        searchQuery,
        selectedFamily,
        errorMessage,
      ];
}
