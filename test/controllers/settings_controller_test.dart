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

    group('setThemeMode', () {
      test('deve atualizar themeMode para light e notificar listeners', () async {
        int notifyCount = 0;
        void listener() => notifyCount++;
        SettingsController.instance.addListener(listener);

        await SettingsController.instance.setThemeMode(ThemeMode.light);

        SettingsController.instance.removeListener(listener);
        expect(SettingsController.instance.themeMode, ThemeMode.light);
        expect(notifyCount, 1);
      });

      test('deve atualizar themeMode para dark', () async {
        await SettingsController.instance.setThemeMode(ThemeMode.dark);

        expect(SettingsController.instance.themeMode, ThemeMode.dark);
      });

      test('não deve chamar notifyListeners quando valor é igual ao atual', () async {
        int notifyCount = 0;
        void listener() => notifyCount++;
        SettingsController.instance.addListener(listener);

        await SettingsController.instance.setThemeMode(ThemeMode.system);

        SettingsController.instance.removeListener(listener);
        expect(notifyCount, 0);
      });
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

      test('deve retornar ThemeMode.system quando chave ausente (null)', () async {
        SharedPreferences.setMockInitialValues({});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.system);
      });

      test('deve retornar ThemeMode.system para valor desconhecido', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'invalid'});
        await SettingsController.instance.loadSettings();

        expect(SettingsController.instance.themeMode, ThemeMode.system);
      });
    });
  });
}
