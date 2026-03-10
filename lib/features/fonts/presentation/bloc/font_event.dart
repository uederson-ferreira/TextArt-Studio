import 'package:equatable/equatable.dart';
import '../../domain/entities/font_entity.dart';

abstract class FontEvent extends Equatable {
  const FontEvent();

  @override
  List<Object?> get props => [];
}

class FontLoadByCategory extends FontEvent {
  final FontCategory category;
  const FontLoadByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class FontSearch extends FontEvent {
  final String query;
  const FontSearch(this.query);

  @override
  List<Object?> get props => [query];
}

class FontSelect extends FontEvent {
  final String family;
  const FontSelect(this.family);

  @override
  List<Object?> get props => [family];
}

class FontLoadFeatured extends FontEvent {
  const FontLoadFeatured();
}
