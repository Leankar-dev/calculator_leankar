import 'dart:ui';

import 'package:calculator_05122025/models/language_option.dart';

abstract final class AppLanguages {
  static const Locale defaultLocale = Locale('pt', 'BR');

  static const List<LanguageOption> options = [
    LanguageOption(
      locale: defaultLocale,
      flagEmoji: '🇧🇷',
      nativeName: 'Português',
    ),
    LanguageOption(
      locale: Locale('en'),
      flagEmoji: '🇺🇸',
      nativeName: 'English',
    ),
    LanguageOption(
      locale: Locale('es'),
      flagEmoji: '🇪🇸',
      nativeName: 'Español',
    ),
    LanguageOption(
      locale: Locale('it'),
      flagEmoji: '🇮🇹',
      nativeName: 'Italiano',
    ),
    LanguageOption(
      locale: Locale('fr'),
      flagEmoji: '🇫🇷',
      nativeName: 'Français',
    ),
  ];

  static final List<Locale> locales = List.unmodifiable(
    options.map((option) => option.locale),
  );
}
