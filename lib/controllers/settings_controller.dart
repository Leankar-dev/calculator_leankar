import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  static final SettingsController instance = SettingsController._();
  SettingsController._();

  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en'),
    Locale('es'),
    Locale('it'),
    Locale('fr'),
  ];

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Locale _locale = const Locale('pt', 'BR');
  Locale get locale => _locale;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = _parseThemeMode(prefs.getString(AppStrings.prefThemeModeKey));
    _locale = _parseLocale(prefs.getString(AppStrings.prefLocaleKey));
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppStrings.prefThemeModeKey,
      _serializeThemeMode(mode),
    );
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStrings.prefLocaleKey, _serializeLocale(locale));
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case AppStrings.themeModeSerialLight:
        return ThemeMode.light;
      case AppStrings.themeModeSerialDark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _serializeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppStrings.themeModeSerialLight;
      case ThemeMode.dark:
        return AppStrings.themeModeSerialDark;
      case ThemeMode.system:
        return AppStrings.themeModeSerialSystem;
    }
  }

  Locale _parseLocale(String? value) {
    switch (value) {
      case 'en':
        return const Locale('en');
      case 'es':
        return const Locale('es');
      case 'it':
        return const Locale('it');
      case 'fr':
        return const Locale('fr');
      default:
        return const Locale('pt', 'BR');
    }
  }

  String _serializeLocale(Locale locale) {
    if (locale.countryCode != null) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }
}
