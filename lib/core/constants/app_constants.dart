/// TextArt Studio — Constantes de Negócio
///
/// Limites do plano free, configurações do canvas,
/// chaves de cache e URLs de CDN.
abstract final class AppConstants {
  // ---------------------------------------------------------------------------
  // LIMITES DO PLANO FREE
  // ---------------------------------------------------------------------------

  /// Máximo de fontes disponíveis no plano free
  static const int freeFontLimit = 20;

  /// Máximo de projetos que usuário free pode salvar
  static const int freeProjectLimit = 3;

  /// Máximo de stickers por categoria no plano free
  static const int freeStickerLimit = 50;

  // ---------------------------------------------------------------------------
  // EDITOR / HISTÓRICO
  // ---------------------------------------------------------------------------

  /// Número máximo de estados de undo/redo
  static const int maxHistory = 30;

  /// Tamanho máximo de texto por elemento (caracteres)
  static const int maxTextLength = 500;

  /// Número máximo de elementos no canvas
  static const int maxElements = 50;

  // ---------------------------------------------------------------------------
  // EXPORT
  // ---------------------------------------------------------------------------

  /// Resolução padrão de exportação (pixelRatio)
  static const double exportPixelRatioFree = 2.0;
  static const double exportPixelRatioPremium = 4.0;

  /// Qualidade JPEG padrão (0-100)
  static const int exportJpegQuality = 90;

  // ---------------------------------------------------------------------------
  // CACHE / STORAGE
  // ---------------------------------------------------------------------------

  /// Chaves do Hive
  static const String hiveBoxFonts = 'fonts_cache';
  static const String hiveBoxStickers = 'stickers_cache';
  static const String hiveBoxProjects = 'projects';
  static const String hiveBoxSettings = 'settings';

  /// Chaves do SharedPreferences
  static const String prefThemeMode = 'theme_mode';
  static const String prefOnboardingDone = 'onboarding_done';
  static const String prefUserId = 'user_id';

  // ---------------------------------------------------------------------------
  // CDN / URLs
  // ---------------------------------------------------------------------------

  /// Base URL para stickers Twemoji via jsDelivr
  static const String twemojiCdnBase =
      'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/';

  // ---------------------------------------------------------------------------
  // FONTES
  // ---------------------------------------------------------------------------

  /// Categorias de fontes disponíveis
  static const List<String> fontCategories = [
    'Todos',
    'Sem Serifa',
    'Com Serifa',
    'Manuscrita',
    'Display',
    'Monoespaçada',
  ];

  // ---------------------------------------------------------------------------
  // STICKERS
  // ---------------------------------------------------------------------------

  /// Categorias de stickers disponíveis
  static const List<String> stickerCategories = [
    'Todos',
    'Rostos',
    'Gestos',
    'Objetos',
    'Animais',
    'Comida',
    'Símbolos',
    'Formas',
  ];

  // ---------------------------------------------------------------------------
  // CANVAS — CORES PREDEFINIDAS
  // ---------------------------------------------------------------------------

  /// Paleta de cores rápidas para o editor de texto
  static const List<int> quickColors = [
    0xFFFFFFFF, // White
    0xFF000000, // Black
    0xFFEF4444, // Red
    0xFFF97316, // Orange
    0xFFFBBF24, // Yellow
    0xFF22C55E, // Green
    0xFF06B6D4, // Cyan
    0xFF3B82F6, // Blue
    0xFF8B5CF6, // Purple
    0xFFEC4899, // Pink
    0xFFF472B6, // Light Pink
    0xFF14B8A6, // Teal
    0xFFA3E635, // Lime
    0xFFFF6B6B, // Coral
    0xFFFFD700, // Gold
    0xFFC084FC, // Lavender
    0xFF67E8F9, // Sky
    0xFFFDA4AF, // Rose
    0xFF86EFAC, // Mint
    0xFFD4D4D4, // Gray
  ];

  // ---------------------------------------------------------------------------
  // CANVAS — GRADIENTES PREDEFINIDOS
  // ---------------------------------------------------------------------------

  /// Presets de gradiente (cada entrada é uma lista de cores ARGB32)
  static const List<List<int>> gradientPresets = [
    [0xFFFF6B6B, 0xFFFFE66D],        // Sunset
    [0xFF8B5CF6, 0xFFEC4899],        // Galaxy
    [0xFF4ECDC4, 0xFF44A8C5],        // Ocean
    [0xFFF97316, 0xFFEF4444],        // Fire
    [0xFF22C55E, 0xFF06B6D4],        // Mint
    [0xFFEC4899, 0xFFF9A8D4],        // Pink
    [0xFFFBBF24, 0xFFF59E0B],        // Gold
    [0xFF6366F1, 0xFF8B5CF6],        // Purple
    [0xFFFFFFFF, 0xFFD1D5DB],        // Silver
    [0xFFFF6B6B, 0xFFEC4899, 0xFF8B5CF6], // Rainbow
  ];

  // ---------------------------------------------------------------------------
  // FIREBASE
  // ---------------------------------------------------------------------------

  static const String firestoreProjectsCollection = 'projects';
  static const String firestoreUsersCollection = 'users';
}
