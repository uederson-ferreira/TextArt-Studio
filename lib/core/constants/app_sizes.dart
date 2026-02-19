/// TextArt Studio — Design Tokens de Espaçamento
///
/// Grade de 4px: todos os valores são múltiplos de 4.
abstract final class AppSizes {
  // ---------------------------------------------------------------------------
  // ESPAÇAMENTO (4px grid)
  // ---------------------------------------------------------------------------

  static const double space2 = 2;
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space56 = 56;
  static const double space64 = 64;
  static const double space80 = 80;
  static const double space96 = 96;

  // ---------------------------------------------------------------------------
  // BORDER RADIUS
  // ---------------------------------------------------------------------------

  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radius2xl = 24;
  static const double radiusCircle = 999;

  // ---------------------------------------------------------------------------
  // ÍCONES
  // ---------------------------------------------------------------------------

  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 40;
  static const double iconXxl = 48;

  // ---------------------------------------------------------------------------
  // BOTÕES
  // ---------------------------------------------------------------------------

  static const double buttonHeight = 48;
  static const double buttonHeightSm = 36;
  static const double buttonHeightLg = 56;

  // ---------------------------------------------------------------------------
  // TOOLBAR DO EDITOR
  // ---------------------------------------------------------------------------

  static const double toolbarHeight = 64;
  static const double toolbarBottomHeight = 80;
  static const double toolbarIconSize = 28;

  // ---------------------------------------------------------------------------
  // CANVAS
  // ---------------------------------------------------------------------------

  static const double canvasMinScale = 0.5;
  static const double canvasMaxScale = 5.0;
  static const double handleSize = 24;

  // ---------------------------------------------------------------------------
  // DURAÇÕES DE ANIMAÇÃO
  // ---------------------------------------------------------------------------

  /// Animações rápidas (hover, ripple)
  static const int durationFast = 150;

  /// Animações padrão (transições de tela)
  static const int durationNormal = 250;

  /// Animações suaves (bottom sheet, modal)
  static const int durationSlow = 350;

  /// Animações elaboradas (onboarding)
  static const int durationXSlow = 500;

  // ---------------------------------------------------------------------------
  // ELEVAÇÃO
  // ---------------------------------------------------------------------------

  static const double elevationNone = 0;
  static const double elevationSm = 2;
  static const double elevationMd = 4;
  static const double elevationLg = 8;

  // ---------------------------------------------------------------------------
  // OUTROS
  // ---------------------------------------------------------------------------

  static const double borderWidth = 1;
  static const double borderWidthFocus = 1.5;
  static const double dividerThickness = 1;

  /// Altura da barra de status + AppBar
  static const double appBarHeight = 56;

  /// Padding lateral padrão das telas
  static const double screenPadding = 16;

  /// Padding lateral maior (tablets)
  static const double screenPaddingLg = 24;
}
