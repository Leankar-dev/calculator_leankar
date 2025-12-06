import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:flutter/material.dart';

class CalculatorController extends ChangeNotifier {
  String _displayText = '0';
  String _firstOperand = '';
  String _secondOperand = '';
  OperationsType? _currentOperation;
  bool _shouldResetDisplay = false;

  String get displayText => _displayText;

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
    _displayText = '0';
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
      _displayText = '0';
    }
    notifyListeners();
  }

  void calculatePercentage() {
    double value = double.tryParse(_displayText.replaceAll(',', '.')) ?? 0;
    if (_firstOperand.isNotEmpty && _currentOperation != null) {
      double firstValue =
          double.tryParse(_firstOperand.replaceAll(',', '.')) ?? 0;
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
    } else if (_displayText == '0' && digit != ',') {
      _displayText = digit;
    } else {
      _displayText += digit;
    }
    notifyListeners();
  }

  void appendDecimal() {
    if (_shouldResetDisplay) {
      _displayText = '0,';
      _shouldResetDisplay = false;
    } else if (!_displayText.contains(',')) {
      _displayText += ',';
    }
    notifyListeners();
  }

  void _calculatePendingOperation() {
    if (_currentOperation == null || _firstOperand.isEmpty) return;

    _secondOperand = _displayText;
    double first = double.tryParse(_firstOperand.replaceAll(',', '.')) ?? 0;
    double second = double.tryParse(_secondOperand.replaceAll(',', '.')) ?? 0;
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
          _displayText = 'Erro';
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
      String formatted = value.toStringAsFixed(8);
      formatted = formatted.replaceAll('.', ',');
      while (formatted.contains(',') && formatted.endsWith('0')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
      if (formatted.endsWith(',')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
      return formatted;
    }
  }

  void calculateResult() {
    if (_currentOperation == null || _firstOperand.isEmpty) return;

    _calculatePendingOperation();
    _firstOperand = _displayText;
    _secondOperand = '';
    _currentOperation = null;
    _shouldResetDisplay = true;
    notifyListeners();
  }
}
