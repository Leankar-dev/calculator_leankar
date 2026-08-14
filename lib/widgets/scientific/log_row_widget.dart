import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class LogRowWidget extends StatelessWidget {
  final bool isShiftActive;
  final void Function(ScientificFunctionType) onFunction;
  final void Function(String) onBinaryOperator;

  const LogRowWidget({
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
          key: const ValueKey('scientific_log_or_exp10'),
          text: isShiftActive
              ? AppScientificStrings.exp10
              : AppScientificStrings.log,
          onPressed: () => onFunction(
            isShiftActive
                ? ScientificFunctionType.exp10
                : ScientificFunctionType.log,
          ),
          color: AppColors.scientificFunction,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_ln_or_expe'),
          text: isShiftActive
              ? AppScientificStrings.expE
              : AppScientificStrings.ln,
          onPressed: () => onFunction(
            isShiftActive
                ? ScientificFunctionType.expE
                : ScientificFunctionType.ln,
          ),
          color: AppColors.scientificFunction,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_factorial_or_npr'),
          text: isShiftActive
              ? AppScientificStrings.permutation
              : AppScientificStrings.factorial,
          onPressed: () => isShiftActive
              ? onBinaryOperator('P')
              : onFunction(ScientificFunctionType.factorial),
          color: AppColors.scientificFunction,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_sqrt_or_cbrt'),
          text: isShiftActive
              ? AppScientificStrings.cbrt
              : AppScientificStrings.sqrt,
          onPressed: () => onFunction(
            isShiftActive
                ? ScientificFunctionType.cbrt
                : ScientificFunctionType.sqrt,
          ),
          color: AppColors.scientificFunction,
        ),
      ],
    );
  }
}
