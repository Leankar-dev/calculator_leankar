import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';

extension AngleModeL10nExtension on AngleMode {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case AngleMode.deg:
        return l10n.scientificAngleModeDeg;
      case AngleMode.rad:
        return l10n.scientificAngleModeRad;
    }
  }
}
