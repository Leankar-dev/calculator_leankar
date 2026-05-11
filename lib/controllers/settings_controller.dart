import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  static final SettingsController instance = SettingsController._();
  SettingsController._();

  static const String _themeModeKey = AppStrings.prefThemeModeKey;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = _parseThemeMode(prefs.getString(_themeModeKey));
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _serializeThemeMode(mode));
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
}
