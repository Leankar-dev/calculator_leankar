import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NumberRowWidget extends StatelessWidget {
  final List<String> numbers;
  final OperationsType operation;
  final String operationSymbol;
  final void Function(String) onNumberPressed;
  final void Function(OperationsType) onOperationPressed;

  const NumberRowWidget({
    super.key,
    required this.numbers,
    required this.operation,
    required this.operationSymbol,
    required this.onNumberPressed,
    required this.onOperationPressed,
  });

  @override
  Widget build(BuildContext context) {
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
}
