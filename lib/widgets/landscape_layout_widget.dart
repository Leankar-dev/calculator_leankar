import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class LandscapeLayoutWidget extends StatelessWidget {
  final String displayText;
  final String expressionDisplay;
  final Widget keypad;

  const LandscapeLayoutWidget({
    super.key,
    required this.displayText,
    required this.expressionDisplay,
    required this.keypad,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.layoutOuterPadding),
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
            child: SingleChildScrollView(child: keypad),
          ),
        ],
      ),
    );
  }
}
