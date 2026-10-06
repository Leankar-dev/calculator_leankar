import 'dart:math' as math;

class NumericPrecision {
  NumericPrecision._();

  static const int _significantDigits = 15;
  static const double _cancellationTolerance = 1e-14;
  static const double _trigonometricNoiseThreshold = 1e-15;
  static const double _trigonometricNoiseMinimumAngle = 1e-9;

  static double roundToSignificantDigits(double value) {
    if (!value.isFinite || value == 0) return value;
    return double.parse(value.toStringAsPrecision(_significantDigits));
  }

  static double snapCancellationToZero({
    required double result,
    required double left,
    required double right,
  }) {
    final operandMagnitude = math.max(left.abs(), right.abs());
    final isCancellationNoise =
        result.abs() < operandMagnitude * _cancellationTolerance;
    return isCancellationNoise ? 0 : result;
  }

  static double snapTrigonometricNoiseToZero({
    required double result,
    required double angleInRadians,
  }) {
    final isTrigonometricNoise =
        result.abs() < _trigonometricNoiseThreshold &&
        angleInRadians.abs() > _trigonometricNoiseMinimumAngle;
    return isTrigonometricNoise ? 0 : result;
  }
}
