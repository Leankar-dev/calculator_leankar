// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get calculatorPageTitle => 'CALCULATOR';

  @override
  String get imcPageTitle => 'Calcolatore BMI';

  @override
  String get settingsPageTitle => 'Impostazioni';

  @override
  String get drawerItemHistory => 'Cronologia';

  @override
  String get drawerItemImc => 'Calcolatore BMI';

  @override
  String get drawerItemSettings => 'Impostazioni';

  @override
  String get historyTitle => 'Cronologia';

  @override
  String get historyClearButton => 'Cancella';

  @override
  String get historyEmptyMessage => 'Nessuna cronologia di calcoli';

  @override
  String get snackbarValueCopied => 'Valore copiato';

  @override
  String get snackbarEmptyClipboard => 'Appunti vuoti';

  @override
  String get snackbarInvalidPaste => 'Valore non valido da incollare';

  @override
  String get snackbarOutOfRange => 'Valore fuori dall\'intervallo consentito';

  @override
  String get errorDivisionByZero => 'Err: Div/0';

  @override
  String get errorInfinity => 'Err: Infinito';

  @override
  String get errorNan => 'Err: Non valido';

  @override
  String get errorOverflow => 'Err: Overflow';

  @override
  String get errorGeneric => 'Errore';

  @override
  String get settingsAppearanceSection => 'ASPETTO';

  @override
  String get themeOptionSystem => 'Sistema';

  @override
  String get themeOptionLight => 'Chiaro';

  @override
  String get themeOptionDark => 'Scuro';

  @override
  String get settingsLanguageSection => 'LINGUA';

  @override
  String get settingsAboutSection => 'INFO APP';

  @override
  String get settingsVersionLabel => 'Versione';

  @override
  String get settingsDeveloperLabel => 'Sviluppatore';

  @override
  String get settingsEmailLabel => 'E-mail';

  @override
  String get settingsWebsiteLabel => 'Sito web';

  @override
  String get imcWeightLabel => 'Peso';

  @override
  String get imcHeightLabel => 'Altezza';

  @override
  String get imcCalculateButton => 'Calcola BMI';

  @override
  String get imcInvalidWeightError =>
      'Peso non valido. Inserire tra 1 e 500 kg.';

  @override
  String get imcInvalidHeightError =>
      'Altezza non valida. Inserire tra 50 e 250 cm.';

  @override
  String get imcCalculationError => 'Errore nel calcolo. Verificare i valori.';

  @override
  String get imcIdealWeightTitle => 'PESO IDEALE';

  @override
  String get imcIdealWeightRangeLabel => 'Intervallo sano';

  @override
  String get imcIdealWeightStatusLabel => 'Stato';

  @override
  String get imcIdealWeightDiffLabel => 'Differenza';

  @override
  String get imcIdealWeightOnRange => 'Nel range ideale';

  @override
  String get imcIdealWeightAbove => 'Sopra il peso ideale';

  @override
  String get imcIdealWeightBelow => 'Sotto il peso ideale';

  @override
  String get imcClassificationUnderweight => 'Sottopeso';

  @override
  String get imcClassificationNormal => 'Peso normale';

  @override
  String get imcClassificationOverweight => 'Sovrappeso';

  @override
  String get imcClassificationObesityI => 'Obesità Grado I';

  @override
  String get imcClassificationObesityII => 'Obesità Grado II';

  @override
  String get imcClassificationObesityIII => 'Obesità Grado III';

  @override
  String get semanticDivide => 'Dividere';

  @override
  String get semanticMultiply => 'Moltiplicare';

  @override
  String get semanticSubtract => 'Sottrarre';

  @override
  String get semanticAdd => 'Aggiungere';

  @override
  String get semanticBackspace => 'Cancella ultima cifra';

  @override
  String get semanticPercent => 'Percentuale';

  @override
  String get semanticEquals => 'Calcola risultato';

  @override
  String get semanticClear => 'Cancella tutto';

  @override
  String get semanticDecimalSeparator => 'Separatore decimale';
}
