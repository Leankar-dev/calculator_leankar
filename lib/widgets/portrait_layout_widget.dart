import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:calculator_05122025/widgets/calculator_footer_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class PortraitLayoutWidget extends StatelessWidget {
  final String displayText;
  final String expressionDisplay;
  final VoidCallback onClear;
  final VoidCallback onBackspace;
  final VoidCallback onPercentage;
  final VoidCallback onDecimal;
  final VoidCallback onCalculate;
  final void Function(String) onNumberPressed;
  final void Function(OperationsType) onOperationPressed;

  const PortraitLayoutWidget({
    super.key,
    required this.displayText,
    required this.expressionDisplay,
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CalculatorDisplayWidget(
              displayText: displayText,
              expressionDisplay: expressionDisplay,
            ),
            const SizedBox(height: 8),
            CalculatorKeypadWidget(
              onClear: onClear,
              onBackspace: onBackspace,
              onPercentage: onPercentage,
              onDecimal: onDecimal,
              onCalculate: onCalculate,
              onNumberPressed: onNumberPressed,
              onOperationPressed: onOperationPressed,
            ),
            const SizedBox(height: 8),
            const CalculatorFooterWidget(),
          ],
        ),
      ),
    );
  }
}
