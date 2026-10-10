import 'dart:ui';

import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const titleMinimumContrast = 7.0;
  const taglineMinimumContrast = 4.5;

  double contrastRatio(Color foreground, Color background) {
    final foregroundLuminance = foreground.computeLuminance();
    final backgroundLuminance = background.computeLuminance();
    final lighter = foregroundLuminance > backgroundLuminance
        ? foregroundLuminance
        : backgroundLuminance;
    final darker = foregroundLuminance > backgroundLuminance
        ? backgroundLuminance
        : foregroundLuminance;
    return (lighter + 0.05) / (darker + 0.05);
  }

  final backgrounds = <String, Color>{
    'início do gradiente': AppColors.splashGradientStart,
    'fim do gradiente': AppColors.splashGradientEnd,
    'cor plana nativa': AppColors.splashNativeFlat,
  };

  group('contraste dos textos da splash', () {
    backgrounds.forEach((name, background) {
      test('o título tem contraste mínimo de 7:1 sobre o $name', () {
        expect(
          contrastRatio(AppColors.splashTitle, background),
          greaterThanOrEqualTo(titleMinimumContrast),
        );
      });

      test('a tagline tem contraste mínimo de 4,5:1 sobre o $name', () {
        expect(
          contrastRatio(AppColors.splashTagline, background),
          greaterThanOrEqualTo(taglineMinimumContrast),
        );
      });
    });
  });
}
