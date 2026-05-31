// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get calculatorPageTitle => 'CALCULATOR';

  @override
  String get imcPageTitle => 'Calculateur IMC';

  @override
  String get settingsPageTitle => 'Paramètres';

  @override
  String get drawerItemHistory => 'Historique';

  @override
  String get drawerItemImc => 'Calculateur IMC';

  @override
  String get drawerItemSettings => 'Paramètres';

  @override
  String get historyTitle => 'Historique';

  @override
  String get historyClearButton => 'Effacer';

  @override
  String get historyEmptyMessage => 'Pas d\'historique de calculs';

  @override
  String get snackbarValueCopied => 'Valeur copiée';

  @override
  String get snackbarEmptyClipboard => 'Presse-papiers vide';

  @override
  String get snackbarInvalidPaste => 'Valeur invalide à coller';

  @override
  String get snackbarOutOfRange => 'Valeur hors des limites autorisées';

  @override
  String get errorDivisionByZero => 'Err: Div/0';

  @override
  String get errorInfinity => 'Err: Infini';

  @override
  String get errorNan => 'Err: Invalide';

  @override
  String get errorOverflow => 'Err: Overflow';

  @override
  String get errorGeneric => 'Erreur';

  @override
  String get settingsAppearanceSection => 'APPARENCE';

  @override
  String get themeOptionSystem => 'Système';

  @override
  String get themeOptionLight => 'Clair';

  @override
  String get themeOptionDark => 'Sombre';

  @override
  String get settingsLanguageSection => 'LANGUE';

  @override
  String get settingsAboutSection => 'À PROPOS';

  @override
  String get settingsVersionLabel => 'Version';

  @override
  String get settingsDeveloperLabel => 'Développeur';

  @override
  String get settingsEmailLabel => 'E-mail';

  @override
  String get settingsWebsiteLabel => 'Site web';

  @override
  String get imcWeightLabel => 'Poids';

  @override
  String get imcHeightLabel => 'Taille';

  @override
  String get imcCalculateButton => 'Calculer IMC';

  @override
  String get imcInvalidWeightError =>
      'Poids invalide. Entrez entre 1 et 500 kg.';

  @override
  String get imcInvalidHeightError =>
      'Taille invalide. Entrez entre 50 et 250 cm.';

  @override
  String get imcCalculationError => 'Erreur de calcul. Vérifiez les valeurs.';

  @override
  String get imcIdealWeightTitle => 'POIDS IDÉAL';

  @override
  String get imcIdealWeightRangeLabel => 'Plage saine';

  @override
  String get imcIdealWeightStatusLabel => 'Statut';

  @override
  String get imcIdealWeightDiffLabel => 'Différence';

  @override
  String get imcIdealWeightOnRange => 'Dans la plage idéale';

  @override
  String get imcIdealWeightAbove => 'Au-dessus de l\'idéal';

  @override
  String get imcIdealWeightBelow => 'En dessous de l\'idéal';

  @override
  String get imcClassificationUnderweight => 'Insuffisance pondérale';

  @override
  String get imcClassificationNormal => 'Poids normal';

  @override
  String get imcClassificationOverweight => 'Surpoids';

  @override
  String get imcClassificationObesityI => 'Obésité Grade I';

  @override
  String get imcClassificationObesityII => 'Obésité Grade II';

  @override
  String get imcClassificationObesityIII => 'Obésité Grade III';

  @override
  String get semanticDivide => 'Diviser';

  @override
  String get semanticMultiply => 'Multiplier';

  @override
  String get semanticSubtract => 'Soustraire';

  @override
  String get semanticAdd => 'Ajouter';

  @override
  String get semanticBackspace => 'Supprimer le dernier chiffre';

  @override
  String get semanticPercent => 'Pourcentage';

  @override
  String get semanticEquals => 'Calculer le résultat';

  @override
  String get semanticClear => 'Tout effacer';

  @override
  String get semanticDecimalSeparator => 'Séparateur décimal';

  @override
  String get adConsentDialogTitle => 'Confidentialité et Publicités';

  @override
  String get adConsentDialogBody =>
      'Cette app affiche des publicités pour rester gratuite. Vous pouvez choisir vos préférences de confidentialité.';

  @override
  String get adConsentAccept => 'Accepter';

  @override
  String get adConsentDecline => 'Refuser';

  @override
  String get adLoadingPlaceholder => 'Chargement de la publicité...';

  @override
  String get adUnavailable => 'Publicité indisponible';
}
