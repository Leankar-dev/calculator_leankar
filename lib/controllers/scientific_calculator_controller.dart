import 'package:calculator_05122025/controllers/scientific_calculator_state.dart';
import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/services/expression_evaluator_service.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/services/storage_service.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/paste_result.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_insertion.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/utils/enums/token_type.dart';
import 'package:calculator_05122025/utils/exceptions/scientific_calculation_exception.dart';
import 'package:calculator_05122025/utils/expression_serializer.dart';
import 'package:calculator_05122025/utils/extensions/calculation_history_list_extension.dart';
import 'package:calculator_05122025/utils/extensions/expression_token_extension.dart';
import 'package:calculator_05122025/utils/number_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScientificCalculatorController extends ChangeNotifier {
  final ExpressionEvaluatorService _evaluator;
  final LoggerService _logger;
  final StorageService _storageService;

  static const String _powerSymbol = '^';
  static const String _permutationSymbol = 'P';
  static const String _logTag = 'ScientificCalculatorController';

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
    return ExpressionSerializer.serialize(_state.tokens, _state.currentInput);
  }

  String get resultDisplay => _state.resultDisplay;

  bool get isShiftActive => _state.isShiftActive;

  bool get isShiftLocked => _state.isShiftLocked;

  AngleMode get angleMode => _state.angleMode;

  bool get hasError => _state.hasError;

  void appendNumber(String digit) {
    _resetExpressionIfInError();
    final base = _state.shouldResetCurrentInput ? '' : _state.currentInput;
    _state = _state.copyWith(
      currentInput: base + digit,
      shouldResetCurrentInput: false,
    );
    _notifyWithPreview();
  }

  void appendDecimal() {
    _resetExpressionIfInError();
    if (_state.shouldResetCurrentInput) {
      _state = _state.copyWith(
        currentInput:
            '${AppStrings.initialDisplayValue}${AppStrings.decimalSeparator}',
        shouldResetCurrentInput: false,
      );
      _notifyWithPreview();
      return;
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
    _notifyWithPreview();
  }

  void calculatePercentage() {
    _resetExpressionIfInError();
    if (_state.currentInput.isEmpty) {
      return;
    }
    final value = NumberFormatter.parse(_state.currentInput);
    if (value == null) {
      return;
    }
    _state = _state.copyWith(
      currentInput: NumberFormatter.toCanonicalString(_percentageOf(value)),
      shouldResetCurrentInput: true,
    );
    _notifyWithPreview();
  }

  void openParen() {
    _resetExpressionIfInError();
    _commitPendingOperand();
    _appendToken(const ExpressionToken(type: TokenType.openParen, value: '('));
    _notifyWithPreview();
  }

  void closeParen() {
    _resetExpressionIfInError();
    _commitPendingOperand();
    _appendToken(const ExpressionToken(type: TokenType.closeParen, value: ')'));
    _notifyWithPreview();
  }

  void appendFunction(ScientificFunctionType function) {
    _resetExpressionIfInError();

    switch (function.insertion) {
      case ScientificFunctionInsertion.prefixFunction:
        _appendPrefixFunction(function.lexeme);
      case ScientificFunctionInsertion.postfixOperator:
        _appendPostfixOperator(function.lexeme);
      case ScientificFunctionInsertion.powerOfNumber:
        _appendPowerSugar(
          ExpressionToken(type: TokenType.number, value: function.lexeme),
        );
      case ScientificFunctionInsertion.powerOfConstant:
        _appendPowerSugar(
          ExpressionToken(type: TokenType.constant, value: function.lexeme),
        );
      case ScientificFunctionInsertion.notInsertable:
        return;
    }

    _resetShiftIfNotLocked();
    _notifyWithPreview();
  }

  void appendConstant(String constant) {
    _resetExpressionIfInError();
    _commitPendingOperand();
    _appendToken(ExpressionToken(type: TokenType.constant, value: constant));
    _notifyWithPreview();
  }

  void setBinaryOperator(String operator) {
    _resetExpressionIfInError();

    if (operator == AppStrings.subtractionSymbol && _expectsNewOperand()) {
      _appendToken(
        const ExpressionToken(type: TokenType.unaryMinus, value: '-'),
      );
    } else {
      _commitPendingOperand();
      _appendToken(
        ExpressionToken(type: TokenType.binaryOperator, value: operator),
      );
    }

    if (operator == _powerSymbol || operator == _permutationSymbol) {
      _resetShiftIfNotLocked();
    }

    _notifyWithPreview();
  }

  Future<void> calculateResult() async {
    if (_state.hasError) {
      return;
    }

    _commitPendingOperand();

    if (_state.tokens.isEmpty && _state.currentInput.isEmpty) {
      return;
    }

    final expression = ExpressionSerializer.serializeWithClosedParens(
      _state.tokens,
      _state.currentInput,
    );

    var shouldPersistHistory = false;

    try {
      final result = _evaluator.evaluate(expression, _state.angleMode);
      final formatted = NumberFormatter.format(result);
      _state = _state.copyWith(
        tokens: const [],
        currentInput: NumberFormatter.toCanonicalString(result),
        resultDisplay: formatted,
        shouldResetCurrentInput: true,
        history: _state.history.withEntryAtFront(
          CalculationHistory(
            expression: expression,
            result: formatted,
            timestamp: DateTime.now().toUtc(),
          ),
        ),
      );
      _logger.debug(
        'Cálculo científico: $expression = $formatted',
        tag: _logTag,
      );
      shouldPersistHistory = true;
    } on ScientificCalculationException catch (e) {
      _state = _state.copyWith(
        hasError: true,
        errorType: e.errorType,
        currentInput: '',
        resultDisplay: AppStrings.initialDisplayValue,
        shouldResetCurrentInput: false,
      );
      _logger.warning(
        'Erro no cálculo científico "$expression": ${e.errorType}',
        tag: _logTag,
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
    _notifyWithPreview();
  }

  void backspace() {
    final wasInError = _state.hasError;
    if (wasInError) {
      _clearErrorKeepingExpression();
    }

    if (_state.currentInput.isNotEmpty) {
      final trimmed = _state.currentInput.substring(
        0,
        _state.currentInput.length - 1,
      );
      _state = _state.copyWith(
        currentInput: trimmed,
        shouldResetCurrentInput: false,
      );
      _notifyWithPreview();
      return;
    }

    if (_state.tokens.isEmpty) {
      if (wasInError) {
        notifyListeners();
      }
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
    _notifyWithPreview();
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
    _resetExpressionIfInError();
    _commitPendingOperand();
    _appendToken(
      ExpressionToken(
        type: TokenType.number,
        value: NumberFormatter.toCanonicalString(_state.memoryValue),
      ),
    );
    _notifyWithPreview();
  }

  void memoryClear() {
    _state = _state.copyWith(memoryValue: 0, hasMemoryValue: false);
    notifyListeners();
  }

  Future<bool> copyToClipboard() async {
    if (_state.hasError) {
      _logger.debug('Tentativa de copiar em estado de erro', tag: _logTag);
      return false;
    }
    try {
      await Clipboard.setData(ClipboardData(text: _state.resultDisplay));
      _logger.info('Valor copiado: ${_state.resultDisplay}', tag: _logTag);
      return true;
    } catch (e) {
      _logger.warning('Falha ao copiar: $e', tag: _logTag);
      return false;
    }
  }

  Future<PasteResult> pasteFromClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text == null || data!.text!.isEmpty) {
        _logger.debug('Área de transferência vazia', tag: _logTag);
        return PasteResult.emptyClipboard;
      }

      final text = data.text!.trim();
      final parsed = NumberFormatter.parse(text);

      if (parsed == null) {
        _logger.debug('Valor inválido para colar: $text', tag: _logTag);
        return PasteResult.invalidFormat;
      }

      _resetExpressionIfInError();
      _state = _state.copyWith(
        currentInput: NumberFormatter.toCanonicalString(parsed),
        shouldResetCurrentInput: true,
      );
      _logger.info('Valor colado: ${_state.currentInput}', tag: _logTag);
      _notifyWithPreview();
      return PasteResult.success;
    } catch (e) {
      _logger.warning('Falha ao colar: $e', tag: _logTag);
      return PasteResult.invalidFormat;
    }
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
          tag: _logTag,
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
          ? NumberFormatter.toCanonicalString(parsed)
          : item.result,
      resultDisplay: item.result,
      hasError: false,
      clearErrorType: true,
      shouldResetCurrentInput: true,
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
        tag: _logTag,
      );
    }
  }

  Future<void> _persistHistory() async {
    final saveResult = await _storageService.saveHistory(
      _state.history,
      key: AppStrings.prefScientificHistoryKey,
    );
    saveResult.fold(
      onSuccess: (_) =>
          _logger.debug('Histórico científico salvo', tag: _logTag),
      onFailure: (error, details) => _logger.warning(
        'Falha ao salvar histórico científico: ${error.fullMessage}',
        tag: _logTag,
      ),
    );
  }

  bool _expectsNewOperand() {
    return _state.currentInput.isEmpty && _state.tokens.expectsOperand;
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

  void _appendToken(ExpressionToken token) {
    _state = _state.copyWith(tokens: [..._state.tokens, token]);
  }

  double _percentageOf(double value) {
    final runningTotal = _runningTotalBeforePendingAdditiveOperator();
    if (runningTotal == null) {
      return value / 100;
    }
    return runningTotal * value / 100;
  }

  double? _runningTotalBeforePendingAdditiveOperator() {
    final tokens = _state.tokens;
    if (tokens.length < 2) {
      return null;
    }
    final pendingOperator = tokens.last;
    final isAdditive =
        pendingOperator.type == TokenType.binaryOperator &&
        (pendingOperator.value == AppStrings.additionSymbol ||
            pendingOperator.value == AppStrings.subtractionSymbol);
    if (!isAdditive) {
      return null;
    }

    final totalTokens = tokens.sublist(0, tokens.length - 1);
    final totalExpression = ExpressionSerializer.serializeWithClosedParens(
      totalTokens,
      '',
    );
    try {
      return _evaluator.evaluate(totalExpression, _state.angleMode);
    } on ScientificCalculationException {
      return null;
    }
  }

  void _notifyWithPreview() {
    _applyPreview();
    notifyListeners();
  }

  void _applyPreview() {
    if (_state.tokens.isEmpty && _state.currentInput.isEmpty) {
      if (_state.resultDisplay != AppStrings.initialDisplayValue) {
        _state = _state.copyWith(resultDisplay: AppStrings.initialDisplayValue);
      }
      return;
    }
    if (_shouldSkipPreview()) {
      return;
    }

    final value = _tryEvaluateCurrentExpression();
    if (value != null) {
      _state = _state.copyWith(resultDisplay: NumberFormatter.format(value));
    }
  }

  double? _tryEvaluateCurrentExpression() {
    final expression = ExpressionSerializer.serializeWithClosedParens(
      _state.tokens,
      _state.currentInput,
    );
    try {
      return _evaluator.evaluate(expression, _state.angleMode);
    } on ScientificCalculationException {
      return null;
    }
  }

  bool _shouldSkipPreview() {
    return _state.currentInput.isEmpty &&
        _state.tokens.isNotEmpty &&
        _state.tokens.last.expectsOperandAfter;
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
    _appendToken(
      ExpressionToken(type: TokenType.postfixOperator, value: symbol),
    );
  }

  void _appendPowerSugar(ExpressionToken base) {
    _commitPendingOperand();
    _state = _state.copyWith(
      tokens: [
        ..._state.tokens,
        base,
        const ExpressionToken(
          type: TokenType.binaryOperator,
          value: _powerSymbol,
        ),
      ],
    );
  }

  void _resetShiftIfNotLocked() {
    if (_state.isShiftActive && !_state.isShiftLocked) {
      _state = _state.copyWith(isShiftActive: false);
    }
  }

  void _resetExpressionIfInError() {
    if (_state.hasError) {
      _resetCurrentExpression();
    }
  }

  void _clearErrorKeepingExpression() {
    _state = _state.copyWith(
      hasError: false,
      clearErrorType: true,
      resultDisplay: AppStrings.initialDisplayValue,
    );
  }

  void _resetCurrentExpression() {
    _state = _state.copyWith(
      tokens: const [],
      currentInput: '',
      resultDisplay: AppStrings.initialDisplayValue,
      hasError: false,
      clearErrorType: true,
      shouldResetCurrentInput: false,
    );
  }

  double? _lastValidPreviewValue() {
    if (_state.hasError) {
      return null;
    }
    if (_state.tokens.isEmpty && _state.currentInput.isEmpty) {
      return null;
    }
    return _tryEvaluateCurrentExpression() ??
        NumberFormatter.parse(_state.resultDisplay);
  }
}
