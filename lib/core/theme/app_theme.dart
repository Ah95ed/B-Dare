import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Helper function to get appropriate TextTheme based on locale
TextTheme _getTextThemeForLocale(String? languageCode, bool isDark) {
  // CJK languages (Chinese, Japanese, Korean)
  if (['zh', 'ja', 'ko'].contains(languageCode)) {
    final baseTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    return GoogleFonts.notoSansTextTheme(baseTheme);
  }
  
  // Devanagari (Hindi)
  if (languageCode == 'hi') {
    final baseTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    return GoogleFonts.notoSansDevanagariTextTheme(baseTheme);
  }
  
  // Thai
  if (languageCode == 'th') {
    final baseTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    return GoogleFonts.notoSansThaiTextTheme(baseTheme);
  }
  
  // Arabic
  if (languageCode == 'ar') {
    final baseTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    return GoogleFonts.cairoTextTheme(baseTheme);
  }
  
  // Default for Latin-based languages
  final baseTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
  return GoogleFonts.notoSansTextTheme(baseTheme);
}

class AppTheme {
  static ThemeData lightTheme({bool dynamicColors = false, Locale? locale}) {
    final seed = dynamicColors ? AppColors.cardEnd : AppColors.primary;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
        primary: seed,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardTheme: CardThemeData(
        elevation: 2,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: _getTextThemeForLocale(locale?.languageCode, false).copyWith(
        displayLarge: _getTextThemeForLocale(locale?.languageCode, false).displayLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: _getTextThemeForLocale(locale?.languageCode, false).displayMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        bodyLarge: _getTextThemeForLocale(locale?.languageCode, false).bodyLarge?.copyWith(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: _getTextThemeForLocale(locale?.languageCode, false).bodyMedium?.copyWith(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }
  
  static ThemeData darkTheme({bool dynamicColors = false, Locale? locale}) {
    final seed = dynamicColors ? AppColors.cardStart : AppColors.primaryLight;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
        primary: seed,
        secondary: AppColors.secondaryLight,
        error: AppColors.error,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardTheme: CardThemeData(
        elevation: 2,
        color: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: _getTextThemeForLocale(locale?.languageCode, true).copyWith(
        displayLarge: _getTextThemeForLocale(locale?.languageCode, true).displayLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        displayMedium: _getTextThemeForLocale(locale?.languageCode, true).displayMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        bodyLarge: _getTextThemeForLocale(locale?.languageCode, true).bodyLarge?.copyWith(
          fontSize: 16,
          color: AppColors.textDark,
        ),
        bodyMedium: _getTextThemeForLocale(locale?.languageCode, true).bodyMedium?.copyWith(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.surfaceDark,
      ),
    );
  }
}

