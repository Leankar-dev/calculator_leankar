// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get calculatorPageTitle => 'CALCULATOR';

  @override
  String get imcPageTitle => 'BMI Calculator';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get drawerItemHistory => 'History';

  @override
  String get drawerItemImc => 'BMI Calculator';

  @override
  String get drawerItemSettings => 'Settings';

  @override
  String get historyTitle => 'History';

  @override
  String get historyClearButton => 'Clear';

  @override
  String get historyEmptyMessage => 'No calculation history';

  @override
  String get snackbarValueCopied => 'Value copied';

  @override
  String get snackbarEmptyClipboard => 'Empty clipboard';

  @override
  String get snackbarInvalidPaste => 'Invalid value to paste';

  @override
  String get snackbarOutOfRange => 'Value out of allowed range';

  @override
  String get errorDivisionByZero => 'Err: Div/0';

  @override
  String get errorInfinity => 'Err: Infinity';

  @override
  String get errorNan => 'Err: Invalid';

  @override
  String get errorOverflow => 'Err: Overflow';

  @override
  String get errorGeneric => 'Error';

  @override
  String get settingsAppearanceSection => 'APPEARANCE';

  @override
  String get themeOptionSystem => 'System';

  @override
  String get themeOptionLight => 'Light';

  @override
  String get themeOptionDark => 'Dark';

  @override
  String get settingsLanguageSection => 'LANGUAGE';

  @override
  String get settingsAboutSection => 'ABOUT';

  @override
  String get settingsVersionLabel => 'Version';

  @override
  String get settingsDeveloperLabel => 'Developer';

  @override
  String get settingsEmailLabel => 'E-mail';

  @override
  String get settingsWebsiteLabel => 'Website';

  @override
  String get imcWeightLabel => 'Weight';

  @override
  String get imcHeightLabel => 'Height';

  @override
  String get imcCalculateButton => 'Calculate BMI';

  @override
  String get imcInvalidWeightError =>
      'Invalid weight. Enter between 1 and 500 kg.';

  @override
  String get imcInvalidHeightError =>
      'Invalid height. Enter between 50 and 250 cm.';

  @override
  String get imcCalculationError => 'Calculation error. Check the values.';

  @override
  String get imcIdealWeightTitle => 'IDEAL WEIGHT';

  @override
  String get imcIdealWeightRangeLabel => 'Healthy range';

  @override
  String get imcIdealWeightStatusLabel => 'Status';

  @override
  String get imcIdealWeightDiffLabel => 'Difference';

  @override
  String get imcIdealWeightOnRange => 'Within ideal range';

  @override
  String get imcIdealWeightAbove => 'Above ideal';

  @override
  String get imcIdealWeightBelow => 'Below ideal';

  @override
  String get imcClassificationUnderweight => 'Underweight';

  @override
  String get imcClassificationNormal => 'Normal weight';

  @override
  String get imcClassificationOverweight => 'Overweight';

  @override
  String get imcClassificationObesityI => 'Obesity Grade I';

  @override
  String get imcClassificationObesityII => 'Obesity Grade II';

  @override
  String get imcClassificationObesityIII => 'Obesity Grade III';

  @override
  String get semanticDivide => 'Divide';

  @override
  String get semanticMultiply => 'Multiply';

  @override
  String get semanticSubtract => 'Subtract';

  @override
  String get semanticAdd => 'Add';

  @override
  String get semanticBackspace => 'Delete last digit';

  @override
  String get semanticPercent => 'Percentage';

  @override
  String get semanticEquals => 'Calculate result';

  @override
  String get semanticClear => 'Clear all';

  @override
  String get semanticDecimalSeparator => 'Decimal separator';

  @override
  String get adConsentDialogTitle => 'Privacy & Ads';

  @override
  String get adConsentDialogBody =>
      'This app displays ads to stay free. You can choose your privacy preferences.';

  @override
  String get adConsentAccept => 'Accept';

  @override
  String get adConsentDecline => 'Decline';

  @override
  String get adLoadingPlaceholder => 'Loading ad...';

  @override
  String get adUnavailable => 'Ad unavailable';
}
