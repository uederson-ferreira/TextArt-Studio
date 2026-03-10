import 'package:equatable/equatable.dart';

enum StickerCategory {
  all,
  faces,
  gestures,
  objects,
  animals,
  food,
  symbols,
  shapes,
}

enum StickerRenderType { emoji, svg }

class StickerEntity extends Equatable {
  final String id;
  final String name;
  final String assetPath;
  final StickerCategory category;
  final bool isPremium;
  final bool isLocal;
  final StickerRenderType renderType;

  const StickerEntity({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.category,
    this.isPremium = false,
    this.isLocal = true,
    this.renderType = StickerRenderType.emoji,
  });

  @override
  List<Object?> get props =>
      [id, name, assetPath, category, isPremium, isLocal, renderType];
}
