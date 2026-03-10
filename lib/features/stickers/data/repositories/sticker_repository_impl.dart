import '../../domain/entities/sticker_entity.dart';
import '../../domain/repositories/sticker_repository.dart';
import 'all_emojis.dart';
import 'local_svg_stickers.dart';

/// Merges emoji stickers with local SVG shapes.
class StickerRepositoryImpl implements StickerRepository {
  static final List<StickerEntity> _all = [...allEmojis, ...localSvgStickers];

  @override
  Future<List<StickerEntity>> getStickersByCategory(
      StickerCategory category) async {
    if (category == StickerCategory.all) return _all;
    return _all.where((s) => s.category == category).toList();
  }

  @override
  Future<List<StickerEntity>> searchStickers(String query) async {
    final lower = query.toLowerCase();
    return _all.where((s) => s.name.toLowerCase().contains(lower)).toList();
  }
}
