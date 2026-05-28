class AppStrings {
  AppStrings._();

  static const String decimalSeparator = ',';
  static const String thousandsSeparator = '.';
  static const int maxDecimalPlaces = 8;

  static const double maxDisplayValue = 1e15;
  static const double scientificThresholdSmall = 1e-6;
  static const double scientificThresholdLarge = 1e12;

  static const String backspaceSymbol = '\u{232B}';
  static const String percentSymbol = '\u{0025}';
  static const String additionSymbol = '\u{002B}';
  static const String subtractionSymbol = '\u{002D}';
  static const String multiplicationSymbol = '\u{00D7}';
  static const String divisionSymbol = '\u{00F7}';
  static const String clearButtonText = 'C';
  static const String equalsButtonText = '=';
  static const String initialDisplayValue = '0';

  static const String appTitle = 'Calculator App';
  static const String appName = 'Leankar Calc';
  static const String logoAssetPath = 'assets/images/logo5.png';
  static const String settingsDeveloperName = 'Leankar.dev';
  static const String settingsEmail = 'leankar.dev@gmail.com';
  static const String settingsWebsite = 'leankar.dev';
  static const String settingsWebsiteUrl = 'https://leankar.dev';

  static const String prefThemeModeKey = 'theme_mode';
  static const String prefLocaleKey = 'locale';
  static const String prefHistoryKey = 'calculation_history';

  static const String themeModeSerialLight = 'light';
  static const String themeModeSerialDark = 'dark';
  static const String themeModeSerialSystem = 'system';

  static const String historyDateFormat = 'dd/MM HH:mm';

  static const String historyResultPrefix = '= ';

  static const String locale = 'pt_BR';

  static const String versionPlaceholder = '—';
  static const String versionPrefix = 'v';
}
