import 'package:calculator_05122025/controllers/scientific_calculator_state.dart';
import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/services/expression_evaluator_service.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/services/storage_service.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:calculator_05122025/utils/number_formatter.dart';
import 'package:flutter/foundation.dart';

class ScientificCalculatorController extends ChangeNotifier {
  final ExpressionEvaluatorService _evaluator;
  final LoggerService _logger;
  final StorageService _storageService;

  static const String _powerSymbol = '^';
  static const String _permutationSymbol = 'P';

  ScientificCalculatorState _state = ScientificCalculatorState.initial();

  ScientificCalculatorController({
    ExpressionEvaluatorService? evaluator,
    LoggerService? logger,
    StorageService? storageService,
  }) : _evaluator = evaluator ?? ExpressionEvaluatorService(),
       _logger = logger ?? LoggerService.instance,
       _storageService = storageService ?? StorageService();

  ScientificCalculatorState get state => _state;

  List<CalculationHistory> get history => List.unmodifiable(_state.history);

  String get expressionDisplay {
    if (_state.tokens.isEmpty) {
      return '';
    }
    return _serializeExpression(_state.tokens, _state.currentInput);
  }

  String get resultDisplay => _state.resultDisplay;

  bool get isShiftActive => _state.isShiftActive;

  bool get isShiftLocked => _state.isShiftLocked;

  AngleMode get angleMode => _state.angleMode;

  bool get hasError => _state.hasError;

  void appendNumber(String digit) {
    if (_state.hasError) {
      _resetCurrentExpression();
    }
    final updatedInput = _state.currentInput.isEmpty
        ? digit
        : _state.currentInput + digit;
    _state = _state.copyWith(currentInput: updatedInput);
    notifyListeners();
    _previewResult();
  }

  void appendDecimal() {
    if (_state.hasError) {
      _resetCurrentExpression();
    }
    if (_state.currentInput.contains(AppStrings.decimalSeparator)) {
      return;
    }
    final base = _state.currentInput.isEmpty
        ? AppStrings.initialDisplayValue
        : _state.currentInput;
    _state = _state.copyWith(
      currentInput: '$base${AppStrings.decimalSeparator}',
    );
    notifyListeners();
    _previewResult();
  }

  void calculatePercentage() {
    if (_state.hasError || _state.currentInput.isEmpty) {
      return;
    }
    final value = NumberFormatter.parse(_state.currentInput);
    if (value == null) {
      return;
    }
    _state = _state.copyWith(
      currentInput: _toCanonicalNumberString(value / 100),
    );
    notifyListeners();
    _previewResult();
  }

  void openParen() {
    if (_state.hasError) {
      _resetCurrentExpression();
    }
    _commitPendingOperand();
    _state = _state.copyWith(
      tokens: [
        ..._state.tokens,
        const ExpressionToken(type: TokenType.openParen, value: '('),
      ],
    );
    notifyListeners();
    _previewResult();
  }

  void closeParen() {
    if (_state.hasError) {
      _resetCurrentExpression();
    }
    _commitPendingOperand();
    _state = _state.copyWith(
      tokens: [
        ..._state.tokens,
        const ExpressionToken(type: TokenType.closeParen, value: ')'),
      ],
    );
    notifyListeners();
    _previewResult();
  }

  void appendFunction(ScientificFunctionType function) {
    if (_state.hasError) {
      _resetCurrentExpression();
    }

    switch (function) {
      case ScientificFunctionType.sin:
        _appendPrefixFunction('sin');
        break;
      case ScientificFunctionType.cos:
        _appendPrefixFunction('cos');
        break;
      case ScientificFunctionType.tan:
        _appendPrefixFunction('tan');
        break;
      case ScientificFunctionType.asin:
        _appendPrefixFunction('asin');
        break;
      case ScientificFunctionType.acos:
        _appendPrefixFunction('acos');
        break;
      case ScientificFunctionType.atan:
        _appendPrefixFunction('atan');
        break;
      case ScientificFunctionType.log:
        _appendPrefixFunction('log');
        break;
      case ScientificFunctionType.ln:
        _appendPrefixFunction('ln');
        break;
      case ScientificFunctionType.sqrt:
        _appendPrefixFunction('√');
        break;
      case ScientificFunctionType.cbrt:
        _appendPrefixFunction('³√');
        break;
      case ScientificFunctionType.absoluteValue:
        _appendPrefixFunction('abs');
        break;
      case ScientificFunctionType.square:
        _appendPostfixOperator('²');
        break;
      case ScientificFunctionType.cube:
        _appendPostfixOperator('³');
        break;
      case ScientificFunctionType.reciprocal:
        _appendPostfixOperator('⁻¹');
        break;
      case ScientificFunctionType.factorial:
        _appendPostfixOperator('!');
        break;
      case ScientificFunctionType.exp10:
        _appendPowerSugar(
          const ExpressionToken(type: TokenType.number, value: '10'),
        );
        break;
      case ScientificFunctionType.expE:
        _appendPowerSugar(
          const ExpressionToken(type: TokenType.constant, value: 'e'),
        );
        break;
      case ScientificFunctionType.power:
      case ScientificFunctionType.nthRoot:
      case ScientificFunctionType.permutation:
      case ScientificFunctionType.combination:
        return;
    }

    _resetShiftIfNotLocked();
    notifyListeners();
    _previewResult();
  }

  void appendConstant(String constant) {
    if (_state.hasError) {
      _resetCurrentExpression();
    }
    _commitPendingOperand();
    _state = _state.copyWith(
      tokens: [
        ..._state.tokens,
        ExpressionToken(type: TokenType.constant, value: constant),
      ],
    );
    notifyListeners();
    _previewResult();
  }

  void setBinaryOperator(String operator) {
    if (_state.hasError) {
      _resetCurrentExpression();
    }

    if (operator == AppStrings.subtractionSymbol && _expectsNewOperand()) {
      _state = _state.copyWith(
        tokens: [
          ..._state.tokens,
          const ExpressionToken(type: TokenType.unaryMinus, value: '-'),
        ],
      );
    } else {
      _commitPendingOperand();
      _state = _state.copyWith(
        tokens: [
          ..._state.tokens,
          ExpressionToken(type: TokenType.binaryOperator, value: operator),
        ],
      );
    }

    if (operator == _powerSymbol || operator == _permutationSymbol) {
      _resetShiftIfNotLocked();
    }

    notifyListeners();
    _previewResult();
  }

  Future<void> calculateResult() async {
    if (_state.hasError) {
      return;
    }

    _commitPendingOperand();

    if (_state.tokens.isEmpty && _state.currentInput.isEmpty) {
      return;
    }

    final expression = _serializeExpression(
      _state.tokens,
      _state.currentInput,
    );

    var shouldPersistHistory = false;

    try {
      final result = _evaluator.evaluate(expression, _state.angleMode);
      final formatted = NumberFormatter.format(result);
      _state = _state.copyWith(
        tokens: const [],
        currentInput: _toCanonicalNumberString(result),
        resultDisplay: formatted,
      );
      _addToHistory(expression, formatted);
      _logger.debug(
        'Cálculo científico: $expression = $formatted',
        tag: 'ScientificCalculatorController',
      );
      shouldPersistHistory = true;
    } on ScientificCalculationException catch (e) {
      _state = _state.copyWith(
        hasError: true,
        errorType: e.errorType,
        tokens: const [],
        currentInput: '',
        resultDisplay: AppStrings.initialDisplayValue,
      );
      _logger.warning(
        'Erro no cálculo científico "$expression": ${e.errorType}',
        tag: 'ScientificCalculatorController',
      );
    }

    notifyListeners();

    if (shouldPersistHistory) {
      await _persistHistory();
    }
  }

  void toggleShift() {
    if (_state.isShiftLocked) {
      _state = _state.copyWith(isShiftActive: false, isShiftLocked: false);
    } else {
      _state = _state.copyWith(isShiftActive: !_state.isShiftActive);
    }
    notifyListeners();
  }

  void lockShift() {
    _state = _state.copyWith(isShiftActive: true, isShiftLocked: true);
    notifyListeners();
  }

  void toggleAngleMode() {
    _state = _state.copyWith(
      angleMode: _state.angleMode == AngleMode.deg
          ? AngleMode.rad
          : AngleMode.deg,
    );
    notifyListeners();
    _previewResult();
  }

  void backspace() {
    if (_state.hasError) {
      _resetCurrentExpression();
      notifyListeners();
      return;
    }

    if (_state.currentInput.isNotEmpty) {
      final trimmed = _state.currentInput.substring(
        0,
        _state.currentInput.length - 1,
      );
      _state = _state.copyWith(currentInput: trimmed);
      notifyListeners();
      _previewResult();
      return;
    }

    if (_state.tokens.isEmpty) {
      return;
    }

    final tokens = List<ExpressionToken>.from(_state.tokens);
    final removedLast = tokens.removeLast();
    if (removedLast.type == TokenType.openParen &&
        tokens.isNotEmpty &&
        tokens.last.type == TokenType.unaryFunction) {
      tokens.removeLast();
    }
    _state = _state.copyWith(tokens: tokens);
    notifyListeners();
    _previewResult();
  }

  void clearAll() {
    _resetCurrentExpression();
    notifyListeners();
  }

  void memoryAdd() {
    final value = _lastValidPreviewValue();
    if (value == null) {
      return;
    }
    _state = _state.copyWith(
      memoryValue: _state.memoryValue + value,
      hasMemoryValue: true,
    );
    notifyListeners();
  }

  void memorySubtract() {
    final value = _lastValidPreviewValue();
    if (value == null) {
      return;
    }
    _state = _state.copyWith(
      memoryValue: _state.memoryValue - value,
      hasMemoryValue: true,
    );
    notifyListeners();
  }

  void memoryRecall() {
    if (!_state.hasMemoryValue) {
      return;
    }
    if (_state.hasError) {
      _resetCurrentExpression();
    }
    _commitPendingOperand();
    _state = _state.copyWith(
      tokens: [
        ..._state.tokens,
        ExpressionToken(
          type: TokenType.number,
          value: _toCanonicalNumberString(_state.memoryValue),
        ),
      ],
    );
    notifyListeners();
    _previewResult();
  }

  void memoryClear() {
    _state = _state.copyWith(memoryValue: 0, hasMemoryValue: false);
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final result = await _storageService.loadHistory(
      key: AppStrings.prefScientificHistoryKey,
    );

    result.fold(
      onSuccess: (loadedHistory) {
        _state = _state.copyWith(history: loadedHistory);
      },
      onFailure: (error, details) {
        _logger.warning(
          'Falha ao carregar histórico científico: ${error.fullMessage}',
          tag: 'ScientificCalculatorController',
        );
      },
    );

    notifyListeners();
  }

  void useHistoryResult(CalculationHistory item) {
    final parsed = NumberFormatter.parse(item.result);
    _state = _state.copyWith(
      tokens: const [],
      currentInput: parsed != null
          ? _toCanonicalNumberString(parsed)
          : item.result,
      resultDisplay: item.result,
      hasError: false,
      clearErrorType: true,
    );
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _state = _state.copyWith(history: const []);
    notifyListeners();

    final result = await _storageService.clearHistory(
      key: AppStrings.prefScientificHistoryKey,
    );
    if (result.isFailure) {
      _logger.warning(
        'Falha ao limpar histórico científico: ${result.errorFullMessage}',
        tag: 'ScientificCalculatorController',
      );
    }
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
    final saveResult = await _storageService.saveHistory(
      _state.history,
      key: AppStrings.prefScientificHistoryKey,
    );
    saveResult.fold(
      onSuccess: (_) => _logger.debug(
        'Histórico científico salvo',
        tag: 'ScientificCalculatorController',
      ),
      onFailure: (error, details) => _logger.warning(
        'Falha ao salvar histórico científico: ${error.fullMessage}',
        tag: 'ScientificCalculatorController',
      ),
    );
  }

  bool _expectsNewOperand() {
    if (_state.currentInput.isNotEmpty) {
      return false;
    }
    if (_state.tokens.isEmpty) {
      return true;
    }
    final last = _state.tokens.last;
    return last.type == TokenType.binaryOperator ||
        last.type == TokenType.openParen ||
        last.type == TokenType.unaryMinus;
  }

  void _commitPendingOperand() {
    if (_state.currentInput.isEmpty) {
      return;
    }
    _state = _state.copyWith(
      tokens: [
        ..._state.tokens,
        ExpressionToken(type: TokenType.number, value: _state.currentInput),
      ],
      currentInput: '',
    );
  }

  String _serializeExpression(
    List<ExpressionToken> tokens,
    String currentInput,
  ) {
    final buffer = StringBuffer();
    ExpressionToken? previous;

    for (final token in tokens) {
      if (token.type == TokenType.binaryOperator) {
        buffer.write(' ${token.value} ');
      } else {
        if (previous != null && _closesValue(previous) && _opensValue(token)) {
          buffer.write(' × ');
        }
        buffer.write(token.value);
      }
      previous = token;
    }

    if (currentInput.isNotEmpty) {
      if (previous != null && _closesValue(previous)) {
        buffer.write(' × ');
      }
      buffer.write(currentInput);
    }

    return buffer.toString().trim();
  }

  bool _closesValue(ExpressionToken token) {
    return token.type == TokenType.number ||
        token.type == TokenType.closeParen ||
        token.type == TokenType.postfixOperator ||
        token.type == TokenType.constant;
  }

  bool _opensValue(ExpressionToken token) {
    return token.type == TokenType.number ||
        token.type == TokenType.constant ||
        token.type == TokenType.unaryFunction ||
        token.type == TokenType.openParen;
  }

  void _previewResult() {
    if (_state.tokens.isEmpty && _state.currentInput.isEmpty) {
      if (_state.resultDisplay != AppStrings.initialDisplayValue) {
        _state = _state.copyWith(
          resultDisplay: AppStrings.initialDisplayValue,
        );
        notifyListeners();
      }
      return;
    }
    if (_shouldSkipPreview()) {
      return;
    }

    final rawExpression = _serializeExpression(
      _state.tokens,
      _state.currentInput,
    );
    final expression = _withAutoClosedParens(rawExpression);

    try {
      final result = _evaluator.evaluate(expression, _state.angleMode);
      _state = _state.copyWith(resultDisplay: NumberFormatter.format(result));
      notifyListeners();
    } on ScientificCalculationException {
      return;
    }
  }

  bool _shouldSkipPreview() {
    if (_state.currentInput.isNotEmpty) {
      return false;
    }
    if (_state.tokens.isEmpty) {
      return false;
    }
    final last = _state.tokens.last;
    return last.type == TokenType.openParen ||
        last.type == TokenType.binaryOperator ||
        last.type == TokenType.unaryMinus;
  }

  String _withAutoClosedParens(String expression) {
    var openCount = 0;
    for (final token in _state.tokens) {
      if (token.type == TokenType.openParen) {
        openCount++;
      } else if (token.type == TokenType.closeParen) {
        openCount--;
      }
    }
    if (openCount <= 0) {
      return expression;
    }
    return expression + List.filled(openCount, ')').join();
  }

  void _appendPrefixFunction(String name) {
    _commitPendingOperand();
    _state = _state.copyWith(
      tokens: [
        ..._state.tokens,
        ExpressionToken(type: TokenType.unaryFunction, value: name),
        const ExpressionToken(type: TokenType.openParen, value: '('),
      ],
    );
  }

  void _appendPostfixOperator(String symbol) {
    _commitPendingOperand();
    _state = _state.copyWith(
      tokens: [
        ..._state.tokens,
        ExpressionToken(type: TokenType.postfixOperator, value: symbol),
      ],
    );
  }

  void _appendPowerSugar(ExpressionToken base) {
    _commitPendingOperand();
    _state = _state.copyWith(
      tokens: [
        ..._state.tokens,
        base,
        const ExpressionToken(type: TokenType.binaryOperator, value: '^'),
      ],
    );
  }

  void _resetShiftIfNotLocked() {
    if (_state.isShiftActive && !_state.isShiftLocked) {
      _state = _state.copyWith(isShiftActive: false);
    }
  }

  void _resetCurrentExpression() {
    _state = _state.copyWith(
      tokens: const [],
      currentInput: '',
      resultDisplay: AppStrings.initialDisplayValue,
      hasError: false,
      clearErrorType: true,
    );
  }

  double? _lastValidPreviewValue() {
    if (_state.hasError) {
      return null;
    }
    if (_state.tokens.isEmpty && _state.currentInput.isEmpty) {
      return null;
    }
    return NumberFormatter.parse(_state.resultDisplay);
  }

  String _toCanonicalNumberString(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString().replaceAll('.', AppStrings.decimalSeparator);
  }
}
