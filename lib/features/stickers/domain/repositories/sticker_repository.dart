import '../entities/sticker_entity.dart';

abstract class StickerRepository {
  Future<List<StickerEntity>> getStickersByCategory(StickerCategory category);
  Future<List<StickerEntity>> searchStickers(String query);
}
