import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class TrigRowWidget extends StatelessWidget {
  final bool isShiftActive;
  final void Function(ScientificFunctionType) onFunction;
  final void Function(String) onBinaryOperator;

  const TrigRowWidget({
    super.key,
    required this.isShiftActive,
    required this.onFunction,
    required this.onBinaryOperator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonWidget(
          key: const ValueKey('scientific_sin'),
          text: isShiftActive
              ? AppScientificStrings.sinInverse
              : AppScientificStrings.sin,
          onPressed: () => onFunction(
            isShiftActive
                ? ScientificFunctionType.asin
                : ScientificFunctionType.sin,
          ),
          color: AppColors.scientificFunction,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_cos'),
          text: isShiftActive
              ? AppScientificStrings.cosInverse
              : AppScientificStrings.cos,
          onPressed: () => onFunction(
            isShiftActive
                ? ScientificFunctionType.acos
                : ScientificFunctionType.cos,
          ),
          color: AppColors.scientificFunction,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_tan'),
          text: isShiftActive
              ? AppScientificStrings.tanInverse
              : AppScientificStrings.tan,
          onPressed: () => onFunction(
            isShiftActive
                ? ScientificFunctionType.atan
                : ScientificFunctionType.tan,
          ),
          color: AppColors.scientificFunction,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_power_or_cube'),
          text: isShiftActive
              ? AppScientificStrings.cube
              : AppScientificStrings.power,
          onPressed: () => isShiftActive
              ? onFunction(ScientificFunctionType.cube)
              : onBinaryOperator('^'),
          color: AppColors.operationButton,
        ),
      ],
    );
  }
}
