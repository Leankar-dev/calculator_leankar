import 'package:calculator_05122025/models/expression_token.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';

class ScientificCalculatorState {
  final List<ExpressionToken> tokens;
  final String currentInput;
  final String resultDisplay;
  final AngleMode angleMode;
  final bool isShiftActive;
  final bool isShiftLocked;
  final double memoryValue;
  final bool hasMemoryValue;
  final bool hasError;
  final ScientificErrorType? errorType;

  const ScientificCalculatorState({
    required this.tokens,
    required this.currentInput,
    required this.resultDisplay,
    required this.angleMode,
    required this.isShiftActive,
    required this.isShiftLocked,
    required this.memoryValue,
    required this.hasMemoryValue,
    required this.hasError,
    this.errorType,
  });

  static ScientificCalculatorState initial() => const ScientificCalculatorState(
    tokens: [],
    currentInput: '0',
    resultDisplay: '0',
    angleMode: AngleMode.deg,
    isShiftActive: false,
    isShiftLocked: false,
    memoryValue: 0,
    hasMemoryValue: false,
    hasError: false,
    errorType: null,
  );

  ScientificCalculatorState copyWith({
    List<ExpressionToken>? tokens,
    String? currentInput,
    String? resultDisplay,
    AngleMode? angleMode,
    bool? isShiftActive,
    bool? isShiftLocked,
    double? memoryValue,
    bool? hasMemoryValue,
    bool? hasError,
    ScientificErrorType? errorType,
    bool clearErrorType = false,
  }) {
    return ScientificCalculatorState(
      tokens: tokens ?? this.tokens,
      currentInput: currentInput ?? this.currentInput,
      resultDisplay: resultDisplay ?? this.resultDisplay,
      angleMode: angleMode ?? this.angleMode,
      isShiftActive: isShiftActive ?? this.isShiftActive,
      isShiftLocked: isShiftLocked ?? this.isShiftLocked,
      memoryValue: memoryValue ?? this.memoryValue,
      hasMemoryValue: hasMemoryValue ?? this.hasMemoryValue,
      hasError: hasError ?? this.hasError,
      errorType: clearErrorType ? null : (errorType ?? this.errorType),
    );
  }
}
