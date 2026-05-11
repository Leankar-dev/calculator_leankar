import 'dart:math' as math;
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  static final NumberFormat _thousandsFormatter = NumberFormat(
    '#,##0.########',
    AppStrings.locale,
  );

  static final NumberFormat _integerFormatter =
      NumberFormat('#,##0', AppStrings.locale);

  static const double _scientificThresholdSmall = 1e-6;

  static const double _scientificThresholdLarge = 1e12;

  static String format(double value) {
    if (value.isNaN) return AppStrings.nanError;
    if (value.isInfinite) return AppStrings.infinityError;

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
    final mantissa = value / math.pow(10, exponent).toDouble();

    final int decimalPlaces = mantissa == mantissa.roundToDouble() ? 0 : 4;
    String mantissaStr = mantissa.toStringAsFixed(decimalPlaces);
    mantissaStr = mantissaStr.replaceAll('.', AppStrings.decimalSeparator);
    mantissaStr = _removeTrailingZeros(mantissaStr);

    return '${mantissaStr}e$exponent';
  }

  static String _removeTrailingZeros(String formatted) {
    if (!formatted.contains(AppStrings.decimalSeparator)) {
      return formatted;
    }

    while (formatted.endsWith('0')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    if (formatted.endsWith(AppStrings.decimalSeparator)) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return formatted;
  }

  static double? parse(String text) {
    if (text.isEmpty) return null;

    try {
      String cleaned = text.trim();

      if (cleaned.contains('e') || cleaned.contains('E')) {
        return _parseScientific(cleaned);
      }

      cleaned = cleaned.replaceAll('.', '');
      cleaned = cleaned.replaceAll(AppStrings.decimalSeparator, '.');

      return double.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }

  static double? _parseScientific(String text) {
    try {
      final normalized = text.replaceAll(AppStrings.decimalSeparator, '.');
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
