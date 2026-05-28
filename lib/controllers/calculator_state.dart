import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';

class CalculatorState {
  final String displayText;
  final String firstOperand;
  final String secondOperand;
  final OperationsType? currentOperation;
  final bool shouldResetDisplay;
  final List<CalculationHistory> history;
  final bool isLoading;
  final bool hasError;
  final ErrorType? errorType;

  const CalculatorState({
    required this.displayText,
    required this.firstOperand,
    required this.secondOperand,
    this.currentOperation,
    required this.shouldResetDisplay,
    required this.history,
    required this.isLoading,
    required this.hasError,
    this.errorType,
  });

  static CalculatorState initial() => const CalculatorState(
    displayText: AppStrings.initialDisplayValue,
    firstOperand: '',
    secondOperand: '',
    currentOperation: null,
    shouldResetDisplay: false,
    history: [],
    isLoading: false,
    hasError: false,
    errorType: null,
  );

  CalculatorState copyWith({
    String? displayText,
    String? firstOperand,
    String? secondOperand,
    OperationsType? currentOperation,
    bool clearOperation = false,
    bool? shouldResetDisplay,
    List<CalculationHistory>? history,
    bool? isLoading,
    bool? hasError,
    ErrorType? errorType,
    bool clearErrorType = false,
  }) {
    return CalculatorState(
      displayText: displayText ?? this.displayText,
      firstOperand: firstOperand ?? this.firstOperand,
      secondOperand: secondOperand ?? this.secondOperand,
      currentOperation: clearOperation
          ? null
          : (currentOperation ?? this.currentOperation),
      shouldResetDisplay: shouldResetDisplay ?? this.shouldResetDisplay,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorType: clearErrorType ? null : (errorType ?? this.errorType),
    );
  }
}
