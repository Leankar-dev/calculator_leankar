import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class LandscapeLayoutWidget extends StatelessWidget {
  final String displayText;
  final String expressionDisplay;
  final VoidCallback onClear;
  final VoidCallback onBackspace;
  final VoidCallback onPercentage;
  final VoidCallback onDecimal;
  final VoidCallback onCalculate;
  final void Function(String) onNumberPressed;
  final void Function(OperationsType) onOperationPressed;

  const LandscapeLayoutWidget({
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CalculatorDisplayWidget(
                  displayText: displayText,
                  expressionDisplay: expressionDisplay,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: CalculatorKeypadWidget(
              onClear: onClear,
              onBackspace: onBackspace,
              onPercentage: onPercentage,
              onDecimal: onDecimal,
              onCalculate: onCalculate,
              onNumberPressed: onNumberPressed,
              onOperationPressed: onOperationPressed,
            ),
          ),
        ],
      ),
    );
  }
}
