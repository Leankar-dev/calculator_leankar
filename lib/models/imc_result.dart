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
}
