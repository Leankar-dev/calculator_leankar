import 'package:calculator_05122025/utils/constants/app_languages.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  static final SettingsController instance = SettingsController._();
  SettingsController._();

  static const Locale defaultLocale = AppLanguages.defaultLocale;

  static final List<Locale> supportedLocales = AppLanguages.locales;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Locale _locale = defaultLocale;
  Locale get locale => _locale;

  Future<void> loadSettings({Locale deviceLocale = defaultLocale}) async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode = await _loadThemeMode(prefs);
    _locale =
        _parseLocale(prefs.getString(AppStrings.prefLocaleKey)) ??
        _matchDeviceLocale(deviceLocale);
    notifyListeners();
  }

  Future<ThemeMode> _loadThemeMode(SharedPreferences prefs) async {
    final storedValue = prefs.getString(AppStrings.prefThemeModeKey);
    if (storedValue != null) {
      return _parseThemeMode(storedValue);
    }

    await prefs.setString(
      AppStrings.prefThemeModeKey,
      _serializeThemeMode(ThemeMode.light),
    );
    return ThemeMode.light;
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

  ThemeMode _parseThemeMode(String value) {
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

  Locale? _parseLocale(String? value) {
    if (value == null) return null;
    return supportedLocales.firstWhere(
      (locale) => _serializeLocale(locale) == value,
      orElse: () => defaultLocale,
    );
  }

  Locale _matchDeviceLocale(Locale deviceLocale) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == deviceLocale.languageCode,
      orElse: () => defaultLocale,
    );
  }

  String _serializeLocale(Locale locale) {
    if (locale.countryCode != null) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }
}
