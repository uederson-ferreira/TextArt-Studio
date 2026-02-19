import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// TextArt Studio — Design Tokens de Tipografia
///
/// Hierarquia tipográfica completa usando:
/// - Poppins: headlines e display (expressivo, geométrico)
/// - Inter: body e labels (legível, profissional)
abstract final class AppTypography {
  // ---------------------------------------------------------------------------
  // DISPLAY — Poppins Bold
  // Uso: splash screen, onboarding, títulos grandes
  // ---------------------------------------------------------------------------

  static TextStyle displayLarge({Color? color}) => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: color ?? AppColors.textPrimaryDark,
      );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.2,
        color: color ?? AppColors.textPrimaryDark,
      );

  // ---------------------------------------------------------------------------
  // HEADLINE — Poppins SemiBold
  // Uso: títulos de tela e seção
  // ---------------------------------------------------------------------------

  static TextStyle headlineLarge({Color? color}) => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.25,
        color: color ?? AppColors.textPrimaryDark,
      );

  static TextStyle headlineMedium({Color? color}) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.3,
        color: color ?? AppColors.textPrimaryDark,
      );

  static TextStyle headlineSmall({Color? color}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.3,
        color: color ?? AppColors.textPrimaryDark,
      );

  // ---------------------------------------------------------------------------
  // TITLE — Inter SemiBold / Medium
  // Uso: títulos de card, nome de seção
  // ---------------------------------------------------------------------------

  static TextStyle titleLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.35,
        color: color ?? AppColors.textPrimaryDark,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
        color: color ?? AppColors.textPrimaryDark,
      );

  static TextStyle titleSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
        color: color ?? AppColors.textSecondaryDark,
      );

  // ---------------------------------------------------------------------------
  // BODY — Inter Regular
  // Uso: texto corrido, descrições
  // ---------------------------------------------------------------------------

  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5,
        color: color ?? AppColors.textPrimaryDark,
      );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
        color: color ?? AppColors.textSecondaryDark,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.5,
        color: color ?? AppColors.textSecondaryDark,
      );

  // ---------------------------------------------------------------------------
  // LABEL — Inter SemiBold / Medium
  // Uso: botões, chips, tags, badges
  // ---------------------------------------------------------------------------

  static TextStyle labelLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.3,
        color: color ?? AppColors.textPrimaryDark,
      );

  static TextStyle labelMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.3,
        color: color ?? AppColors.textPrimaryDark,
      );

  static TextStyle labelSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.3,
        color: color ?? AppColors.textSecondaryDark,
      );

  // ---------------------------------------------------------------------------
  // CAPTION / OVERLINE
  // ---------------------------------------------------------------------------

  static TextStyle caption({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.4,
        color: color ?? AppColors.textDisabledDark,
      );

  static TextStyle overline({Color? color}) => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        height: 1.6,
        color: color ?? AppColors.textSecondaryDark,
      );

  // ---------------------------------------------------------------------------
  // TEXTTHEME — para uso no ThemeData
  // ---------------------------------------------------------------------------

  static TextTheme buildTextTheme({required bool isDark}) {
    final defaultColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return TextTheme(
      displayLarge: displayLarge(color: defaultColor),
      displayMedium: displayMedium(color: defaultColor),
      displaySmall: headlineLarge(color: defaultColor),
      headlineLarge: headlineLarge(color: defaultColor),
      headlineMedium: headlineMedium(color: defaultColor),
      headlineSmall: headlineSmall(color: defaultColor),
      titleLarge: titleLarge(color: defaultColor),
      titleMedium: titleMedium(color: defaultColor),
      titleSmall: titleSmall(color: secondaryColor),
      bodyLarge: bodyLarge(color: defaultColor),
      bodyMedium: bodyMedium(color: secondaryColor),
      bodySmall: bodySmall(color: secondaryColor),
      labelLarge: labelLarge(color: defaultColor),
      labelMedium: labelMedium(color: defaultColor),
      labelSmall: labelSmall(color: secondaryColor),
    );
  }
}
