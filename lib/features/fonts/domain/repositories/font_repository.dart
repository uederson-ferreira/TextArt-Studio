import '../entities/font_entity.dart';

abstract class FontRepository {
  Future<List<FontEntity>> getFontsByCategory(FontCategory category);
  Future<List<FontEntity>> searchFonts(String query);
  Future<void> cacheFont(String family);
  Future<bool> isFontCached(String family);
}
