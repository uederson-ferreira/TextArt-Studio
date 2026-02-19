import 'package:flutter/material.dart';

/// TextArt Studio — Design Tokens de Cor
///
/// Paleta baseada em dark-first com identidade
/// Violeta (#7C3AED) → Rosa (#EC4899) como gradiente da marca.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // MARCA
  // ---------------------------------------------------------------------------

  /// Violeta Criativo — cor primária da marca
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF9D65F5);
  static const Color primaryDark = Color(0xFF5B1FBF);

  /// Rosa Vibrante — cor secundária / gradiente
  static const Color secondary = Color(0xFFEC4899);
  static const Color secondaryLight = Color(0xFFF472B6);
  static const Color secondaryDark = Color(0xFFBE185D);

  /// Dourado Premium — badges, upsell, estrela
  static const Color premium = Color(0xFFF59E0B);
  static const Color premiumLight = Color(0xFFFBBF24);
  static const Color premiumDark = Color(0xFFD97706);

  // ---------------------------------------------------------------------------
  // GRADIENTES DA MARCA
  // ---------------------------------------------------------------------------

  static const LinearGradient gradientBrand = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient gradientBrandDiagonal = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientPremium = LinearGradient(
    colors: [premium, Color(0xFFEF4444)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient gradientDarkBackground = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF0A0A0F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ---------------------------------------------------------------------------
  // BACKGROUNDS — DARK MODE
  // ---------------------------------------------------------------------------

  /// Tela principal (mais escura)
  static const Color backgroundDark = Color(0xFF0A0A0F);

  /// Cards, modais
  static const Color surfaceDark = Color(0xFF13131C);

  /// Elementos elevados
  static const Color surfaceElevatedDark = Color(0xFF1C1C2A);

  /// Itens de lista, inputs
  static const Color surfaceHighDark = Color(0xFF252538);

  /// Separadores, bordas
  static const Color dividerDark = Color(0xFF2E2E45);

  // ---------------------------------------------------------------------------
  // BACKGROUNDS — LIGHT MODE
  // ---------------------------------------------------------------------------

  static const Color backgroundLight = Color(0xFFF8F8FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFF0F0F8);
  static const Color surfaceHighLight = Color(0xFFE8E8F4);
  static const Color dividerLight = Color(0xFFD8D8EC);

  // ---------------------------------------------------------------------------
  // TEXTO — DARK MODE
  // ---------------------------------------------------------------------------

  static const Color textPrimaryDark = Color(0xFFF4F4FF);
  static const Color textSecondaryDark = Color(0xFFA0A0C0);
  static const Color textDisabledDark = Color(0xFF4A4A6A);

  // ---------------------------------------------------------------------------
  // TEXTO — LIGHT MODE
  // ---------------------------------------------------------------------------

  static const Color textPrimaryLight = Color(0xFF0A0A1E);
  static const Color textSecondaryLight = Color(0xFF5A5A80);
  static const Color textDisabledLight = Color(0xFF9A9AB8);

  // ---------------------------------------------------------------------------
  // SEMÂNTICAS
  // ---------------------------------------------------------------------------

  static const Color success = Color(0xFF22C55E);
  static const Color successBackground = Color(0xFF14532D);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBackground = Color(0xFF78350F);

  static const Color error = Color(0xFFEF4444);
  static const Color errorBackground = Color(0xFF7F1D1D);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoBackground = Color(0xFF1E3A5F);

  // ---------------------------------------------------------------------------
  // UTILITÁRIOS
  // ---------------------------------------------------------------------------

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  /// Overlay escuro para modais e bottom sheets
  static const Color overlay = Color(0x99000000);

  /// Glow do elemento selecionado no canvas
  static const Color canvasSelectionGlow = Color(0x557C3AED);

  /// Cor da marca d'água nas exportações free
  static const Color watermark = Color(0x99FFFFFF);

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  /// Cor primária com opacidade
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);

  /// Cor secundária com opacidade
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withValues(alpha: opacity);

  /// Overlay de premium lock sobre conteúdo bloqueado
  static const Color premiumLockOverlay = Color(0xCC0A0A0F);
}
