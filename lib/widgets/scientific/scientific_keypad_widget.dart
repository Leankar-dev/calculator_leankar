import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/widgets/first_row_widget.dart';
import 'package:calculator_05122025/widgets/last_row_widget.dart';
import 'package:calculator_05122025/widgets/number_row_widget.dart';
import 'package:calculator_05122025/widgets/scientific/log_row_widget.dart';
import 'package:calculator_05122025/widgets/scientific/memory_row_widget.dart';
import 'package:calculator_05122025/widgets/scientific/paren_power_row_widget.dart';
import 'package:calculator_05122025/widgets/scientific/scientific_mode_row_widget.dart';
import 'package:calculator_05122025/widgets/scientific/trig_row_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ScientificKeypadWidget extends StatelessWidget {
  final AngleMode angleMode;
  final bool isShiftActive;
  final bool hasMemoryValue;
  final VoidCallback onToggleAngleMode;
  final VoidCallback onToggleShift;
  final VoidCallback onLockShift;
  final VoidCallback onPi;
  final VoidCallback onEuler;
  final void Function(ScientificFunctionType) onFunction;
  final void Function(String) onBinaryOperator;
  final VoidCallback onOpenParen;
  final VoidCallback onCloseParen;
  final VoidCallback onMemoryAdd;
  final VoidCallback onMemorySubtract;
  final VoidCallback onMemoryRecall;
  final VoidCallback onMemoryClear;
  final VoidCallback onClear;
  final VoidCallback onBackspace;
  final VoidCallback onPercentage;
  final VoidCallback onDecimal;
  final VoidCallback onCalculate;
  final void Function(String) onNumberPressed;

  const ScientificKeypadWidget({
    super.key,
    required this.angleMode,
    required this.isShiftActive,
    required this.hasMemoryValue,
    required this.onToggleAngleMode,
    required this.onToggleShift,
    required this.onLockShift,
    required this.onPi,
    required this.onEuler,
    required this.onFunction,
    required this.onBinaryOperator,
    required this.onOpenParen,
    required this.onCloseParen,
    required this.onMemoryAdd,
    required this.onMemorySubtract,
    required this.onMemoryRecall,
    required this.onMemoryClear,
    required this.onClear,
    required this.onBackspace,
    required this.onPercentage,
    required this.onDecimal,
    required this.onCalculate,
    required this.onNumberPressed,
  });

  void _onOperationPressed(OperationsType operation) {
    onBinaryOperator(operation.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScientificModeRowWidget(
          angleMode: angleMode,
          isShiftActive: isShiftActive,
          onToggleAngleMode: onToggleAngleMode,
          onToggleShift: onToggleShift,
          onLockShift: onLockShift,
          onPi: onPi,
          onEuler: onEuler,
        ),
        TrigRowWidget(
          isShiftActive: isShiftActive,
          onFunction: onFunction,
          onBinaryOperator: onBinaryOperator,
        ),
        LogRowWidget(
          isShiftActive: isShiftActive,
          onFunction: onFunction,
          onBinaryOperator: onBinaryOperator,
        ),
        ParenPowerRowWidget(
          isShiftActive: isShiftActive,
          onOpenParen: onOpenParen,
          onCloseParen: onCloseParen,
          onFunction: onFunction,
        ),
        MemoryRowWidget(
          hasMemoryValue: hasMemoryValue,
          onMemoryAdd: onMemoryAdd,
          onMemorySubtract: onMemorySubtract,
          onMemoryRecall: onMemoryRecall,
          onMemoryClear: onMemoryClear,
        ),
        FirstRowWidget(
          onClear: onClear,
          onBackspace: onBackspace,
          onPercentage: onPercentage,
        ),
        NumberRowWidget(
          numbers: const ['7', '8', '9'],
          operation: OperationsType.division,
          operationSymbol: AppStrings.divisionSymbol,
          onNumberPressed: onNumberPressed,
          onOperationPressed: _onOperationPressed,
        ),
        NumberRowWidget(
          numbers: const ['4', '5', '6'],
          operation: OperationsType.multiplication,
          operationSymbol: AppStrings.multiplicationSymbol,
          onNumberPressed: onNumberPressed,
          onOperationPressed: _onOperationPressed,
        ),
        NumberRowWidget(
          numbers: const ['1', '2', '3'],
          operation: OperationsType.subtraction,
          operationSymbol: AppStrings.subtractionSymbol,
          onNumberPressed: onNumberPressed,
          onOperationPressed: _onOperationPressed,
        ),
        LastRowWidget(
          onNumberPressed: onNumberPressed,
          onDecimal: onDecimal,
          onCalculate: onCalculate,
          onOperationPressed: _onOperationPressed,
        ),
      ],
    );
  }
}
