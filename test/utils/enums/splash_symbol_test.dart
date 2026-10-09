import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/splash_symbol.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SplashSymbol', () {
    test('possui seis símbolos', () {
      expect(SplashSymbol.values.length, 6);
    });

    test('os ângulos são distintos e espaçados em 60 graus', () {
      final angles = SplashSymbol.values
          .map((symbol) => symbol.angleDegrees)
          .toList();

      expect(angles.toSet().length, SplashSymbol.values.length);

      final sortedAngles = [...angles]..sort();
      for (var index = 1; index < sortedAngles.length; index++) {
        expect(sortedAngles[index] - sortedAngles[index - 1], 60.0);
      }
    });

    test('o primeiro símbolo da órbita fica no topo', () {
      expect(SplashSymbol.addition.angleDegrees, -90.0);
    });

    test('os atrasos são estritamente crescentes e menores que 1', () {
      final delays = SplashSymbol.values
          .map((symbol) => symbol.delayFraction)
          .toList();

      for (var index = 1; index < delays.length; index++) {
        expect(delays[index], greaterThan(delays[index - 1]));
      }
      expect(delays.first, 0.0);
      expect(delays.last, lessThan(1.0));
    });

    test('os rótulos são únicos e não vazios', () {
      final labels = SplashSymbol.values.map((symbol) => symbol.label).toList();

      expect(labels.every((label) => label.isNotEmpty), isTrue);
      expect(labels.toSet().length, labels.length);
    });

    test('cada símbolo usa o rótulo e a cor do botão correspondente', () {
      expect(SplashSymbol.addition.label, AppStrings.additionSymbol);
      expect(SplashSymbol.addition.color, AppColors.operationButton);
      expect(SplashSymbol.subtraction.label, AppStrings.subtractionSymbol);
      expect(SplashSymbol.subtraction.color, AppColors.backspaceButton);
      expect(
        SplashSymbol.multiplication.label,
        AppStrings.multiplicationSymbol,
      );
      expect(SplashSymbol.multiplication.color, AppColors.clearButton);
      expect(SplashSymbol.division.label, AppStrings.divisionSymbol);
      expect(SplashSymbol.division.color, AppColors.equalsButton);
      expect(SplashSymbol.equals.label, AppStrings.equalsButtonText);
      expect(SplashSymbol.equals.color, AppColors.scientificFunction);
      expect(SplashSymbol.percent.label, AppStrings.percentSymbol);
      expect(SplashSymbol.percent.color, AppColors.scientificShiftActive);
    });

    test('as cores são todas distintas', () {
      final colors = SplashSymbol.values.map((symbol) => symbol.color).toSet();

      expect(colors.length, SplashSymbol.values.length);
    });
  });
}
