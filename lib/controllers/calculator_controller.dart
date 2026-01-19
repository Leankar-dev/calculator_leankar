import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/services/error_handler.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/services/storage_service.dart';
import 'package:calculator_05122025/utils/constants.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/utils/number_formatter.dart';
import 'package:flutter/material.dart';

class CalculatorController extends ChangeNotifier {
  final StorageService _storageService;

  String _displayText = AppConstants.initialDisplayValue;
  String _firstOperand = '';
  String _secondOperand = '';
  OperationsType? _currentOperation;
  bool _shouldResetDisplay = false;
  List<CalculationHistory> _history = [];
  bool _isLoading = false;
  bool _hasError = false;

  CalculatorController({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  String get displayText => _displayText;
  List<CalculationHistory> get history => List.unmodifiable(_history);
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  /// Carrega o histórico com tratamento de erro
  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    final result = await _storageService.loadHistory();

    result.fold(
      onSuccess: (loadedHistory) {
        _history = loadedHistory;
        _hasError = false;
      },
      onFailure: (error, details) {
        logger.warning(
          'Falha ao carregar histórico: ${error.fullMessage}',
          tag: 'CalculatorController',
        );
        _history = [];
        _hasError = true;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  String get expressionDisplay {
    if (_firstOperand.isEmpty || _currentOperation == null) {
      return '';
    }
    return '$_firstOperand ${_currentOperation!.symbol}';
  }

  void setOperationType(OperationsType operation) {
    // Limpa estado de erro anterior se houver
    if (_isErrorState()) {
      clearDisplay();
    }

    if (_firstOperand.isEmpty) {
      _firstOperand = _displayText;
    } else if (!_shouldResetDisplay && _currentOperation != null) {
      _calculatePendingOperation();
      // Se houve erro na operação anterior, não continua
      if (_isErrorState()) return;
      _firstOperand = _displayText;
    }
    _currentOperation = operation;
    _shouldResetDisplay = true;
    notifyListeners();
  }

  void clearDisplay() {
    _displayText = AppConstants.initialDisplayValue;
    _firstOperand = '';
    _secondOperand = '';
    _currentOperation = null;
    _shouldResetDisplay = false;
    notifyListeners();
  }

  void backspace() {
    // Se está em estado de erro, limpa tudo
    if (_isErrorState()) {
      clearDisplay();
      return;
    }

    if (_displayText.length > 1) {
      _displayText = _displayText.substring(0, _displayText.length - 1);
    } else {
      _displayText = AppConstants.initialDisplayValue;
    }
    notifyListeners();
  }

  void calculatePercentage() {
    // Se está em estado de erro, não faz nada
    if (_isErrorState()) return;

    final parseResult = errorHandler.parseDouble(
      _displayText,
      decimalSeparator: AppConstants.decimalSeparator,
    );

    if (parseResult.isFailure) {
      _setErrorDisplay(parseResult.error!);
      return;
    }

    double value = parseResult.value;

    if (_firstOperand.isNotEmpty && _currentOperation != null) {
      final firstResult = errorHandler.parseDouble(
        _firstOperand,
        decimalSeparator: AppConstants.decimalSeparator,
      );

      if (firstResult.isFailure) {
        _setErrorDisplay(firstResult.error!);
        return;
      }

      value = (firstResult.value * value) / 100;
    } else {
      value = value / 100;
    }

    // Valida o resultado
    final validationResult = errorHandler.validateCalculationResult(value);
    if (validationResult.isFailure) {
      _setErrorDisplay(validationResult.error!);
      return;
    }

    _displayText = _formatResult(value);

    logger.logCalculation(
      operation: '%',
      firstOperand: _firstOperand.isEmpty ? _displayText : _firstOperand,
      secondOperand: parseResult.value.toString(),
      result: _displayText,
    );

    notifyListeners();
  }

  void appendNumber(String digit) {
    // Se está em estado de erro, limpa e começa novo número
    if (_isErrorState()) {
      _displayText = digit;
      _shouldResetDisplay = false;
      notifyListeners();
      return;
    }

    // Valida se pode adicionar mais dígitos
    if (!_shouldResetDisplay &&
        !errorHandler.isValidNumberInput(
          _displayText,
          digit,
          decimalSeparator: AppConstants.decimalSeparator,
        )) {
      logger.debug('Entrada rejeitada: número muito longo', tag: 'Input');
      return;
    }

    if (_shouldResetDisplay) {
      _displayText = digit;
      _shouldResetDisplay = false;
    } else if (_displayText == AppConstants.initialDisplayValue &&
        digit != AppConstants.decimalSeparator) {
      _displayText = digit;
    } else {
      _displayText += digit;
    }
    notifyListeners();
  }

  void appendDecimal() {
    // Se está em estado de erro, começa novo número com decimal
    if (_isErrorState()) {
      _displayText =
          '${AppConstants.initialDisplayValue}${AppConstants.decimalSeparator}';
      _shouldResetDisplay = false;
      notifyListeners();
      return;
    }

    if (_shouldResetDisplay) {
      _displayText =
          '${AppConstants.initialDisplayValue}${AppConstants.decimalSeparator}';
      _shouldResetDisplay = false;
    } else if (!_displayText.contains(AppConstants.decimalSeparator)) {
      _displayText += AppConstants.decimalSeparator;
    }
    notifyListeners();
  }

  void _calculatePendingOperation() {
    if (_currentOperation == null || _firstOperand.isEmpty) return;

    _secondOperand = _displayText;

    // Parse dos operandos com tratamento de erro
    final firstResult = errorHandler.parseDouble(
      _firstOperand,
      decimalSeparator: AppConstants.decimalSeparator,
    );

    if (firstResult.isFailure) {
      _setErrorDisplay(firstResult.error!);
      return;
    }

    final secondResult = errorHandler.parseDouble(
      _secondOperand,
      decimalSeparator: AppConstants.decimalSeparator,
    );

    if (secondResult.isFailure) {
      _setErrorDisplay(secondResult.error!);
      return;
    }

    final first = firstResult.value;
    final second = secondResult.value;
    double result = 0;

    switch (_currentOperation!) {
      case OperationsType.addition:
        result = first + second;
        break;
      case OperationsType.subtraction:
        result = first - second;
        break;
      case OperationsType.multiplication:
        result = first * second;
        break;
      case OperationsType.division:
        final divResult = errorHandler.safeDivide(first, second);
        if (divResult.isFailure) {
          _setErrorDisplay(divResult.error!);
          return;
        }
        result = divResult.value;
        break;
    }

    // Valida o resultado final
    final validationResult = errorHandler.validateCalculationResult(result);
    if (validationResult.isFailure) {
      _setErrorDisplay(validationResult.error!);
      return;
    }

    _displayText = _formatResult(result);

    logger.logCalculation(
      operation: _currentOperation!.symbol,
      firstOperand: _firstOperand,
      secondOperand: _secondOperand,
      result: _displayText,
    );
  }

  String _formatResult(double value) {
    return NumberFormatter.format(value);
  }

  void calculateResult() {
    if (_currentOperation == null || _firstOperand.isEmpty) return;
    if (_isErrorState()) return;

    final expression =
        '$_firstOperand ${_currentOperation!.symbol} $_displayText';
    _calculatePendingOperation();

    // Só adiciona ao histórico se não houve erro
    if (!_isErrorState()) {
      _addToHistory(expression, _displayText);
    }

    _firstOperand = _displayText;
    _secondOperand = '';
    _currentOperation = null;
    _shouldResetDisplay = true;
    notifyListeners();
  }

  void _addToHistory(String expression, String result) {
    _history.insert(
      0,
      CalculationHistory(
        expression: expression,
        result: result,
        timestamp: DateTime.now(),
      ),
    );

    // Salva assincronamente, sem bloquear
    _storageService.saveHistory(_history).then((saveResult) {
      if (saveResult.isFailure) {
        logger.warning(
          'Falha ao salvar histórico: ${saveResult.errorFullMessage}',
          tag: 'CalculatorController',
        );
      }
    });
  }

  void useHistoryResult(CalculationHistory item) {
    _displayText = item.result;
    _firstOperand = '';
    _secondOperand = '';
    _currentOperation = null;
    _shouldResetDisplay = true;
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _storageService.clearHistory().then((result) {
      if (result.isFailure) {
        logger.warning(
          'Falha ao limpar histórico: ${result.errorFullMessage}',
          tag: 'CalculatorController',
        );
      }
    });
    notifyListeners();
  }

  /// Verifica se o display está mostrando um erro
  bool _isErrorState() {
    return _displayText == AppConstants.divisionByZeroError ||
        _displayText == AppConstants.infinityError ||
        _displayText == AppConstants.nanError ||
        _displayText == AppConstants.overflowError ||
        _displayText == AppConstants.genericError;
  }

  /// Define o display para mostrar erro e limpa o estado
  void _setErrorDisplay(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.divisionByZero:
        _displayText = AppConstants.divisionByZeroError;
        break;
      case ErrorType.infinity:
        _displayText = AppConstants.infinityError;
        break;
      case ErrorType.notANumber:
        _displayText = AppConstants.nanError;
        break;
      case ErrorType.overflow:
        _displayText = AppConstants.overflowError;
        break;
      default:
        _displayText = AppConstants.genericError;
    }

    _firstOperand = '';
    _secondOperand = '';
    _currentOperation = null;
    _shouldResetDisplay = true;
  }
}
