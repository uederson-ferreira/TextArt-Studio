import 'package:equatable/equatable.dart';
import '../../domain/entities/sticker_entity.dart';

enum StickerStatus { initial, loading, loaded, error }

class StickerState extends Equatable {
  final StickerStatus status;
  final List<StickerEntity> stickers;
  final StickerCategory selectedCategory;
  final String? errorMessage;

  const StickerState({
    this.status = StickerStatus.initial,
    this.stickers = const [],
    this.selectedCategory = StickerCategory.all,
    this.errorMessage,
  });

  StickerState copyWith({
    StickerStatus? status,
    List<StickerEntity>? stickers,
    StickerCategory? selectedCategory,
    String? errorMessage,
  }) {
    return StickerState(
      status: status ?? this.status,
      stickers: stickers ?? this.stickers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, stickers, selectedCategory, errorMessage];
}
