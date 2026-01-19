import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/services/storage_service.dart';
import 'package:calculator_05122025/utils/constants.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:flutter/material.dart';

class CalculatorController extends ChangeNotifier {
  final StorageService _storageService;

  String _displayText = AppConstants.initialDisplayValue;
  String _firstOperand = '';
  String _secondOperand = '';
  OperationsType? _currentOperation;
  bool _shouldResetDisplay = false;
  List<CalculationHistory> _history = [];

  CalculatorController({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  String get displayText => _displayText;
  List<CalculationHistory> get history => List.unmodifiable(_history);

  Future<void> loadHistory() async {
    _history = await _storageService.loadHistory();
    notifyListeners();
  }

  String get expressionDisplay {
    if (_firstOperand.isEmpty || _currentOperation == null) {
      return '';
    }
    return '$_firstOperand ${_currentOperation!.symbol}';
  }

  void setOperationType(OperationsType operation) {
    if (_firstOperand.isEmpty) {
      _firstOperand = _displayText;
    } else if (!_shouldResetDisplay && _currentOperation != null) {
      _calculatePendingOperation();
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
    if (_displayText.length > 1) {
      _displayText = _displayText.substring(0, _displayText.length - 1);
    } else {
      _displayText = AppConstants.initialDisplayValue;
    }
    notifyListeners();
  }

  void calculatePercentage() {
    double value =
        double.tryParse(_displayText.replaceAll(AppConstants.decimalSeparator, '.')) ?? 0;
    if (_firstOperand.isNotEmpty && _currentOperation != null) {
      double firstValue =
          double.tryParse(_firstOperand.replaceAll(AppConstants.decimalSeparator, '.')) ?? 0;
      value = (firstValue * value) / 100;
    } else {
      value = value / 100;
    }
    _displayText = _formatResult(value);
    notifyListeners();
  }

  void appendNumber(String digit) {
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
    if (_shouldResetDisplay) {
      _displayText = '${AppConstants.initialDisplayValue}${AppConstants.decimalSeparator}';
      _shouldResetDisplay = false;
    } else if (!_displayText.contains(AppConstants.decimalSeparator)) {
      _displayText += AppConstants.decimalSeparator;
    }
    notifyListeners();
  }

  void _calculatePendingOperation() {
    if (_currentOperation == null || _firstOperand.isEmpty) return;

    _secondOperand = _displayText;
    double first =
        double.tryParse(_firstOperand.replaceAll(AppConstants.decimalSeparator, '.')) ?? 0;
    double second =
        double.tryParse(_secondOperand.replaceAll(AppConstants.decimalSeparator, '.')) ?? 0;
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
        if (second != 0) {
          result = first / second;
        } else {
          _displayText = AppConstants.divisionByZeroError;
          _firstOperand = '';
          _secondOperand = '';
          _currentOperation = null;
          _shouldResetDisplay = true;
          return;
        }
        break;
    }

    _displayText = _formatResult(result);
  }

  String _formatResult(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    } else {
      String formatted = value.toStringAsFixed(AppConstants.maxDecimalPlaces);
      formatted = formatted.replaceAll('.', AppConstants.decimalSeparator);
      while (formatted.contains(AppConstants.decimalSeparator) &&
          formatted.endsWith(AppConstants.initialDisplayValue)) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
      if (formatted.endsWith(AppConstants.decimalSeparator)) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
      return formatted;
    }
  }

  void calculateResult() {
    if (_currentOperation == null || _firstOperand.isEmpty) return;

    final expression =
        '$_firstOperand ${_currentOperation!.symbol} $_displayText';
    _calculatePendingOperation();

    if (_displayText != AppConstants.divisionByZeroError) {
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
    _storageService.saveHistory(_history);
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
    _storageService.clearHistory();
    notifyListeners();
  }
}
