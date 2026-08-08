import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const currentBuildNumber = '1';

  void setMockPackageInfo({String buildNumber = currentBuildNumber}) {
    PackageInfo.setMockInitialValues(
      appName: 'Test',
      packageName: 'com.test',
      version: '1.0.0',
      buildNumber: buildNumber,
      buildSignature: '',
    );
  }

  setUp(() async {
    setMockPackageInfo();
    SharedPreferences.setMockInitialValues({});
    await SettingsController.instance.loadSettings();
  });

  group('SettingsController', () {
    group('themeMode inicial', () {
      test(
        'deve ser ThemeMode.light quando não há build number salvo (instalação nova)',
        () {
          expect(SettingsController.instance.themeMode, ThemeMode.light);
        },
      );
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

    group('instalação/atualização força tema claro', () {
      test(
        'deve forçar ThemeMode.light quando não há build number salvo, mesmo com tema escuro salvo (instalação nova ou atualização vinda de versão anterior a este recurso)',
        () async {
          SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});

          await SettingsController.instance.loadSettings();

          expect(SettingsController.instance.themeMode, ThemeMode.light);
        },
      );

      test(
        'deve forçar ThemeMode.light quando o build number mudou (atualização do app), mesmo com tema escuro salvo',
        () async {
          SharedPreferences.setMockInitialValues({
            'theme_mode': 'dark',
            'last_app_build_number': '0',
          });

          await SettingsController.instance.loadSettings();

          expect(SettingsController.instance.themeMode, ThemeMode.light);
        },
      );

      test(
        'deve persistir o novo build number após forçar o tema claro',
        () async {
          SharedPreferences.setMockInitialValues({});

          await SettingsController.instance.loadSettings();

          final prefs = await SharedPreferences.getInstance();
          expect(
            prefs.getString('last_app_build_number'),
            currentBuildNumber,
          );
          expect(prefs.getString('theme_mode'), 'light');
        },
      );

      test(
        'não deve alterar o tema salvo quando o build number é o mesmo (reabertura normal)',
        () async {
          SharedPreferences.setMockInitialValues({
            'theme_mode': 'dark',
            'last_app_build_number': currentBuildNumber,
          });

          await SettingsController.instance.loadSettings();

          expect(SettingsController.instance.themeMode, ThemeMode.dark);
        },
      );
    });

    group('_parseThemeMode via loadSettings (reabertura normal)', () {
      test("deve interpretar 'light' como ThemeMode.light", () async {
        SharedPreferences.setMockInitialValues({
          'theme_mode': 'light',
          'last_app_build_number': currentBuildNumber,
        });
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.light);
      });

      test("deve interpretar 'dark' como ThemeMode.dark", () async {
        SharedPreferences.setMockInitialValues({
          'theme_mode': 'dark',
          'last_app_build_number': currentBuildNumber,
        });
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.dark);
      });

      test("deve interpretar 'system' como ThemeMode.system", () async {
        SharedPreferences.setMockInitialValues({
          'theme_mode': 'system',
          'last_app_build_number': currentBuildNumber,
        });
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.system);
      });

      test(
        'deve retornar ThemeMode.system quando chave ausente (null) mas build number confere',
        () async {
          SharedPreferences.setMockInitialValues({
            'last_app_build_number': currentBuildNumber,
          });
          await SettingsController.instance.loadSettings();

          expect(SettingsController.instance.themeMode, ThemeMode.system);
        },
      );

      test(
        'deve retornar ThemeMode.system para valor desconhecido quando build number confere',
        () async {
          SharedPreferences.setMockInitialValues({
            'theme_mode': 'invalid',
            'last_app_build_number': currentBuildNumber,
          });
          await SettingsController.instance.loadSettings();

          expect(SettingsController.instance.themeMode, ThemeMode.system);
        },
      );
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
