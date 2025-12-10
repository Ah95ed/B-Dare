import 'package:flutter/material.dart';

class SupportedLanguage {
  final String code;
  final String name;
  final Locale locale;

  const SupportedLanguage({
    required this.code,
    required this.name,
    required this.locale,
  });
}

class SupportedLanguages {
  static const english = SupportedLanguage(
    code: 'en',
    name: 'English',
    locale: Locale('en'),
  );

  static const arabic = SupportedLanguage(
    code: 'ar',
    name: 'العربية',
    locale: Locale('ar'),
  );

  static const spanish = SupportedLanguage(
    code: 'es',
    name: 'Español',
    locale: Locale('es'),
  );

  static const french = SupportedLanguage(
    code: 'fr',
    name: 'Français',
    locale: Locale('fr'),
  );

  // Phase 1: High Priority Languages
  static const chinese = SupportedLanguage(
    code: 'zh',
    name: '中文',
    locale: Locale('zh', 'CN'),
  );

  static const hindi = SupportedLanguage(
    code: 'hi',
    name: 'हिन्दी',
    locale: Locale('hi'),
  );

  static const portuguese = SupportedLanguage(
    code: 'pt',
    name: 'Português',
    locale: Locale('pt', 'BR'),
  );

  static const russian = SupportedLanguage(
    code: 'ru',
    name: 'Русский',
    locale: Locale('ru'),
  );

  // Phase 2: Medium Priority Languages
  static const japanese = SupportedLanguage(
    code: 'ja',
    name: '日本語',
    locale: Locale('ja'),
  );

  static const german = SupportedLanguage(
    code: 'de',
    name: 'Deutsch',
    locale: Locale('de'),
  );

  static const italian = SupportedLanguage(
    code: 'it',
    name: 'Italiano',
    locale: Locale('it'),
  );

  static const korean = SupportedLanguage(
    code: 'ko',
    name: '한국어',
    locale: Locale('ko'),
  );

  // Phase 3: Lower Priority Languages
  static const turkish = SupportedLanguage(
    code: 'tr',
    name: 'Türkçe',
    locale: Locale('tr'),
  );

  static const vietnamese = SupportedLanguage(
    code: 'vi',
    name: 'Tiếng Việt',
    locale: Locale('vi'),
  );

  static const thai = SupportedLanguage(
    code: 'th',
    name: 'ไทย',
    locale: Locale('th'),
  );

  static const polish = SupportedLanguage(
    code: 'pl',
    name: 'Polski',
    locale: Locale('pl'),
  );

  static const List<SupportedLanguage> all = [
    english,
    arabic,
    spanish,
    french,
    // Phase 1
    chinese,
    hindi,
    portuguese,
    russian,
    // Phase 2
    japanese,
    german,
    italian,
    korean,
    // Phase 3
    turkish,
    vietnamese,
    thai,
    polish,
  ];

  static List<Locale> get locales => all.map((lang) => lang.locale).toList();

  static SupportedLanguage resolve(Locale locale) {
    return all.firstWhere(
      (lang) => lang.locale.languageCode == locale.languageCode,
      orElse: () => english,
    );
  }
}
