import 'dart:async';

import 'package:calculator_05122025/controllers/calculator_state.dart';
import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/services/error_handler.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/services/storage_service.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/utils/enums/paste_result.dart';
import 'package:calculator_05122025/utils/number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorController extends ChangeNotifier {
  final StorageService _storageService;
  final ErrorHandler _errorHandler;
  final LoggerService _logger;

  CalculatorState _state = CalculatorState.initial();
  final StreamController<void> _inputRejectedController =
      StreamController<void>.broadcast();

  CalculatorController({
    StorageService? storageService,
    ErrorHandler? errorHandler,
    LoggerService? logger,
  }) : _storageService = storageService ?? StorageService(),
       _errorHandler = errorHandler ?? ErrorHandler.instance,
       _logger = logger ?? LoggerService.instance;

  CalculatorState get state => _state;
  String get displayText => _state.displayText;
  List<CalculationHistory> get history => List.unmodifiable(_state.history);
  bool get isLoading => _state.isLoading;
  bool get hasError => _state.hasError;
  Stream<void> get inputRejected => _inputRejectedController.stream;

  String get expressionDisplay {
    if (_state.firstOperand.isEmpty || _state.currentOperation == null) {
      return '';
    }
    return '${_state.firstOperand} ${_state.currentOperation!.symbol}';
  }

  Future<void> loadHistory() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _storageService.loadHistory();

    result.fold(
      onSuccess: (loadedHistory) {
        _state = _state.copyWith(
          history: loadedHistory,
          hasError: false,
          isLoading: false,
        );
      },
      onFailure: (error, details) {
        _logger.warning(
          'Falha ao carregar histórico: ${error.fullMessage}',
          tag: 'CalculatorController',
        );
        _state = _state.copyWith(
          history: [],
          hasError: true,
          isLoading: false,
        );
      },
    );

    notifyListeners();
  }

  void setOperationType(OperationsType operation) {
    if (_isErrorState()) {
      clearDisplay();
    }

    if (_state.firstOperand.isEmpty) {
      _state = _state.copyWith(firstOperand: _state.displayText);
    } else if (!_state.shouldResetDisplay && _state.currentOperation != null) {
      _calculatePendingOperation();
      if (_isErrorState()) return;
      _state = _state.copyWith(firstOperand: _state.displayText);
    }

    _state = _state.copyWith(
      currentOperation: operation,
      shouldResetDisplay: true,
    );
    notifyListeners();
  }

  void clearDisplay() {
    _state = _state.copyWith(
      hasError: false,
      displayText: AppStrings.initialDisplayValue,
      firstOperand: '',
      secondOperand: '',
      clearOperation: true,
      shouldResetDisplay: false,
      clearErrorType: true,
    );
    notifyListeners();
  }

  void backspace() {
    if (_isErrorState()) {
      clearDisplay();
      return;
    }

    if (_state.displayText.length > 1) {
      _state = _state.copyWith(
        displayText: _state.displayText.substring(
          0,
          _state.displayText.length - 1,
        ),
      );
    } else {
      _state = _state.copyWith(displayText: AppStrings.initialDisplayValue);
    }
    notifyListeners();
  }

  void calculatePercentage() {
    if (_isErrorState()) return;

    final parseResult = _errorHandler.parseDouble(
      _state.displayText,
      decimalSeparator: AppStrings.decimalSeparator,
    );

    if (parseResult.isFailure) {
      _setErrorDisplay(parseResult.error!);
      return;
    }

    double value = parseResult.value;

    if (_state.firstOperand.isNotEmpty && _state.currentOperation != null) {
      final firstResult = _errorHandler.parseDouble(
        _state.firstOperand,
        decimalSeparator: AppStrings.decimalSeparator,
      );

      if (firstResult.isFailure) {
        _setErrorDisplay(firstResult.error!);
        return;
      }

      value = (firstResult.value * value) / 100;
    } else {
      value = value / 100;
    }

    final validationResult = _errorHandler.validateCalculationResult(value);
    if (validationResult.isFailure) {
      _setErrorDisplay(validationResult.error!);
      return;
    }

    _state = _state.copyWith(displayText: _formatResult(value));

    _logger.logCalculation(
      operation: '%',
      firstOperand: _state.firstOperand.isEmpty
          ? _state.displayText
          : _state.firstOperand,
      secondOperand: parseResult.value.toString(),
      result: _state.displayText,
    );

    notifyListeners();
  }

  void appendNumber(String digit) {
    if (_isErrorState()) {
      _state = _state.copyWith(
        hasError: false,
        displayText: digit,
        shouldResetDisplay: false,
      );
      notifyListeners();
      return;
    }

    if (!_state.shouldResetDisplay &&
        !_errorHandler.isValidNumberInput(
          _state.displayText,
          digit,
          decimalSeparator: AppStrings.decimalSeparator,
        )) {
      _logger.debug('Entrada rejeitada: número muito longo', tag: 'Input');
      _inputRejectedController.add(null);
      return;
    }

    if (_state.shouldResetDisplay) {
      _state = _state.copyWith(displayText: digit, shouldResetDisplay: false);
    } else if (_state.displayText == AppStrings.initialDisplayValue &&
        digit != AppStrings.decimalSeparator) {
      _state = _state.copyWith(displayText: digit);
    } else {
      _state = _state.copyWith(displayText: _state.displayText + digit);
    }
    notifyListeners();
  }

  void appendDecimal() {
    if (_isErrorState()) {
      _state = _state.copyWith(
        hasError: false,
        displayText:
            '${AppStrings.initialDisplayValue}${AppStrings.decimalSeparator}',
        shouldResetDisplay: false,
      );
      notifyListeners();
      return;
    }

    if (_state.shouldResetDisplay) {
      _state = _state.copyWith(
        displayText:
            '${AppStrings.initialDisplayValue}${AppStrings.decimalSeparator}',
        shouldResetDisplay: false,
      );
    } else if (!_state.displayText.contains(AppStrings.decimalSeparator)) {
      _state = _state.copyWith(
        displayText: _state.displayText + AppStrings.decimalSeparator,
      );
    }
    notifyListeners();
  }

  void _calculatePendingOperation() {
    if (_state.currentOperation == null || _state.firstOperand.isEmpty) return;

    final secondOperand = _state.displayText;
    _state = _state.copyWith(secondOperand: secondOperand);

    final firstResult = _errorHandler.parseDouble(
      _state.firstOperand,
      decimalSeparator: AppStrings.decimalSeparator,
    );

    if (firstResult.isFailure) {
      _setErrorDisplay(firstResult.error!);
      return;
    }

    final secondResult = _errorHandler.parseDouble(
      secondOperand,
      decimalSeparator: AppStrings.decimalSeparator,
    );

    if (secondResult.isFailure) {
      _setErrorDisplay(secondResult.error!);
      return;
    }

    final first = firstResult.value;
    final second = secondResult.value;
    double result = 0;

    switch (_state.currentOperation!) {
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
        final divResult = _errorHandler.safeDivide(first, second);
        if (divResult.isFailure) {
          _setErrorDisplay(divResult.error!);
          return;
        }
        result = divResult.value;
        break;
    }

    final validationResult = _errorHandler.validateCalculationResult(result);
    if (validationResult.isFailure) {
      _setErrorDisplay(validationResult.error!);
      return;
    }

    final formatted = _formatResult(result);
    _state = _state.copyWith(displayText: formatted);

    _logger.logCalculation(
      operation: _state.currentOperation!.symbol,
      firstOperand: _state.firstOperand,
      secondOperand: secondOperand,
      result: formatted,
    );
  }

  String _formatResult(double value) {
    return NumberFormatter.format(value);
  }

  Future<void> calculateResult() async {
    if (_state.currentOperation == null || _state.firstOperand.isEmpty) return;
    if (_isErrorState()) return;

    final expression =
        '${_state.firstOperand} ${_state.currentOperation!.symbol} ${_state.displayText}';
    _calculatePendingOperation();

    if (!_isErrorState()) {
      _addToHistory(expression, _state.displayText);
    }

    _state = _state.copyWith(
      firstOperand: '',
      secondOperand: '',
      clearOperation: true,
      shouldResetDisplay: true,
    );
    notifyListeners();

    await _persistHistory();
  }

  void _addToHistory(String expression, String result) {
    final newEntry = CalculationHistory(
      expression: expression,
      result: result,
      timestamp: DateTime.now().toUtc(),
    );
    final updated = [newEntry, ..._state.history];
    final trimmed = updated.length > AppSizes.maxHistoryItems
        ? updated.sublist(0, AppSizes.maxHistoryItems)
        : updated;
    _state = _state.copyWith(history: trimmed);
  }

  Future<void> _persistHistory() async {
    final saveResult = await _storageService.saveHistory(_state.history);
    saveResult.fold(
      onSuccess: (_) =>
          _logger.debug('Histórico salvo', tag: 'CalculatorController'),
      onFailure: (e, d) => _logger.warning(
        'Falha ao salvar histórico: ${e.fullMessage}',
        tag: 'CalculatorController',
      ),
    );
  }

  void useHistoryResult(CalculationHistory item) {
    final parsed = NumberFormatter.parse(item.result);
    _state = _state.copyWith(
      hasError: false,
      displayText: parsed != null
          ? NumberFormatter.format(parsed)
          : item.result,
      firstOperand: '',
      secondOperand: '',
      clearOperation: true,
      shouldResetDisplay: true,
    );
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _state = _state.copyWith(history: []);
    notifyListeners();

    final result = await _storageService.clearHistory();
    if (result.isFailure) {
      _logger.warning(
        'Falha ao limpar histórico: ${result.errorFullMessage}',
        tag: 'CalculatorController',
      );
    }
  }

  Future<bool> copyToClipboard() async {
    if (_isErrorState()) {
      _logger.debug('Tentativa de copiar em estado de erro', tag: 'Clipboard');
      return false;
    }

    try {
      await Clipboard.setData(ClipboardData(text: _state.displayText));
      _logger.info('Valor copiado: ${_state.displayText}', tag: 'Clipboard');
      return true;
    } catch (e) {
      _logger.warning('Falha ao copiar: $e', tag: 'Clipboard');
      return false;
    }
  }

  Future<PasteResult> pasteFromClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text == null || data!.text!.isEmpty) {
        _logger.debug('Área de transferência vazia', tag: 'Clipboard');
        return PasteResult.emptyClipboard;
      }

      final text = data.text!.trim();
      final parsed = NumberFormatter.parse(text);

      if (parsed == null) {
        _logger.debug('Valor inválido para colar: $text', tag: 'Clipboard');
        return PasteResult.invalidFormat;
      }

      final validationResult = _errorHandler.validateCalculationResult(parsed);
      if (validationResult.isFailure) {
        _logger.debug('Valor fora dos limites: $text', tag: 'Clipboard');
        return PasteResult.outOfRange;
      }

      _state = _state.copyWith(
        displayText: NumberFormatter.format(parsed),
        shouldResetDisplay: true,
      );
      _logger.info('Valor colado: ${_state.displayText}', tag: 'Clipboard');
      notifyListeners();
      return PasteResult.success;
    } catch (e) {
      _logger.warning('Falha ao colar: $e', tag: 'Clipboard');
      return PasteResult.invalidFormat;
    }
  }

  @override
  void dispose() {
    _inputRejectedController.close();
    super.dispose();
  }

  bool _isErrorState() => _state.hasError;

  void _setErrorDisplay(ErrorType errorType) {
    _state = _state.copyWith(
      hasError: true,
      displayText: AppStrings.initialDisplayValue,
      firstOperand: '',
      secondOperand: '',
      clearOperation: true,
      shouldResetDisplay: true,
      errorType: errorType,
    );
  }
}
