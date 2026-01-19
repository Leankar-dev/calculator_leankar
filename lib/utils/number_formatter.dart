import 'dart:math' as math;

import 'package:calculator_05122025/utils/constants.dart';
import 'package:intl/intl.dart';

/// Classe utilitária para formatação e parse de números.
/// Usa o padrão brasileiro (vírgula decimal, ponto para milhares).
class NumberFormatter {
  NumberFormatter._();

  /// Locale brasileiro
  static const String _locale = 'pt_BR';

  /// Formatador para números com separador de milhares
  static final NumberFormat _thousandsFormatter =
      NumberFormat('#,##0.########', _locale);

  /// Formatador para números inteiros com separador de milhares
  static final NumberFormat _integerFormatter = NumberFormat('#,##0', _locale);

  /// Limite para usar notação científica (números muito pequenos)
  static const double _scientificThresholdSmall = 1e-6;

  /// Limite para usar notação científica (números muito grandes)
  static const double _scientificThresholdLarge = 1e12;

  /// Formata um número para exibição no display.
  /// - Usa separador de milhares (ponto)
  /// - Usa vírgula como separador decimal
  /// - Remove zeros desnecessários à direita
  /// - Usa notação científica para valores extremos
  static String format(double value) {
    // Tratamento de valores especiais
    if (value.isNaN) return AppConstants.nanError;
    if (value.isInfinite) return AppConstants.infinityError;

    final absValue = value.abs();

    // Notação científica para números muito pequenos (exceto zero)
    if (absValue > 0 && absValue < _scientificThresholdSmall) {
      return _formatScientific(value);
    }

    // Notação científica para números muito grandes
    if (absValue >= _scientificThresholdLarge) {
      return _formatScientific(value);
    }

    // Número inteiro - sem casas decimais
    if (value == value.roundToDouble() && absValue < _scientificThresholdLarge) {
      return _integerFormatter.format(value.toInt());
    }

    // Número decimal - formata e remove zeros à direita
    String formatted = _thousandsFormatter.format(value);
    formatted = _removeTrailingZeros(formatted);

    return formatted;
  }

  /// Formata número em notação científica.
  /// Ex: 1.23e-8 ou 1,23×10⁻⁸
  static String _formatScientific(double value) {
    if (value == 0) return '0';

    final exponent = (math.log(value.abs()) / math.ln10).floor();
    final mantissa = value / _pow10(exponent);

    // Formata mantissa com até 4 casas decimais
    String mantissaStr = mantissa.toStringAsFixed(4);
    mantissaStr = mantissaStr.replaceAll('.', AppConstants.decimalSeparator);
    mantissaStr = _removeTrailingZeros(mantissaStr);

    // Usa formato compacto: 1,23e8 ou 1,23e-8
    return '${mantissaStr}e$exponent';
  }

  /// Remove zeros desnecessários à direita após o decimal.
  static String _removeTrailingZeros(String formatted) {
    if (!formatted.contains(AppConstants.decimalSeparator)) {
      return formatted;
    }

    // Remove zeros à direita
    while (formatted.endsWith('0')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    // Remove vírgula se ficou sozinha
    if (formatted.endsWith(AppConstants.decimalSeparator)) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return formatted;
  }

  /// Potência de 10.
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

  /// Faz parse de uma string formatada para double.
  /// Aceita formato brasileiro (vírgula decimal, ponto milhares).
  static double? parse(String text) {
    if (text.isEmpty) return null;

    try {
      // Remove espaços
      String cleaned = text.trim();

      // Trata notação científica
      if (cleaned.contains('e') || cleaned.contains('E')) {
        return _parseScientific(cleaned);
      }

      // Remove separador de milhares (ponto) e converte decimal (vírgula para ponto)
      cleaned = cleaned.replaceAll('.', ''); // Remove milhares
      cleaned =
          cleaned.replaceAll(AppConstants.decimalSeparator, '.'); // Decimal

      return double.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }

  /// Faz parse de notação científica.
  static double? _parseScientific(String text) {
    try {
      // Normaliza: substitui vírgula por ponto
      final normalized = text.replaceAll(AppConstants.decimalSeparator, '.');
      return double.tryParse(normalized);
    } catch (_) {
      return null;
    }
  }

  /// Verifica se uma string representa um número válido.
  static bool isValidNumber(String text) {
    return parse(text) != null;
  }

  /// Formata número para exibição no histórico (mais compacto).
  static String formatForHistory(String text) {
    final value = parse(text);
    if (value == null) return text;
    return format(value);
  }
}
