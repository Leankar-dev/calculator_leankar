import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/enums/imc_classification.dart';

extension ImcClassificationL10nExtension on ImcClassification {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case ImcClassification.underweight:
        return l10n.imcClassificationUnderweight;
      case ImcClassification.normal:
        return l10n.imcClassificationNormal;
      case ImcClassification.overweight:
        return l10n.imcClassificationOverweight;
      case ImcClassification.obesityI:
        return l10n.imcClassificationObesityI;
      case ImcClassification.obesityII:
        return l10n.imcClassificationObesityII;
      case ImcClassification.obesityIII:
        return l10n.imcClassificationObesityIII;
    }
  }
}
