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
      test('deve ser ThemeMode.light em instalação nova', () {
        expect(SettingsController.instance.themeMode, ThemeMode.light);
      });
    });

    group('locale inicial', () {
      test('deve ser pt_BR por padrão', () {
        expect(SettingsController.instance.locale, const Locale('pt', 'BR'));
      });
    });

    group('setThemeMode', () {
      test(
        'deve atualizar themeMode para dark e notificar listeners',
        () async {
          int notifyCount = 0;
          void listener() => notifyCount++;
          SettingsController.instance.addListener(listener);

          await SettingsController.instance.setThemeMode(ThemeMode.dark);

          SettingsController.instance.removeListener(listener);
          expect(SettingsController.instance.themeMode, ThemeMode.dark);
          expect(notifyCount, 1);
        },
      );

      test('deve atualizar themeMode para system', () async {
        await SettingsController.instance.setThemeMode(ThemeMode.system);

        expect(SettingsController.instance.themeMode, ThemeMode.system);
      });

      test(
        'não deve chamar notifyListeners quando valor é igual ao atual',
        () async {
          int notifyCount = 0;
          void listener() => notifyCount++;
          SettingsController.instance.addListener(listener);

          await SettingsController.instance.setThemeMode(ThemeMode.light);

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

    group('tema na instalação nova', () {
      test('deve persistir o tema claro como padrão', () async {
        SharedPreferences.setMockInitialValues({});

        await SettingsController.instance.loadSettings();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('theme_mode'), 'light');
      });
    });

    group('tema escolhido pelo usuário é preservado entre execuções', () {
      test('deve manter o tema escuro salvo', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});

        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.dark);
      });

      test(
        'deve manter o tema escuro mesmo após a atualização do app',
        () async {
          SharedPreferences.setMockInitialValues({
            'theme_mode': 'dark',
            'last_app_build_number': '0',
          });

          await SettingsController.instance.loadSettings();

          expect(SettingsController.instance.themeMode, ThemeMode.dark);
        },
      );

      test("deve interpretar 'light' como ThemeMode.light", () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'light'});

        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.light);
      });

      test("deve interpretar 'system' como ThemeMode.system", () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'system'});

        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.system);
      });

      test(
        'deve retornar ThemeMode.system para valor desconhecido',
        () async {
          SharedPreferences.setMockInitialValues({'theme_mode': 'invalid'});

          await SettingsController.instance.loadSettings();

          expect(SettingsController.instance.themeMode, ThemeMode.system);
        },
      );
    });

    group('locale salvo via loadSettings', () {
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

      test("deve interpretar 'pt_BR' como Locale('pt', 'BR')", () async {
        SharedPreferences.setMockInitialValues({'locale': 'pt_BR'});
        await SettingsController.instance.loadSettings(
          deviceLocale: const Locale('en'),
        );

        expect(SettingsController.instance.locale, const Locale('pt', 'BR'));
      });

      test('deve retornar pt_BR para valor desconhecido', () async {
        SharedPreferences.setMockInitialValues({'locale': 'invalid'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.locale, const Locale('pt', 'BR'));
      });

      test(
        'deve priorizar o locale salvo sobre o idioma do aparelho',
        () async {
          SharedPreferences.setMockInitialValues({'locale': 'fr'});
          await SettingsController.instance.loadSettings(
            deviceLocale: const Locale('es'),
          );

          expect(SettingsController.instance.locale, const Locale('fr'));
        },
      );
    });

    group('locale a partir do idioma do aparelho (primeira execução)', () {
      test(
        'deve usar pt_BR quando nenhum idioma do aparelho é informado',
        () async {
          SharedPreferences.setMockInitialValues({});
          await SettingsController.instance.loadSettings();

          expect(SettingsController.instance.locale, const Locale('pt', 'BR'));
        },
      );

      test('deve usar o idioma do aparelho quando é suportado', () async {
        SharedPreferences.setMockInitialValues({});
        await SettingsController.instance.loadSettings(
          deviceLocale: const Locale('it', 'IT'),
        );

        expect(SettingsController.instance.locale, const Locale('it'));
      });

      test('deve mapear qualquer variante de português para pt_BR', () async {
        SharedPreferences.setMockInitialValues({});
        await SettingsController.instance.loadSettings(
          deviceLocale: const Locale('pt', 'PT'),
        );

        expect(SettingsController.instance.locale, const Locale('pt', 'BR'));
      });

      test(
        'deve usar pt_BR quando o idioma do aparelho não é suportado',
        () async {
          SharedPreferences.setMockInitialValues({});
          await SettingsController.instance.loadSettings(
            deviceLocale: const Locale('de', 'DE'),
          );

          expect(SettingsController.instance.locale, const Locale('pt', 'BR'));
        },
      );
    });
  });
}
