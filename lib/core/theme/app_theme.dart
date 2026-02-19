import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

/// TextArt Studio — Tema Global
///
/// Fornece ThemeData completo para dark e light mode,
/// consistente com a identidade visual da marca.
abstract final class AppTheme {
  // ---------------------------------------------------------------------------
  // DARK THEME (padrão do app)
  // ---------------------------------------------------------------------------

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        textTheme: AppTypography.buildTextTheme(isDark: true),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        dividerColor: AppColors.dividerDark,

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: AppColors.textPrimaryDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: AppTypography.titleLarge(),
          iconTheme: const IconThemeData(
            color: AppColors.textPrimaryDark,
            size: 24,
          ),
        ),

        // Bottom Navigation Bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),

        // Cards
        cardTheme: CardThemeData(
          color: AppColors.surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.dividerDark, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),

        // Elevated Button (botão primário com gradiente via extension)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.surfaceHighDark,
            disabledForegroundColor: AppColors.textDisabledDark,
            elevation: 0,
            minimumSize: const Size(double.infinity, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTypography.labelLarge(),
          ),
        ),

        // Text Button
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: AppTypography.labelMedium(),
          ),
        ),

        // Outlined Button (botão secundário)
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimaryDark,
            backgroundColor: AppColors.surfaceHighDark,
            disabledForegroundColor: AppColors.textDisabledDark,
            elevation: 0,
            minimumSize: const Size(double.infinity, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            side: const BorderSide(color: AppColors.dividerDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTypography.labelLarge(),
          ),
        ),

        // Icon Button
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.textPrimaryDark,
            highlightColor: AppColors.primaryWithOpacity(0.1),
          ),
        ),

        // Input / TextField
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceHighDark,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.dividerDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: AppTypography.bodyMedium(color: AppColors.textDisabledDark),
          labelStyle:
              AppTypography.bodyMedium(color: AppColors.textSecondaryDark),
          prefixIconColor: AppColors.textSecondaryDark,
          suffixIconColor: AppColors.textSecondaryDark,
        ),

        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceHighDark,
          selectedColor: AppColors.primaryWithOpacity(0.2),
          disabledColor: AppColors.surfaceDark,
          labelStyle: AppTypography.labelMedium(),
          secondaryLabelStyle:
              AppTypography.labelMedium(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: const StadiumBorder(),
          side: const BorderSide(color: AppColors.dividerDark),
          selectedShadowColor: AppColors.transparent,
          shadowColor: AppColors.transparent,
        ),

        // Bottom Sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceDark,
          modalBackgroundColor: AppColors.surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surfaceElevatedDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titleTextStyle: AppTypography.titleLarge(),
          contentTextStyle:
              AppTypography.bodyMedium(color: AppColors.textSecondaryDark),
        ),

        // Slider
        sliderTheme: const SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.surfaceHighDark,
          thumbColor: AppColors.white,
          overlayColor: AppColors.canvasSelectionGlow,
          trackHeight: 3,
        ),

        // Switch
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.white;
            }
            return AppColors.textSecondaryDark;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return AppColors.surfaceHighDark;
          }),
        ),

        // Snack Bar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceHighDark,
          contentTextStyle:
              AppTypography.bodyMedium(color: AppColors.textPrimaryDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 4,
        ),

        // Progress Indicator
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.surfaceHighDark,
          circularTrackColor: AppColors.surfaceHighDark,
        ),

        // Tab Bar
        tabBarTheme: TabBarThemeData(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: AppTypography.labelMedium(color: AppColors.primary),
          unselectedLabelStyle: AppTypography.labelMedium(
              color: AppColors.textSecondaryDark),
          dividerColor: AppColors.dividerDark,
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: AppColors.dividerDark,
          thickness: 1,
          space: 1,
        ),

        // List Tile
        listTileTheme: ListTileThemeData(
          tileColor: Colors.transparent,
          selectedTileColor: AppColors.primaryWithOpacity(0.1),
          iconColor: AppColors.textSecondaryDark,
          textColor: AppColors.textPrimaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  // ---------------------------------------------------------------------------
  // LIGHT THEME
  // ---------------------------------------------------------------------------

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        textTheme: AppTypography.buildTextTheme(isDark: false),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        dividerColor: AppColors.dividerLight,

        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle:
              AppTypography.titleLarge(color: AppColors.textPrimaryLight),
          iconTheme: const IconThemeData(
            color: AppColors.textPrimaryLight,
            size: 24,
          ),
        ),

        cardTheme: CardThemeData(
          color: AppColors.surfaceLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.dividerLight, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            minimumSize: const Size(double.infinity, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTypography.labelLarge(color: AppColors.white),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceHighLight,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.dividerLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          hintStyle:
              AppTypography.bodyMedium(color: AppColors.textDisabledLight),
          labelStyle:
              AppTypography.bodyMedium(color: AppColors.textSecondaryLight),
        ),

        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceLight,
          modalBackgroundColor: AppColors.surfaceLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
      );

  // ---------------------------------------------------------------------------
  // COLOR SCHEMES
  // ---------------------------------------------------------------------------

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: Color(0xFF3B1A8A),
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    secondaryContainer: Color(0xFF831843),
    onSecondaryContainer: AppColors.secondaryLight,
    tertiary: AppColors.premium,
    onTertiary: AppColors.black,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    onSurfaceVariant: AppColors.textSecondaryDark,
    outline: AppColors.dividerDark,
    outlineVariant: Color(0xFF1C1C2A),
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: AppColors.surfaceLight,
    onInverseSurface: AppColors.textPrimaryLight,
    inversePrimary: AppColors.primaryDark,
  );

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: Color(0xFFEDE0FF),
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    secondaryContainer: Color(0xFFFFD8EC),
    onSecondaryContainer: AppColors.secondaryDark,
    tertiary: AppColors.premium,
    onTertiary: AppColors.black,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimaryLight,
    onSurfaceVariant: AppColors.textSecondaryLight,
    outline: AppColors.dividerLight,
    outlineVariant: Color(0xFFE8E8F4),
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: AppColors.surfaceDark,
    onInverseSurface: AppColors.textPrimaryDark,
    inversePrimary: AppColors.primaryLight,
  );
}

// ---------------------------------------------------------------------------
// EXTENSÕES — helpers para uso nos widgets
// ---------------------------------------------------------------------------

extension AppThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
