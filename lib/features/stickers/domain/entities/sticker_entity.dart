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

class StickerEntity extends Equatable {
  final String id;
  final String name;
  final String assetPath;
  final StickerCategory category;
  final bool isPremium;
  final bool isLocal;

  const StickerEntity({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.category,
    this.isPremium = false,
    this.isLocal = true,
  });

  @override
  List<Object?> get props =>
      [id, name, assetPath, category, isPremium, isLocal];
}
