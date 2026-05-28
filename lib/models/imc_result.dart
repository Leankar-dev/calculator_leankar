import 'package:calculator_05122025/utils/enums/imc_classification.dart';

class ImcResult {
  final double weightKg;
  final double heightCm;
  final double imc;
  final ImcClassification classification;
  final DateTime calculatedAt;

  const ImcResult({
    required this.weightKg,
    required this.heightCm,
    required this.imc,
    required this.classification,
    required this.calculatedAt,
  });

  factory ImcResult.calculate({
    required double weightKg,
    required double heightCm,
  }) {
    final heightM = heightCm / 100.0;
    final rawImc = weightKg / (heightM * heightM);
    final roundedImc = double.parse(rawImc.toStringAsFixed(2));
    return ImcResult(
      weightKg: weightKg,
      heightCm: heightCm,
      imc: roundedImc,
      classification: ImcClassification.fromImc(roundedImc),
      calculatedAt: DateTime.now().toUtc(),
    );
  }

  String get formattedImc => imc.toStringAsFixed(1).replaceAll('.', ',');

  String get formattedWeight =>
      '${weightKg.toStringAsFixed(1).replaceAll('.', ',')} kg';

  String get formattedHeight => '${heightCm.toStringAsFixed(0)} cm';

  double get idealWeightMin {
    final heightM = heightCm / 100.0;
    return double.parse((18.5 * heightM * heightM).toStringAsFixed(1));
  }

  double get idealWeightMax {
    final heightM = heightCm / 100.0;
    return double.parse((24.9 * heightM * heightM).toStringAsFixed(1));
  }

  double get idealWeightDifference {
    final min = idealWeightMin;
    final max = idealWeightMax;
    if (weightKg < min) {
      return double.parse((weightKg - min).toStringAsFixed(1));
    }
    if (weightKg > max) {
      return double.parse((weightKg - max).toStringAsFixed(1));
    }
    return 0.0;
  }

  String get formattedIdealWeightRange {
    final min = idealWeightMin.toStringAsFixed(1).replaceAll('.', ',');
    final max = idealWeightMax.toStringAsFixed(1).replaceAll('.', ',');
    return '$min – $max kg';
  }

  String get formattedIdealWeightDifference {
    final diff = idealWeightDifference;
    if (diff == 0.0) return '';
    final absStr = diff.abs().toStringAsFixed(1).replaceAll('.', ',');
    final sign = diff > 0 ? '+' : '-';
    return '$sign$absStr kg';
  }
}
