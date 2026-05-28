// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get calculatorPageTitle => 'CALCULATOR';

  @override
  String get imcPageTitle => 'Calculadora IMC';

  @override
  String get settingsPageTitle => 'Configuración';

  @override
  String get drawerItemHistory => 'Historial';

  @override
  String get drawerItemImc => 'Calculadora IMC';

  @override
  String get drawerItemSettings => 'Configuración';

  @override
  String get historyTitle => 'Historial';

  @override
  String get historyClearButton => 'Borrar';

  @override
  String get historyEmptyMessage => 'Sin historial de cálculos';

  @override
  String get snackbarValueCopied => 'Valor copiado';

  @override
  String get snackbarEmptyClipboard => 'Portapapeles vacío';

  @override
  String get snackbarInvalidPaste => 'Valor inválido para pegar';

  @override
  String get snackbarOutOfRange => 'Valor fuera del rango permitido';

  @override
  String get errorDivisionByZero => 'Error: Div/0';

  @override
  String get errorInfinity => 'Error: Infinito';

  @override
  String get errorNan => 'Error: Inválido';

  @override
  String get errorOverflow => 'Error: Overflow';

  @override
  String get errorGeneric => 'Error';

  @override
  String get settingsAppearanceSection => 'APARIENCIA';

  @override
  String get themeOptionSystem => 'Sistema';

  @override
  String get themeOptionLight => 'Claro';

  @override
  String get themeOptionDark => 'Oscuro';

  @override
  String get settingsLanguageSection => 'IDIOMA';

  @override
  String get settingsAboutSection => 'SOBRE LA APP';

  @override
  String get settingsVersionLabel => 'Versión';

  @override
  String get settingsDeveloperLabel => 'Desarrollador';

  @override
  String get settingsEmailLabel => 'E-mail';

  @override
  String get settingsWebsiteLabel => 'Sitio web';

  @override
  String get imcWeightLabel => 'Peso';

  @override
  String get imcHeightLabel => 'Altura';

  @override
  String get imcCalculateButton => 'Calcular IMC';

  @override
  String get imcInvalidWeightError =>
      'Peso inválido. Ingrese entre 1 y 500 kg.';

  @override
  String get imcInvalidHeightError =>
      'Altura inválida. Ingrese entre 50 y 250 cm.';

  @override
  String get imcCalculationError => 'Error al calcular. Verifique los valores.';

  @override
  String get imcIdealWeightTitle => 'PESO IDEAL';

  @override
  String get imcIdealWeightRangeLabel => 'Rango saludable';

  @override
  String get imcIdealWeightStatusLabel => 'Estado';

  @override
  String get imcIdealWeightDiffLabel => 'Diferencia';

  @override
  String get imcIdealWeightOnRange => 'Dentro del ideal';

  @override
  String get imcIdealWeightAbove => 'Por encima del ideal';

  @override
  String get imcIdealWeightBelow => 'Por debajo del ideal';

  @override
  String get imcClassificationUnderweight => 'Bajo peso';

  @override
  String get imcClassificationNormal => 'Peso normal';

  @override
  String get imcClassificationOverweight => 'Sobrepeso';

  @override
  String get imcClassificationObesityI => 'Obesidad Grado I';

  @override
  String get imcClassificationObesityII => 'Obesidad Grado II';

  @override
  String get imcClassificationObesityIII => 'Obesidad Grado III';

  @override
  String get semanticDivide => 'Dividir';

  @override
  String get semanticMultiply => 'Multiplicar';

  @override
  String get semanticSubtract => 'Restar';

  @override
  String get semanticAdd => 'Sumar';

  @override
  String get semanticBackspace => 'Borrar último dígito';

  @override
  String get semanticPercent => 'Porcentaje';

  @override
  String get semanticEquals => 'Calcular resultado';

  @override
  String get semanticClear => 'Borrar todo';

  @override
  String get semanticDecimalSeparator => 'Separador decimal';
}
