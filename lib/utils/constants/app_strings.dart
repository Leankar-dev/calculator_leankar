class AppStrings {
  AppStrings._();

  static const String initialDisplayValue = '0';
  static const String divisionByZeroError = 'Erro: Div/0';
  static const String infinityError = 'Erro: Infinito';
  static const String nanError = 'Erro: Inválido';
  static const String overflowError = 'Erro: Overflow';
  static const String genericError = 'Erro';
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

  static const String appTitle = 'Calculator App';
  static const String appName = 'Leankar Calc';
  static const String logoAssetPath = 'assets/images/logo4.png';

  static const String calculatorPageTitle = 'Calculator';
  static const String imcPageTitle = 'Calculadora IMC';
  static const String settingsPageTitle = 'Configurações';

  static const String drawerItemHistory = 'Histórico';

  static const String snackbarValueCopied = 'Valor copiado';
  static const String snackbarEmptyClipboard = 'Área de transferência vazia';
  static const String snackbarInvalidPaste = 'Valor inválido para colar';
  static const String snackbarOutOfRange = 'Valor fora dos limites permitidos';

  static const String historyTitle = 'History';
  static const String historyClearButton = 'Clear';
  static const String historyEmptyMessage = 'Sem Histórico de cálculos';
  static const String historyDateFormat = 'dd/MM HH:mm';

  static const String semanticDivide = 'Dividir';
  static const String semanticMultiply = 'Multiplicar';
  static const String semanticSubtract = 'Subtrair';
  static const String semanticAdd = 'Adicionar';
  static const String semanticBackspace = 'Apagar último dígito';
  static const String semanticPercent = 'Porcentagem';
  static const String semanticEquals = 'Calcular resultado';
  static const String semanticClear = 'Limpar tudo';
  static const String semanticDecimalSeparator = 'Vírgula decimal';

  static const String settingsAppearanceSection = 'APARÊNCIA';
  static const String themeOptionSystem = 'Sistema';
  static const String themeOptionLight = 'Claro';
  static const String themeOptionDark = 'Escuro';

  static const String settingsAboutSection = 'SOBRE O APP';
  static const String settingsVersionLabel = 'Versão';
  static const String settingsDeveloperLabel = 'Programador';
  static const String settingsDeveloperName = 'Leankar.dev';
  static const String settingsEmailLabel = 'E-mail';
  static const String settingsEmail = 'leankar.dev@gmail.com';
  static const String settingsWebsiteLabel = 'Website';
  static const String settingsWebsite = 'leankar.dev';
  static const String settingsWebsiteUrl = 'https://leankar.dev';

  static const String imcUnderConstructionTitle = 'Em desenvolvimento';
  static const String imcUnderConstructionDescription =
      'A Calculadora IMC estará disponível em breve.';

  static const String imcWeightLabel = 'Peso';
  static const String imcHeightLabel = 'Altura';
  static const String imcWeightUnit = 'kg';
  static const String imcHeightUnit = 'cm';
  static const String imcWeightHint = '70,0';
  static const String imcHeightHint = '170';
  static const String imcCalculateButtonLabel = 'Calcular IMC';
  static const String imcInvalidWeightError =
      'Peso inválido. Informe entre 1 e 500 kg.';
  static const String imcInvalidHeightError =
      'Altura inválida. Informe entre 50 e 250 cm.';
  static const String imcCalculationError =
      'Erro ao calcular. Verifique os valores.';

  static const String prefThemeModeKey = 'theme_mode';
  static const String prefHistoryKey = 'calculation_history';

  static const String themeModeSerialLight = 'light';
  static const String themeModeSerialDark = 'dark';
  static const String themeModeSerialSystem = 'system';

  static const String locale = 'pt_BR';
}
