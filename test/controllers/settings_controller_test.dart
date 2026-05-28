import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SettingsController.instance.loadSettings();
  });

  group('SettingsController', () {
    group('themeMode inicial', () {
      test('deve ser ThemeMode.system por padrão', () {
        expect(SettingsController.instance.themeMode, ThemeMode.system);
      });
    });

    group('locale inicial', () {
      test('deve ser pt_BR por padrão', () {
        expect(SettingsController.instance.locale, const Locale('pt', 'BR'));
      });
    });

    group('setThemeMode', () {
      test(
        'deve atualizar themeMode para light e notificar listeners',
        () async {
          int notifyCount = 0;
          void listener() => notifyCount++;
          SettingsController.instance.addListener(listener);

          await SettingsController.instance.setThemeMode(ThemeMode.light);

          SettingsController.instance.removeListener(listener);
          expect(SettingsController.instance.themeMode, ThemeMode.light);
          expect(notifyCount, 1);
        },
      );

      test('deve atualizar themeMode para dark', () async {
        await SettingsController.instance.setThemeMode(ThemeMode.dark);

        expect(SettingsController.instance.themeMode, ThemeMode.dark);
      });

      test(
        'não deve chamar notifyListeners quando valor é igual ao atual',
        () async {
          int notifyCount = 0;
          void listener() => notifyCount++;
          SettingsController.instance.addListener(listener);

          await SettingsController.instance.setThemeMode(ThemeMode.system);

          SettingsController.instance.removeListener(listener);
          expect(notifyCount, 0);
        },
      );
    });

    group('setLocale', () {
      test('deve atualizar locale para en e notificar listeners', () async {
        int notifyCount = 0;
        void listener() => notifyCount++;
        SettingsController.instance.addListener(listener);

        await SettingsController.instance.setLocale(const Locale('en'));

        SettingsController.instance.removeListener(listener);
        expect(SettingsController.instance.locale, const Locale('en'));
        expect(notifyCount, 1);
      });

      test('deve atualizar locale para fr', () async {
        await SettingsController.instance.setLocale(const Locale('fr'));

        expect(SettingsController.instance.locale, const Locale('fr'));
      });

      test(
        'não deve chamar notifyListeners quando locale é igual ao atual',
        () async {
          int notifyCount = 0;
          void listener() => notifyCount++;
          SettingsController.instance.addListener(listener);

          await SettingsController.instance.setLocale(const Locale('pt', 'BR'));

          SettingsController.instance.removeListener(listener);
          expect(notifyCount, 0);
        },
      );
    });

    group('_parseThemeMode via loadSettings', () {
      test("deve interpretar 'light' como ThemeMode.light", () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.light);
      });

      test("deve interpretar 'dark' como ThemeMode.dark", () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.dark);
      });

      test("deve interpretar 'system' como ThemeMode.system", () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'system'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.system);
      });

      test(
        'deve retornar ThemeMode.system quando chave ausente (null)',
        () async {
          SharedPreferences.setMockInitialValues({});
          await SettingsController.instance.loadSettings();

          expect(SettingsController.instance.themeMode, ThemeMode.system);
        },
      );

      test('deve retornar ThemeMode.system para valor desconhecido', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'invalid'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.system);
      });
    });

    group('_parseLocale via loadSettings', () {
      test("deve interpretar 'en' como Locale('en')", () async {
        SharedPreferences.setMockInitialValues({'locale': 'en'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.locale, const Locale('en'));
      });

      test("deve interpretar 'es' como Locale('es')", () async {
        SharedPreferences.setMockInitialValues({'locale': 'es'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.locale, const Locale('es'));
      });

      test("deve interpretar 'it' como Locale('it')", () async {
        SharedPreferences.setMockInitialValues({'locale': 'it'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.locale, const Locale('it'));
      });

      test("deve interpretar 'fr' como Locale('fr')", () async {
        SharedPreferences.setMockInitialValues({'locale': 'fr'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.locale, const Locale('fr'));
      });

      test('deve retornar pt_BR quando chave ausente (null)', () async {
        SharedPreferences.setMockInitialValues({});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.locale, const Locale('pt', 'BR'));
      });

      test('deve retornar pt_BR para valor desconhecido', () async {
        SharedPreferences.setMockInitialValues({'locale': 'invalid'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.locale, const Locale('pt', 'BR'));
      });
    });
  });
}
