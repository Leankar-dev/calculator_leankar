import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ParenPowerRowWidget extends StatelessWidget {
  final bool isShiftActive;
  final VoidCallback onOpenParen;
  final VoidCallback onCloseParen;
  final void Function(ScientificFunctionType) onFunction;

  const ParenPowerRowWidget({
    super.key,
    required this.isShiftActive,
    required this.onOpenParen,
    required this.onCloseParen,
    required this.onFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonWidget(
          key: const ValueKey('scientific_open_paren'),
          text: AppScientificStrings.openParen,
          onPressed: onOpenParen,
          color: AppColors.operationButton,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_close_paren'),
          text: AppScientificStrings.closeParen,
          onPressed: onCloseParen,
          color: AppColors.operationButton,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_square_or_abs'),
          text: isShiftActive
              ? AppScientificStrings.absoluteValue
              : AppScientificStrings.square,
          onPressed: () => onFunction(
            isShiftActive
                ? ScientificFunctionType.absoluteValue
                : ScientificFunctionType.square,
          ),
          color: AppColors.scientificFunction,
        ),
        if (isShiftActive)
          const Expanded(child: SizedBox.shrink())
        else
          ButtonWidget(
            key: const ValueKey('scientific_reciprocal'),
            text: AppScientificStrings.reciprocal,
            onPressed: () => onFunction(ScientificFunctionType.reciprocal),
            color: AppColors.scientificFunction,
          ),
      ],
    );
  }
}
