import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class LastRowWidget extends StatelessWidget {
  final void Function(String) onNumberPressed;
  final VoidCallback onDecimal;
  final VoidCallback onCalculate;
  final void Function(OperationsType) onOperationPressed;

  const LastRowWidget({
    super.key,
    required this.onNumberPressed,
    required this.onDecimal,
    required this.onCalculate,
    required this.onOperationPressed,
  });

  @override
  Widget build(BuildContext context) {
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
