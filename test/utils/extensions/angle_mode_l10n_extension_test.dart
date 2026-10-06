import 'package:calculator_05122025/l10n/app_localizations_en.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/extensions/angle_mode_l10n_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('AngleModeL10nExtension', () {
    test('localizedLabel retorna o rótulo de graus para AngleMode.deg', () {
      expect(AngleMode.deg.localizedLabel(l10n), l10n.scientificAngleModeDeg);
    });

    test('localizedLabel retorna o rótulo de radianos para AngleMode.rad', () {
      expect(AngleMode.rad.localizedLabel(l10n), l10n.scientificAngleModeRad);
    });
  });
}
