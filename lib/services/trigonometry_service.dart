import 'dart:math' as math;

import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:calculator_05122025/utils/numeric_precision.dart';

class TrigonometryService {
  static const double _fullTurnDegrees = 360;
  static const double _halfTurnDegrees = 180;
  static const double _quarterTurnDegrees = 90;
  static const double _undefinedTangentCosine = 1e-15;

  static const List<double> _exactSineByQuadrant = [0, 1, 0, -1];
  static const List<double> _exactCosineByQuadrant = [1, 0, -1, 0];

  double sin(double value, AngleMode angleMode) {
    final exactValue = _exactDegreesValue(
      value,
      angleMode,
      _exactSineByQuadrant,
    );
    if (exactValue != null) return exactValue;

    final radians = _toRadians(value, angleMode);
    return NumericPrecision.snapTrigonometricNoiseToZero(
      result: math.sin(radians),
      angleInRadians: radians,
    );
  }

  double cos(double value, AngleMode angleMode) {
    final exactValue = _exactDegreesValue(
      value,
      angleMode,
      _exactCosineByQuadrant,
    );
    if (exactValue != null) return exactValue;

    final radians = _toRadians(value, angleMode);
    return NumericPrecision.snapTrigonometricNoiseToZero(
      result: math.cos(radians),
      angleInRadians: radians,
    );
  }

  double tan(double value, AngleMode angleMode) {
    if (angleMode == AngleMode.deg) {
      final halfTurnRemainder = value % _halfTurnDegrees;
      if (halfTurnRemainder == 0) return 0;
      if (halfTurnRemainder == _quarterTurnDegrees) {
        throw const ScientificCalculationException(
          ScientificErrorType.domainError,
        );
      }
    }

    final radians = _toRadians(value, angleMode);
    if (math.cos(radians).abs() < _undefinedTangentCosine) {
      throw const ScientificCalculationException(
        ScientificErrorType.domainError,
      );
    }
    return NumericPrecision.snapTrigonometricNoiseToZero(
      result: math.tan(radians),
      angleInRadians: radians,
    );
  }

  double asin(double value, AngleMode angleMode) {
    _requireUnitInterval(value);
    return _fromRadians(math.asin(value), angleMode);
  }

  double acos(double value, AngleMode angleMode) {
    _requireUnitInterval(value);
    return _fromRadians(math.acos(value), angleMode);
  }

  double atan(double value, AngleMode angleMode) {
    return _fromRadians(math.atan(value), angleMode);
  }

  double? _exactDegreesValue(
    double value,
    AngleMode angleMode,
    List<double> valuesByQuadrant,
  ) {
    if (angleMode != AngleMode.deg) return null;

    final normalizedDegrees = value % _fullTurnDegrees;
    if (normalizedDegrees % _quarterTurnDegrees != 0) return null;

    return valuesByQuadrant[(normalizedDegrees ~/ _quarterTurnDegrees)];
  }

  double _toRadians(double value, AngleMode angleMode) {
    return angleMode == AngleMode.deg
        ? value * math.pi / _halfTurnDegrees
        : value;
  }

  double _fromRadians(double value, AngleMode angleMode) {
    return angleMode == AngleMode.deg
        ? value * _halfTurnDegrees / math.pi
        : value;
  }

  void _requireUnitInterval(double value) {
    if (value < -1 || value > 1) {
      throw const ScientificCalculationException(
        ScientificErrorType.domainError,
      );
    }
  }
}
