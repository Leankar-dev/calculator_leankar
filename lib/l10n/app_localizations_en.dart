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

  @override
  String get drawerItemScientific => 'Scientific Calculator';

  @override
  String get scientificPageTitle => 'Scientific Calculator';

  @override
  String get scientificAngleModeDeg => 'DEG';

  @override
  String get scientificAngleModeRad => 'RAD';

  @override
  String get scientificShift => 'SHIFT';

  @override
  String get scientificMemoryAdd => 'Memory Add';

  @override
  String get scientificMemorySubtract => 'Memory Subtract';

  @override
  String get scientificMemoryRecall => 'Memory Recall';

  @override
  String get scientificMemoryClear => 'Memory Clear';

  @override
  String get scientificErrorSyntax => 'Syntax error';

  @override
  String get scientificErrorParens => 'Unbalanced parentheses';

  @override
  String get scientificErrorDomain => 'Math domain error';

  @override
  String get scientificErrorFactorialDomain =>
      'Factorial requires a non-negative integer';

  @override
  String get scientificErrorFactorialOverflow =>
      'Value too large for factorial';

  @override
  String get scientificErrorDivisionByZero => 'Division by zero';

  @override
  String get scientificErrorOverflow => 'Result too large';

  @override
  String get semanticSin => 'Sine';

  @override
  String get semanticCos => 'Cosine';

  @override
  String get semanticTan => 'Tangent';

  @override
  String get semanticArcsin => 'Inverse sine';

  @override
  String get semanticArccos => 'Inverse cosine';

  @override
  String get semanticArctan => 'Inverse tangent';

  @override
  String get semanticLog => 'Base 10 logarithm';

  @override
  String get semanticLn => 'Natural logarithm';

  @override
  String get semanticExp10 => '10 to the power of x';

  @override
  String get semanticExpE => 'E to the power of x';

  @override
  String get semanticSquare => 'Square';

  @override
  String get semanticCube => 'Cube';

  @override
  String get semanticPower => 'X to the power of y';

  @override
  String get semanticCubeRoot => 'Cube root';

  @override
  String get semanticSqrt => 'Square root';

  @override
  String get semanticReciprocal => 'One divided by x';

  @override
  String get semanticAbsoluteValue => 'Absolute value';

  @override
  String get semanticFactorial => 'Factorial';

  @override
  String get semanticPermutation => 'Permutation';

  @override
  String get semanticPi => 'Pi';

  @override
  String get semanticEuler => 'Euler\'s number';

  @override
  String get semanticOpenParen => 'Open parenthesis';

  @override
  String get semanticCloseParen => 'Close parenthesis';

  @override
  String get semanticMemoryAdd => 'Memory add';

  @override
  String get semanticMemorySubtract => 'Memory subtract';

  @override
  String get semanticMemoryRecall => 'Memory recall';

  @override
  String get semanticMemoryClear => 'Memory clear';

  @override
  String get semanticAngleModeToggle => 'Toggle angle mode';
}
