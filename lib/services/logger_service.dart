import 'dart:developer' as developer;

import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug(0, 'DEBUG'),
  info(1, 'INFO'),
  warning(2, 'WARN'),
  error(3, 'ERROR')
  ;

  const LogLevel(this.priority, this.label);
  final int priority;
  final String label;
}

class LoggerService {
  LoggerService._();

  static final LoggerService _instance = LoggerService._();
  static LoggerService get instance => _instance;

  LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;

  void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  void debug(String message, {String? tag, Object? data}) {
    _log(LogLevel.debug, message, tag: tag, data: data);
  }

  void info(String message, {String? tag, Object? data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  void warning(String message, {String? tag, Object? data}) {
    _log(LogLevel.warning, message, tag: tag, data: data);
  }

  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      data: error,
      stackTrace: stackTrace,
    );
  }

  void logError(
    ErrorType errorType, {
    String? tag,
    String? details,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final message = details != null
        ? '${errorType.fullMessage} - $details'
        : errorType.fullMessage;

    _log(
      LogLevel.error,
      message,
      tag: tag ?? 'ErrorType.${errorType.name}',
      data: error,
      stackTrace: stackTrace,
    );
  }

  void logCalculation({
    required String operation,
    required String firstOperand,
    required String secondOperand,
    required String result,
  }) {
    debug(
      'Cálculo: $firstOperand $operation $secondOperand = $result',
      tag: 'Calculator',
    );
  }

  void logStorage(String action, {bool success = true, String? details}) {
    if (success) {
      debug(
        'Storage: $action${details != null ? ' - $details' : ''}',
        tag: 'Storage',
      );
    } else {
      warning(
        'Storage falhou: $action${details != null ? ' - $details' : ''}',
        tag: 'Storage',
      );
    }
  }

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? data,
    StackTrace? stackTrace,
  }) {
    if (level.priority < _minLevel.priority) return;

    final timestamp = DateTime.now().toIso8601String();
    final tagPrefix = tag != null ? '[$tag] ' : '';
    final formattedMessage = '${level.label} $timestamp $tagPrefix$message';

    if (kDebugMode) {
      developer.log(
        formattedMessage,
        name: 'Calculator',
        level: _levelToInt(level),
        error: data,
        stackTrace: stackTrace,
      );
    }

    if (kDebugMode) {
      print(formattedMessage);
      if (data != null) {
        print('  Data: $data');
      }
      if (stackTrace != null) {
        print('  StackTrace: $stackTrace');
      }
    }
  }

  int _levelToInt(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}

LoggerService get logger => LoggerService.instance;
