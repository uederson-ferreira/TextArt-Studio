import 'package:equatable/equatable.dart';
import '../../domain/entities/sticker_entity.dart';

abstract class StickerEvent extends Equatable {
  const StickerEvent();

  @override
  List<Object?> get props => [];
}

class StickerLoadByCategory extends StickerEvent {
  final StickerCategory category;
  const StickerLoadByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class StickerSearch extends StickerEvent {
  final String query;
  const StickerSearch(this.query);

  @override
  List<Object?> get props => [query];
}
