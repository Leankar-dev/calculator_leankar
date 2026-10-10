import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/utils/constants/app_languages.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLanguages', () {
    test('o idioma padrão é o primeiro da lista', () {
      expect(AppLanguages.options.first.locale, AppLanguages.defaultLocale);
      expect(AppLanguages.defaultLocale, const Locale('pt', 'BR'));
    });

    test('oferece os cinco idiomas selecionáveis', () {
      expect(
        AppLanguages.locales,
        const [
          Locale('pt', 'BR'),
          Locale('en'),
          Locale('es'),
          Locale('it'),
          Locale('fr'),
        ],
      );
    });

    test('o SettingsController usa a mesma lista de idiomas', () {
      expect(SettingsController.supportedLocales, AppLanguages.locales);
      expect(SettingsController.defaultLocale, AppLanguages.defaultLocale);
    });

    test('cada idioma tem bandeira e nome nativo únicos e não vazios', () {
      final flags = AppLanguages.options.map((option) => option.flagEmoji);
      final names = AppLanguages.options.map((option) => option.nativeName);

      expect(flags.every((flag) => flag.isNotEmpty), isTrue);
      expect(names.every((name) => name.isNotEmpty), isTrue);
      expect(flags.toSet().length, AppLanguages.options.length);
      expect(names.toSet().length, AppLanguages.options.length);
    });
  });
}
