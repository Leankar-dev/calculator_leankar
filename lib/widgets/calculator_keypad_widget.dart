import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
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
        _buildFirstRow(),
        _buildNumberRow(['7', '8', '9'], OperationsType.division, '\u{00F7}'),
        _buildNumberRow(
          ['4', '5', '6'],
          OperationsType.multiplication,
          '\u{00D7}',
        ),
        _buildNumberRow(
          ['1', '2', '3'],
          OperationsType.subtraction,
          '\u{002D}',
        ),
        _buildLastRow(),
      ],
    );
  }

  Widget _buildFirstRow() {
    return Row(
      children: [
        ButtonWidget(
          text: 'C',
          onPressed: onClear,
          color: const Color(0xFFE57373),
        ),
        ButtonWidget(
          text: '\u{232B}',
          onPressed: onBackspace,
          color: const Color(0xFFFFB74D),
        ),
        ButtonWidget(
          text: '\u{0025}',
          onPressed: onPercentage,
          color: const Color(0xFF64B5F6),
        ),
      ],
    );
  }

  Widget _buildNumberRow(
    List<String> numbers,
    OperationsType operation,
    String operationSymbol,
  ) {
    return Row(
      children: [
        ...numbers.map(
          (number) => ButtonWidget(
            text: number,
            onPressed: () => onNumberPressed(number),
          ),
        ),
        ButtonWidget(
          text: operationSymbol,
          onPressed: () => onOperationPressed(operation),
          color: const Color(0xFF64B5F6),
        ),
      ],
    );
  }

  Widget _buildLastRow() {
    return Row(
      children: [
        ButtonWidget(
          text: '0',
          onPressed: () => onNumberPressed('0'),
        ),
        ButtonWidget(
          text: ',',
          onPressed: onDecimal,
        ),
        ButtonWidget(
          text: '=',
          onPressed: onCalculate,
          color: const Color(0xFF81C784),
        ),
        ButtonWidget(
          text: '\u{002B}',
          onPressed: () => onOperationPressed(OperationsType.addition),
          color: const Color(0xFF64B5F6),
        ),
      ],
    );
  }
}
