import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class PortraitLayoutWidget extends StatelessWidget {
  final String displayText;
  final String expressionDisplay;
  final Widget keypad;

  const PortraitLayoutWidget({
    super.key,
    required this.displayText,
    required this.expressionDisplay,
    required this.keypad,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.layoutOuterPadding,
      ),
      child: Column(
        children: [
          CalculatorDisplayWidget(
            displayText: displayText,
            expressionDisplay: expressionDisplay,
          ),
          const SizedBox(height: AppSizes.portraitSectionSpacing),
          Expanded(child: SingleChildScrollView(child: keypad)),
        ],
      ),
    );
  }
}
