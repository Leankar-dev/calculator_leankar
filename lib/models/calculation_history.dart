import 'dart:convert';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';

class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timestamp;

  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    final expression = json['expression'];
    final result = json['result'];
    final timestamp = json['timestamp'];

    if (expression == null || expression is! String) {
      throw FormatException('Campo "expression" inválido ou ausente');
    }
    if (result == null || result is! String) {
      throw FormatException('Campo "result" inválido ou ausente');
    }
    if (timestamp == null || timestamp is! String) {
      throw FormatException('Campo "timestamp" inválido ou ausente');
    }

    DateTime parsedTimestamp;
    try {
      parsedTimestamp = DateTime.parse(timestamp);
    } catch (e) {
      throw FormatException('Formato de timestamp inválido: $timestamp');
    }

    return CalculationHistory(
      expression: expression,
      result: result,
      timestamp: parsedTimestamp,
    );
  }

  static CalculationHistory? tryFromJson(Map<String, dynamic> json) {
    try {
      return CalculationHistory.fromJson(json);
    } catch (e) {
      logger.warning(
        'Falha ao parsear item do histórico: $e',
        tag: 'CalculationHistory',
      );
      return null;
    }
  }

  static String encodeList(List<CalculationHistory> history) {
    return jsonEncode(history.map((h) => h.toJson()).toList());
  }

  static Result<List<CalculationHistory>> decodeList(String jsonString) {
    try {
      if (jsonString.isEmpty) {
        return Result.success([]);
      }

      final dynamic decoded;
      try {
        decoded = jsonDecode(jsonString);
      } catch (e) {
        logger.logError(
          ErrorType.corruptedData,
          tag: 'CalculationHistory',
          details: 'JSON malformado: ${e.toString()}',
        );
        return Result.failure(
          ErrorType.corruptedData,
          'JSON malformado: ${e.toString()}',
        );
      }

      if (decoded is! List) {
        logger.logError(
          ErrorType.corruptedData,
          tag: 'CalculationHistory',
          details: 'Esperado List, recebido ${decoded.runtimeType}',
        );
        return Result.failure(
          ErrorType.corruptedData,
          'Formato inválido: esperado lista, recebido ${decoded.runtimeType}',
        );
      }

      final List<CalculationHistory> history = [];
      int skippedCount = 0;

      for (int i = 0; i < decoded.length; i++) {
        final item = decoded[i];
        if (item is! Map<String, dynamic>) {
          logger.warning(
            'Item $i não é um Map válido, pulando',
            tag: 'CalculationHistory',
          );
          skippedCount++;
          continue;
        }

        final parsed = tryFromJson(item);
        if (parsed != null) {
          history.add(parsed);
        } else {
          skippedCount++;
        }
      }

      if (skippedCount > 0) {
        logger.warning(
          'Carregamento parcial: $skippedCount itens inválidos ignorados',
          tag: 'CalculationHistory',
        );
      }

      return Result.success(history);
    } catch (e, stackTrace) {
      logger.logError(
        ErrorType.corruptedData,
        tag: 'CalculationHistory',
        details: e.toString(),
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(ErrorType.corruptedData, e.toString());
    }
  }
}
