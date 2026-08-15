import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// Home screen title — always CALCULATOR in all locales
  ///
  /// In en, this message translates to:
  /// **'CALCULATOR'**
  String get calculatorPageTitle;

  /// AppBar title on BMI calculator page
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get imcPageTitle;

  /// AppBar title on settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// End drawer menu item for calculation history
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get drawerItemHistory;

  /// End drawer menu item for BMI calculator
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get drawerItemImc;

  /// End drawer menu item for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerItemSettings;

  /// Title of the history bottom sheet
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// Button to clear calculation history
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get historyClearButton;

  /// Shown when history list is empty
  ///
  /// In en, this message translates to:
  /// **'No calculation history'**
  String get historyEmptyMessage;

  /// Snackbar after copying display value
  ///
  /// In en, this message translates to:
  /// **'Value copied'**
  String get snackbarValueCopied;

  /// Snackbar when clipboard has no content
  ///
  /// In en, this message translates to:
  /// **'Empty clipboard'**
  String get snackbarEmptyClipboard;

  /// Snackbar when pasted value cannot be parsed
  ///
  /// In en, this message translates to:
  /// **'Invalid value to paste'**
  String get snackbarInvalidPaste;

  /// Snackbar when pasted value exceeds display limits
  ///
  /// In en, this message translates to:
  /// **'Value out of allowed range'**
  String get snackbarOutOfRange;

  /// Calculator display error — division by zero
  ///
  /// In en, this message translates to:
  /// **'Err: Div/0'**
  String get errorDivisionByZero;

  /// Calculator display error — infinite result
  ///
  /// In en, this message translates to:
  /// **'Err: Infinity'**
  String get errorInfinity;

  /// Calculator display error — not a number
  ///
  /// In en, this message translates to:
  /// **'Err: Invalid'**
  String get errorNan;

  /// Calculator display error — number too large
  ///
  /// In en, this message translates to:
  /// **'Err: Overflow'**
  String get errorOverflow;

  /// Generic calculator error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorGeneric;

  /// Section header in settings for theme selection
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settingsAppearanceSection;

  /// Theme option following system setting
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeOptionSystem;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeOptionLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeOptionDark;

  /// Section header in settings for language selection
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get settingsLanguageSection;

  /// Section header in settings for app info
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get settingsAboutSection;

  /// Label for app version row in about card
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersionLabel;

  /// Label for developer row in about card
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get settingsDeveloperLabel;

  /// Label for e-mail row in about card
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get settingsEmailLabel;

  /// Label for website row in about card
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get settingsWebsiteLabel;

  /// Input field label for weight in BMI calculator
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get imcWeightLabel;

  /// Input field label for height in BMI calculator
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get imcHeightLabel;

  /// Button label to trigger BMI calculation
  ///
  /// In en, this message translates to:
  /// **'Calculate BMI'**
  String get imcCalculateButton;

  /// Validation error for out-of-range weight
  ///
  /// In en, this message translates to:
  /// **'Invalid weight. Enter between 1 and 500 kg.'**
  String get imcInvalidWeightError;

  /// Validation error for out-of-range height
  ///
  /// In en, this message translates to:
  /// **'Invalid height. Enter between 50 and 250 cm.'**
  String get imcInvalidHeightError;

  /// Generic error during BMI calculation
  ///
  /// In en, this message translates to:
  /// **'Calculation error. Check the values.'**
  String get imcCalculationError;

  /// Section title for ideal weight in BMI result card
  ///
  /// In en, this message translates to:
  /// **'IDEAL WEIGHT'**
  String get imcIdealWeightTitle;

  /// Label for ideal weight range row
  ///
  /// In en, this message translates to:
  /// **'Healthy range'**
  String get imcIdealWeightRangeLabel;

  /// Label for weight status row
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get imcIdealWeightStatusLabel;

  /// Label for weight difference row
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get imcIdealWeightDiffLabel;

  /// Status when weight is within healthy BMI range
  ///
  /// In en, this message translates to:
  /// **'Within ideal range'**
  String get imcIdealWeightOnRange;

  /// Status when weight is above healthy BMI range
  ///
  /// In en, this message translates to:
  /// **'Above ideal'**
  String get imcIdealWeightAbove;

  /// Status when weight is below healthy BMI range
  ///
  /// In en, this message translates to:
  /// **'Below ideal'**
  String get imcIdealWeightBelow;

  /// BMI classification label
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get imcClassificationUnderweight;

  /// BMI classification label
  ///
  /// In en, this message translates to:
  /// **'Normal weight'**
  String get imcClassificationNormal;

  /// BMI classification label
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get imcClassificationOverweight;

  /// BMI classification label
  ///
  /// In en, this message translates to:
  /// **'Obesity Grade I'**
  String get imcClassificationObesityI;

  /// BMI classification label
  ///
  /// In en, this message translates to:
  /// **'Obesity Grade II'**
  String get imcClassificationObesityII;

  /// BMI classification label
  ///
  /// In en, this message translates to:
  /// **'Obesity Grade III'**
  String get imcClassificationObesityIII;

  /// Accessibility label for divide button
  ///
  /// In en, this message translates to:
  /// **'Divide'**
  String get semanticDivide;

  /// Accessibility label for multiply button
  ///
  /// In en, this message translates to:
  /// **'Multiply'**
  String get semanticMultiply;

  /// Accessibility label for subtract button
  ///
  /// In en, this message translates to:
  /// **'Subtract'**
  String get semanticSubtract;

  /// Accessibility label for add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get semanticAdd;

  /// Accessibility label for backspace button
  ///
  /// In en, this message translates to:
  /// **'Delete last digit'**
  String get semanticBackspace;

  /// Accessibility label for percent button
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get semanticPercent;

  /// Accessibility label for equals button
  ///
  /// In en, this message translates to:
  /// **'Calculate result'**
  String get semanticEquals;

  /// Accessibility label for clear button
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get semanticClear;

  /// Accessibility label for decimal separator button
  ///
  /// In en, this message translates to:
  /// **'Decimal separator'**
  String get semanticDecimalSeparator;

  /// Title of the ad consent dialog
  ///
  /// In en, this message translates to:
  /// **'Privacy & Ads'**
  String get adConsentDialogTitle;

  /// Body text of the ad consent dialog
  ///
  /// In en, this message translates to:
  /// **'This app displays ads to stay free. You can choose your privacy preferences.'**
  String get adConsentDialogBody;

  /// Accept button label in ad consent dialog
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get adConsentAccept;

  /// Decline button label in ad consent dialog
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get adConsentDecline;

  /// Placeholder text shown while ad is loading
  ///
  /// In en, this message translates to:
  /// **'Loading ad...'**
  String get adLoadingPlaceholder;

  /// Text shown when ad fails to load
  ///
  /// In en, this message translates to:
  /// **'Ad unavailable'**
  String get adUnavailable;

  /// End drawer menu item for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Scientific Calculator'**
  String get drawerItemScientific;

  /// AppBar title on scientific calculator page
  ///
  /// In en, this message translates to:
  /// **'Scientific Calculator'**
  String get scientificPageTitle;

  /// Angle mode label — degrees
  ///
  /// In en, this message translates to:
  /// **'DEG'**
  String get scientificAngleModeDeg;

  /// Angle mode label — radians
  ///
  /// In en, this message translates to:
  /// **'RAD'**
  String get scientificAngleModeRad;

  /// Shift button label on scientific keypad
  ///
  /// In en, this message translates to:
  /// **'SHIFT'**
  String get scientificShift;

  /// Memory add label (long form)
  ///
  /// In en, this message translates to:
  /// **'Memory Add'**
  String get scientificMemoryAdd;

  /// Memory subtract label (long form)
  ///
  /// In en, this message translates to:
  /// **'Memory Subtract'**
  String get scientificMemorySubtract;

  /// Memory recall label (long form)
  ///
  /// In en, this message translates to:
  /// **'Memory Recall'**
  String get scientificMemoryRecall;

  /// Memory clear label (long form)
  ///
  /// In en, this message translates to:
  /// **'Memory Clear'**
  String get scientificMemoryClear;

  /// Scientific calculator display error — malformed expression
  ///
  /// In en, this message translates to:
  /// **'Syntax error'**
  String get scientificErrorSyntax;

  /// Scientific calculator display error — unbalanced parentheses
  ///
  /// In en, this message translates to:
  /// **'Unbalanced parentheses'**
  String get scientificErrorParens;

  /// Scientific calculator display error — invalid math domain (e.g. log of a negative number)
  ///
  /// In en, this message translates to:
  /// **'Math domain error'**
  String get scientificErrorDomain;

  /// Scientific calculator display error — factorial of negative or non-integer
  ///
  /// In en, this message translates to:
  /// **'Factorial requires a non-negative integer'**
  String get scientificErrorFactorialDomain;

  /// Scientific calculator display error — factorial argument greater than 170
  ///
  /// In en, this message translates to:
  /// **'Value too large for factorial'**
  String get scientificErrorFactorialOverflow;

  /// Scientific calculator display error — division by zero
  ///
  /// In en, this message translates to:
  /// **'Division by zero'**
  String get scientificErrorDivisionByZero;

  /// Scientific calculator display error — result exceeds display limits
  ///
  /// In en, this message translates to:
  /// **'Result too large'**
  String get scientificErrorOverflow;

  /// Accessibility label for sine button
  ///
  /// In en, this message translates to:
  /// **'Sine'**
  String get semanticSin;

  /// Accessibility label for cosine button
  ///
  /// In en, this message translates to:
  /// **'Cosine'**
  String get semanticCos;

  /// Accessibility label for tangent button
  ///
  /// In en, this message translates to:
  /// **'Tangent'**
  String get semanticTan;

  /// Accessibility label for inverse sine button
  ///
  /// In en, this message translates to:
  /// **'Inverse sine'**
  String get semanticArcsin;

  /// Accessibility label for inverse cosine button
  ///
  /// In en, this message translates to:
  /// **'Inverse cosine'**
  String get semanticArccos;

  /// Accessibility label for inverse tangent button
  ///
  /// In en, this message translates to:
  /// **'Inverse tangent'**
  String get semanticArctan;

  /// Accessibility label for base 10 logarithm button
  ///
  /// In en, this message translates to:
  /// **'Base 10 logarithm'**
  String get semanticLog;

  /// Accessibility label for natural logarithm button
  ///
  /// In en, this message translates to:
  /// **'Natural logarithm'**
  String get semanticLn;

  /// Accessibility label for 10^x button
  ///
  /// In en, this message translates to:
  /// **'10 to the power of x'**
  String get semanticExp10;

  /// Accessibility label for e^x button
  ///
  /// In en, this message translates to:
  /// **'E to the power of x'**
  String get semanticExpE;

  /// Accessibility label for x squared button
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get semanticSquare;

  /// Accessibility label for x cubed button
  ///
  /// In en, this message translates to:
  /// **'Cube'**
  String get semanticCube;

  /// Accessibility label for x^y button
  ///
  /// In en, this message translates to:
  /// **'X to the power of y'**
  String get semanticPower;

  /// Accessibility label for cube root button
  ///
  /// In en, this message translates to:
  /// **'Cube root'**
  String get semanticCubeRoot;

  /// Accessibility label for square root button
  ///
  /// In en, this message translates to:
  /// **'Square root'**
  String get semanticSqrt;

  /// Accessibility label for 1/x button
  ///
  /// In en, this message translates to:
  /// **'One divided by x'**
  String get semanticReciprocal;

  /// Accessibility label for |x| button
  ///
  /// In en, this message translates to:
  /// **'Absolute value'**
  String get semanticAbsoluteValue;

  /// Accessibility label for factorial button
  ///
  /// In en, this message translates to:
  /// **'Factorial'**
  String get semanticFactorial;

  /// Accessibility label for nPr button
  ///
  /// In en, this message translates to:
  /// **'Permutation'**
  String get semanticPermutation;

  /// Accessibility label for pi constant button
  ///
  /// In en, this message translates to:
  /// **'Pi'**
  String get semanticPi;

  /// Accessibility label for Euler's number constant button
  ///
  /// In en, this message translates to:
  /// **'Euler\'s number'**
  String get semanticEuler;

  /// Accessibility label for open parenthesis button
  ///
  /// In en, this message translates to:
  /// **'Open parenthesis'**
  String get semanticOpenParen;

  /// Accessibility label for close parenthesis button
  ///
  /// In en, this message translates to:
  /// **'Close parenthesis'**
  String get semanticCloseParen;

  /// Accessibility label for memory add button
  ///
  /// In en, this message translates to:
  /// **'Memory add'**
  String get semanticMemoryAdd;

  /// Accessibility label for memory subtract button
  ///
  /// In en, this message translates to:
  /// **'Memory subtract'**
  String get semanticMemorySubtract;

  /// Accessibility label for memory recall button
  ///
  /// In en, this message translates to:
  /// **'Memory recall'**
  String get semanticMemoryRecall;

  /// Accessibility label for memory clear button
  ///
  /// In en, this message translates to:
  /// **'Memory clear'**
  String get semanticMemoryClear;

  /// Accessibility label for DEG/RAD toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle angle mode'**
  String get semanticAngleModeToggle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'it', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
