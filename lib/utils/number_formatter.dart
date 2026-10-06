import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  static final NumberFormat _thousandsFormatter = NumberFormat(
    '#,##0.########',
    AppStrings.locale,
  );

  static final NumberFormat _integerFormatter = NumberFormat(
    '#,##0',
    AppStrings.locale,
  );

  static const int _scientificMantissaDecimals = 4;

  static const double _maxPlainIntegerMagnitude = 1e21;

  static const int _thousandsGroupLength = 3;

  static String format(double value) {
    if (value.isNaN) return 'NaN';
    if (value.isInfinite) return value > 0 ? '∞' : '-∞';

    final absValue = value.abs();

    if (absValue > 0 && absValue < AppStrings.scientificThresholdSmall) {
      return _formatScientific(value);
    }

    if (absValue >= AppStrings.scientificThresholdLarge) {
      return _formatScientific(value);
    }

    if (value == value.roundToDouble()) {
      return _integerFormatter.format(value.toInt());
    }

    return _removeTrailingZeros(_thousandsFormatter.format(value));
  }

  static String toCanonicalString(double value) {
    if (value == 0) return AppStrings.initialDisplayValue;

    final isWholeNumber = value == value.roundToDouble();
    if (isWholeNumber && value.abs() < _maxPlainIntegerMagnitude) {
      return value.toStringAsFixed(0);
    }

    return value.toString().replaceAll('.', AppStrings.decimalSeparator);
  }

  static String _formatScientific(double value) {
    final parts = value
        .toStringAsExponential(_scientificMantissaDecimals)
        .split('e');
    final mantissa = _removeTrailingZeros(
      parts.first.replaceAll('.', AppStrings.decimalSeparator),
    );
    final exponent = int.parse(parts.last);

    return '${mantissa}e$exponent';
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

    final cleaned = text.trim();

    if (cleaned.contains('e') || cleaned.contains('E')) {
      return _finiteOrNull(
        double.tryParse(cleaned.replaceAll(AppStrings.decimalSeparator, '.')),
      );
    }

    if (_looksLikeUnambiguousDotDecimal(cleaned)) {
      return _finiteOrNull(double.tryParse(cleaned));
    }

    final withoutThousands = cleaned.replaceAll('.', '');
    return _finiteOrNull(
      double.tryParse(
        withoutThousands.replaceAll(AppStrings.decimalSeparator, '.'),
      ),
    );
  }

  static double? _finiteOrNull(double? value) {
    if (value == null || !value.isFinite) return null;
    return value;
  }

  static bool _looksLikeUnambiguousDotDecimal(String cleaned) {
    if (cleaned.contains(AppStrings.decimalSeparator)) return false;

    final dotIndex = cleaned.indexOf('.');
    if (dotIndex == -1 || dotIndex != cleaned.lastIndexOf('.')) return false;

    final digitsAfterDot = cleaned.length - dotIndex - 1;
    if (digitsAfterDot == 0) return false;
    if (digitsAfterDot != _thousandsGroupLength) return true;

    final unsignedIntegerPart = cleaned
        .substring(0, dotIndex)
        .replaceFirst(RegExp(r'^[+-]'), '');
    final cannotBeThousandsGroup =
        unsignedIntegerPart.startsWith('0') ||
        unsignedIntegerPart.length > _thousandsGroupLength;
    return cannotBeThousandsGroup;
  }
}
