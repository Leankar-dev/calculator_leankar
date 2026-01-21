import 'dart:math' as math;

import 'package:calculator_05122025/utils/constants.dart';
import 'package:intl/intl.dart';

/// Classe utilitária para formatação e parse de números.
class NumberFormatter {
  NumberFormatter._();

  static const String _locale = 'pt_BR';

  static final NumberFormat _thousandsFormatter = NumberFormat(
    '#,##0.########',
    _locale,
  );

  static final NumberFormat _integerFormatter = NumberFormat('#,##0', _locale);

  static const double _scientificThresholdSmall = 1e-6;

  static const double _scientificThresholdLarge = 1e12;

  static String format(double value) {
    if (value.isNaN) return AppConstants.nanError;
    if (value.isInfinite) return AppConstants.infinityError;

    final absValue = value.abs();

    if (absValue > 0 && absValue < _scientificThresholdSmall) {
      return _formatScientific(value);
    }

    if (absValue >= _scientificThresholdLarge) {
      return _formatScientific(value);
    }

    if (value == value.roundToDouble() &&
        absValue < _scientificThresholdLarge) {
      return _integerFormatter.format(value.toInt());
    }

    String formatted = _thousandsFormatter.format(value);
    formatted = _removeTrailingZeros(formatted);

    return formatted;
  }

  static String _formatScientific(double value) {
    if (value == 0) return '0';

    final exponent = (math.log(value.abs()) / math.ln10).floor();
    final mantissa = value / _pow10(exponent);

    String mantissaStr = mantissa.toStringAsFixed(4);
    mantissaStr = mantissaStr.replaceAll('.', AppConstants.decimalSeparator);
    mantissaStr = _removeTrailingZeros(mantissaStr);

    return '${mantissaStr}e$exponent';
  }

  static String _removeTrailingZeros(String formatted) {
    if (!formatted.contains(AppConstants.decimalSeparator)) {
      return formatted;
    }

    while (formatted.endsWith('0')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    if (formatted.endsWith(AppConstants.decimalSeparator)) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return formatted;
  }

  static double _pow10(int exponent) {
    if (exponent >= 0) {
      double result = 1;
      for (int i = 0; i < exponent; i++) {
        result *= 10;
      }
      return result;
    } else {
      double result = 1;
      for (int i = 0; i < -exponent; i++) {
        result /= 10;
      }
      return result;
    }
  }

  static double? parse(String text) {
    if (text.isEmpty) return null;

    try {
      String cleaned = text.trim();

      if (cleaned.contains('e') || cleaned.contains('E')) {
        return _parseScientific(cleaned);
      }

      cleaned = cleaned.replaceAll('.', '');
      cleaned = cleaned.replaceAll(AppConstants.decimalSeparator, '.');

      return double.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }

  static double? _parseScientific(String text) {
    try {
      final normalized = text.replaceAll(AppConstants.decimalSeparator, '.');
      return double.tryParse(normalized);
    } catch (_) {
      return null;
    }
  }

  static bool isValidNumber(String text) {
    return parse(text) != null;
  }

  static String formatForHistory(String text) {
    final value = parse(text);
    if (value == null) return text;
    return format(value);
  }
}
