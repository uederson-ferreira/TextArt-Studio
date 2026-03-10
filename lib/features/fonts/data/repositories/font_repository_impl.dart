import '../../domain/entities/font_entity.dart';
import '../../domain/repositories/font_repository.dart';
import 'featured_fonts.dart';

/// Offline-first implementation.
/// Returns a curated list of popular Google Fonts for the MVP.
class FontRepositoryImpl implements FontRepository {
  static const _fonts = [
    FontEntity(family: 'Roboto', category: FontCategory.sansSerif),
    FontEntity(family: 'Open Sans', category: FontCategory.sansSerif),
    FontEntity(family: 'Lato', category: FontCategory.sansSerif),
    FontEntity(family: 'Montserrat', category: FontCategory.sansSerif),
    FontEntity(family: 'Oswald', category: FontCategory.sansSerif),
    FontEntity(family: 'Raleway', category: FontCategory.sansSerif),
    FontEntity(family: 'Poppins', category: FontCategory.sansSerif),
    FontEntity(family: 'Inter', category: FontCategory.sansSerif),
    FontEntity(family: 'Nunito', category: FontCategory.sansSerif),
    FontEntity(family: 'Ubuntu', category: FontCategory.sansSerif),
    FontEntity(family: 'Comfortaa', category: FontCategory.sansSerif),
    FontEntity(family: 'Playfair Display', category: FontCategory.serif),
    FontEntity(family: 'Merriweather', category: FontCategory.serif),
    FontEntity(family: 'Lora', category: FontCategory.serif),
    FontEntity(family: 'PT Serif', category: FontCategory.serif),
    FontEntity(family: 'Crimson Text', category: FontCategory.serif),
    FontEntity(family: 'Pacifico', category: FontCategory.handwriting),
    FontEntity(family: 'Dancing Script', category: FontCategory.handwriting),
    FontEntity(family: 'Satisfy', category: FontCategory.handwriting),
    FontEntity(family: 'Caveat', category: FontCategory.handwriting),
    FontEntity(family: 'Kalam', category: FontCategory.handwriting),
    FontEntity(family: 'Sacramento', category: FontCategory.handwriting),
    FontEntity(family: 'Great Vibes', category: FontCategory.handwriting),
    FontEntity(family: 'Kaushan Script', category: FontCategory.handwriting),
    FontEntity(family: 'Permanent Marker', category: FontCategory.handwriting),
    FontEntity(family: 'Bebas Neue', category: FontCategory.display),
    FontEntity(family: 'Anton', category: FontCategory.display),
    FontEntity(family: 'Righteous', category: FontCategory.display),
    FontEntity(family: 'Abril Fatface', category: FontCategory.display),
    FontEntity(family: 'Fredoka One', category: FontCategory.display),
    FontEntity(family: 'Lobster', category: FontCategory.display),
    FontEntity(family: 'Bangers', category: FontCategory.display),
    FontEntity(family: 'Amatic SC', category: FontCategory.display),
    FontEntity(family: 'Titan One', category: FontCategory.display),
    FontEntity(family: 'Bungee', category: FontCategory.display),
    FontEntity(family: 'Alfa Slab One', category: FontCategory.display),
    FontEntity(family: 'Cinzel Decorative', category: FontCategory.display),
    FontEntity(family: 'Monoton', category: FontCategory.display),
    FontEntity(
        family: 'Source Code Pro', category: FontCategory.monospace),
    FontEntity(
        family: 'JetBrains Mono', category: FontCategory.monospace),
    FontEntity(family: 'Fira Code', category: FontCategory.monospace),
  ];

  @override
  Future<List<FontEntity>> getFontsByCategory(FontCategory category) async {
    if (category == FontCategory.all) return _fonts;
    return _fonts.where((f) => f.category == category).toList();
  }

  @override
  Future<List<FontEntity>> searchFonts(String query) async {
    final lower = query.toLowerCase();
    return _fonts
        .where((f) => f.family.toLowerCase().contains(lower))
        .toList();
  }

  @override
  Future<List<FontEntity>> getFeaturedFonts() async {
    // Return fonts that match featured list, preserving featured order
    final Map<String, FontEntity> fontMap = {for (final f in _fonts) f.family: f};
    final result = <FontEntity>[];
    for (final family in featuredFontFamilies) {
      if (fontMap.containsKey(family)) {
        result.add(fontMap[family]!);
      } else {
        // Include with display category as fallback
        result.add(FontEntity(family: family, category: FontCategory.display));
      }
    }
    return result;
  }

  @override
  Future<void> cacheFont(String family) async {
    // google_fonts caches automatically — no-op for MVP
  }

  @override
  Future<bool> isFontCached(String family) async => true;
}
