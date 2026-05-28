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
