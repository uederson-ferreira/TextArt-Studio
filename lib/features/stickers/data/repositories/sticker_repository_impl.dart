import '../../domain/entities/sticker_entity.dart';
import '../../domain/repositories/sticker_repository.dart';

/// Curated set of emoji stickers for MVP.
/// In full implementation, loads SVGs from assets/stickers/ and CDN.
class StickerRepositoryImpl implements StickerRepository {
  static final _stickers = [
    // Faces
    const StickerEntity(
        id: '1f600', name: 'Grinning', assetPath: '😀', category: StickerCategory.faces),
    const StickerEntity(
        id: '1f601', name: 'Beaming', assetPath: '😁', category: StickerCategory.faces),
    const StickerEntity(
        id: '1f602', name: 'Tears of Joy', assetPath: '😂', category: StickerCategory.faces),
    const StickerEntity(
        id: '1f923', name: 'ROFL', assetPath: '🤣', category: StickerCategory.faces),
    const StickerEntity(
        id: '1f60d', name: 'Heart Eyes', assetPath: '😍', category: StickerCategory.faces),
    const StickerEntity(
        id: '1f618', name: 'Kiss', assetPath: '😘', category: StickerCategory.faces),
    const StickerEntity(
        id: '1f621', name: 'Angry', assetPath: '😡', category: StickerCategory.faces),
    const StickerEntity(
        id: '1f622', name: 'Crying', assetPath: '😢', category: StickerCategory.faces),

    // Gestures
    const StickerEntity(
        id: '1f44d', name: 'Thumbs Up', assetPath: '👍', category: StickerCategory.gestures),
    const StickerEntity(
        id: '1f44e', name: 'Thumbs Down', assetPath: '👎', category: StickerCategory.gestures),
    const StickerEntity(
        id: '1f44f', name: 'Clapping', assetPath: '👏', category: StickerCategory.gestures),
    const StickerEntity(
        id: '1f64c', name: 'Raising Hands', assetPath: '🙌', category: StickerCategory.gestures),
    const StickerEntity(
        id: '1f91e', name: 'Fingers Crossed', assetPath: '🤞', category: StickerCategory.gestures),
    const StickerEntity(
        id: '270a', name: 'Raised Fist', assetPath: '✊', category: StickerCategory.gestures),
    const StickerEntity(
        id: '1f919', name: 'Call Me', assetPath: '🤙', category: StickerCategory.gestures),
    const StickerEntity(
        id: '1f4aa', name: 'Muscle', assetPath: '💪', category: StickerCategory.gestures),

    // Objects
    const StickerEntity(
        id: '2764', name: 'Heart', assetPath: '❤️', category: StickerCategory.objects),
    const StickerEntity(
        id: '1f525', name: 'Fire', assetPath: '🔥', category: StickerCategory.objects),
    const StickerEntity(
        id: '2b50', name: 'Star', assetPath: '⭐', category: StickerCategory.objects),
    const StickerEntity(
        id: '1f4ab', name: 'Dizzy', assetPath: '💫', category: StickerCategory.objects),
    const StickerEntity(
        id: '2728', name: 'Sparkles', assetPath: '✨', category: StickerCategory.objects),
    const StickerEntity(
        id: '1f389', name: 'Party Popper', assetPath: '🎉', category: StickerCategory.objects),
    const StickerEntity(
        id: '1f3a8', name: 'Palette', assetPath: '🎨', category: StickerCategory.objects),
    const StickerEntity(
        id: '1f48e', name: 'Gem Stone', assetPath: '💎', category: StickerCategory.objects),

    // Animals
    const StickerEntity(
        id: '1f98b', name: 'Butterfly', assetPath: '🦋', category: StickerCategory.animals),
    const StickerEntity(
        id: '1f436', name: 'Dog', assetPath: '🐶', category: StickerCategory.animals),
    const StickerEntity(
        id: '1f431', name: 'Cat', assetPath: '🐱', category: StickerCategory.animals),
    const StickerEntity(
        id: '1f984', name: 'Unicorn', assetPath: '🦄', category: StickerCategory.animals),
    const StickerEntity(
        id: '1f43c', name: 'Panda', assetPath: '🐼', category: StickerCategory.animals),
    const StickerEntity(
        id: '1f98a', name: 'Fox', assetPath: '🦊', category: StickerCategory.animals),
    const StickerEntity(
        id: '1f43b', name: 'Bear', assetPath: '🐻', category: StickerCategory.animals),
    const StickerEntity(
        id: '1f99c', name: 'Parrot', assetPath: '🦜', category: StickerCategory.animals),

    // Food
    const StickerEntity(
        id: '1f355', name: 'Pizza', assetPath: '🍕', category: StickerCategory.food),
    const StickerEntity(
        id: '1f354', name: 'Burger', assetPath: '🍔', category: StickerCategory.food),
    const StickerEntity(
        id: '1f369', name: 'Donut', assetPath: '🍩', category: StickerCategory.food),
    const StickerEntity(
        id: '1f370', name: 'Cake', assetPath: '🎂', category: StickerCategory.food),
    const StickerEntity(
        id: '1f353', name: 'Strawberry', assetPath: '🍓', category: StickerCategory.food),
    const StickerEntity(
        id: '1f36a', name: 'Cookie', assetPath: '🍪', category: StickerCategory.food),

    // Symbols
    const StickerEntity(
        id: '1f31f', name: 'Glowing Star', assetPath: '🌟', category: StickerCategory.symbols),
    const StickerEntity(
        id: '1f4af', name: '100', assetPath: '💯', category: StickerCategory.symbols),
    const StickerEntity(
        id: '2705', name: 'Check Mark', assetPath: '✅', category: StickerCategory.symbols),
    const StickerEntity(
        id: '1f3c6', name: 'Trophy', assetPath: '🏆', category: StickerCategory.symbols),
    const StickerEntity(
        id: '1f4a5', name: 'Collision', assetPath: '💥', category: StickerCategory.symbols),
    const StickerEntity(
        id: '1f514', name: 'Bell', assetPath: '🔔', category: StickerCategory.symbols),

    // Shapes (using emoji as placeholder until SVG assets added)
    const StickerEntity(
        id: 'shape_heart', name: 'Heart Shape', assetPath: '♥️', category: StickerCategory.shapes),
    const StickerEntity(
        id: 'shape_star', name: 'Star Shape', assetPath: '★', category: StickerCategory.shapes),
    const StickerEntity(
        id: 'shape_circle', name: 'Circle', assetPath: '⬤', category: StickerCategory.shapes),
    const StickerEntity(
        id: 'shape_square', name: 'Square', assetPath: '■', category: StickerCategory.shapes),
  ];

  @override
  Future<List<StickerEntity>> getStickersByCategory(
      StickerCategory category) async {
    if (category == StickerCategory.all) return _stickers;
    return _stickers.where((s) => s.category == category).toList();
  }

  @override
  Future<List<StickerEntity>> searchStickers(String query) async {
    final lower = query.toLowerCase();
    return _stickers
        .where((s) => s.name.toLowerCase().contains(lower))
        .toList();
  }
}
