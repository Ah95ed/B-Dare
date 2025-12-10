import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/supported_languages.dart';

class AppSettingsState {
  final Locale locale;
  final double textScale;
  final ThemeMode themeMode;
  final bool enableDynamicColors;
  final bool enableMotion;

  const AppSettingsState({
    required this.locale,
    required this.textScale,
    required this.themeMode,
    required this.enableDynamicColors,
    required this.enableMotion,
  });

  AppSettingsState copyWith({
    Locale? locale,
    double? textScale,
    ThemeMode? themeMode,
    bool? enableDynamicColors,
    bool? enableMotion,
  }) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      textScale: textScale ?? this.textScale,
      themeMode: themeMode ?? this.themeMode,
      enableDynamicColors: enableDynamicColors ?? this.enableDynamicColors,
      enableMotion: enableMotion ?? this.enableMotion,
    );
  }
}

class AppSettingsCubit extends Cubit<AppSettingsState> {
  static const String _localeKey = 'app_locale';
  static const String _textScaleKey = 'app_text_scale';
  static const String _themeModeKey = 'app_theme_mode';
  static const String _dynamicColorsKey = 'app_dynamic_colors';
  static const String _motionKey = 'app_motion_enabled';

  AppSettingsCubit() : super(_defaultState()) {
    _loadSettings();
  }

  static AppSettingsState _defaultState() {
    return AppSettingsState(
      locale: SupportedLanguages.english.locale,
      textScale: 1.0,
      themeMode: ThemeMode.system,
      enableDynamicColors: true,
      enableMotion: true,
    );
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Language
      final localeCode = prefs.getString(_localeKey);
      Locale locale = SupportedLanguages.english.locale;
      if (localeCode != null) {
        final supportedLang = SupportedLanguages.all.firstWhere(
          (lang) => lang.code == localeCode,
          orElse: () => SupportedLanguages.english,
        );
        locale = supportedLang.locale;
      }

      // Text scale
      final textScale = prefs.getDouble(_textScaleKey) ?? 1.0;
      final themeIndex = prefs.getInt(_themeModeKey);
      final dynamicColors = prefs.getBool(_dynamicColorsKey) ?? true;
      final motionEnabled = prefs.getBool(_motionKey) ?? true;

      final themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.index == (themeIndex ?? ThemeMode.system.index),
        orElse: () => ThemeMode.system,
      );

      emit(
        AppSettingsState(
          locale: locale,
          textScale: textScale,
          themeMode: themeMode,
          enableDynamicColors: dynamicColors,
          enableMotion: motionEnabled,
        ),
      );
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
      emit(state.copyWith(locale: locale));
    } catch (e) {
      debugPrint('Error saving locale: $e');
      emit(state.copyWith(locale: locale));
    }
  }

  Future<void> setTextScale(double scale) async {
    try {
      final safeScale = scale.clamp(0.8, 1.6);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_textScaleKey, safeScale);
      emit(state.copyWith(textScale: safeScale.toDouble()));
    } catch (e) {
      debugPrint('Error saving text scale: $e');
      final safeScale = scale.clamp(0.8, 1.6);
      emit(state.copyWith(textScale: safeScale.toDouble()));
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, themeMode.index);
      emit(state.copyWith(themeMode: themeMode));
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
      emit(state.copyWith(themeMode: themeMode));
    }
  }

  Future<void> setDynamicColorsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_dynamicColorsKey, enabled);
      emit(state.copyWith(enableDynamicColors: enabled));
    } catch (e) {
      debugPrint('Error saving dynamic colors setting: $e');
      emit(state.copyWith(enableDynamicColors: enabled));
    }
  }

  Future<void> setMotionEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_motionKey, enabled);
      emit(state.copyWith(enableMotion: enabled));
    } catch (e) {
      debugPrint('Error saving motion preference: $e');
      emit(state.copyWith(enableMotion: enabled));
    }
  }
}
