import 'dart:math' as math;

import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/enums/imc_classification.dart';
import 'package:flutter/material.dart';

class ImcGaugeWidget extends StatelessWidget {
  final double imc;
  final ImcClassification classification;

  const ImcGaugeWidget({
    super.key,
    required this.imc,
    required this.classification,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.imcGaugeWidth,
      height: AppSizes.imcGaugeHeight,
      child: CustomPaint(
        painter: _GaugePainter(imc: imc, classification: classification),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: AppSizes.imcGaugePaddingBottom,
            ),
            child: Text(
              imc.toStringAsFixed(1).replaceAll('.', ','),
              style: TextStyle(
                fontSize: AppSizes.imcGaugeValueFontSize,
                fontWeight: FontWeight.bold,
                color: classification.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double imc;
  final ImcClassification classification;

  _GaugePainter({required this.imc, required this.classification});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.imcGaugeStrokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey.withAlpha(51);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    final clampedImc = imc.clamp(
      AppSizes.imcGaugeMinImc,
      AppSizes.imcGaugeMaxImc,
    );
    final sweep =
        ((clampedImc - AppSizes.imcGaugeMinImc) /
            (AppSizes.imcGaugeMaxImc - AppSizes.imcGaugeMinImc)) *
        math.pi;

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.imcGaugeStrokeWidth
      ..strokeCap = StrokeCap.round
      ..color = classification.color;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweep,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.imc != imc || old.classification != classification;
}
