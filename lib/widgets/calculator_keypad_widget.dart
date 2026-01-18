import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/first_row_widget.dart';
import 'package:calculator_05122025/widgets/last_row_widget.dart';
import 'package:calculator_05122025/widgets/number_row_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CalculatorKeypadWidget extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onBackspace;
  final VoidCallback onPercentage;
  final VoidCallback onDecimal;
  final VoidCallback onCalculate;
  final void Function(String) onNumberPressed;
  final void Function(OperationsType) onOperationPressed;

  const CalculatorKeypadWidget({
    super.key,
    required this.onClear,
    required this.onBackspace,
    required this.onPercentage,
    required this.onDecimal,
    required this.onCalculate,
    required this.onNumberPressed,
    required this.onOperationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FirstRowWidget(
          onClear: onClear,
          onBackspace: onBackspace,
          onPercentage: onPercentage,
        ),
        NumberRowWidget(
          numbers: const ['7', '8', '9'],
          operation: OperationsType.division,
          operationSymbol: '\u{00F7}',
          onNumberPressed: onNumberPressed,
          onOperationPressed: onOperationPressed,
        ),
        NumberRowWidget(
          numbers: const ['4', '5', '6'],
          operation: OperationsType.multiplication,
          operationSymbol: '\u{00D7}',
          onNumberPressed: onNumberPressed,
          onOperationPressed: onOperationPressed,
        ),
        NumberRowWidget(
          numbers: const ['1', '2', '3'],
          operation: OperationsType.subtraction,
          operationSymbol: '\u{002D}',
          onNumberPressed: onNumberPressed,
          onOperationPressed: onOperationPressed,
        ),
        LastRowWidget(
          onNumberPressed: onNumberPressed,
          onDecimal: onDecimal,
          onCalculate: onCalculate,
          onOperationPressed: onOperationPressed,
        ),
      ],
    );
  }
}
