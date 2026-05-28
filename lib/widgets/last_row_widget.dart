import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
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
          text: AppStrings.initialDisplayValue,
          onPressed: () => onNumberPressed(AppStrings.initialDisplayValue),
        ),
        ButtonWidget(
          text: AppStrings.decimalSeparator,
          onPressed: onDecimal,
        ),
        ButtonWidget(
          text: AppStrings.equalsButtonText,
          onPressed: onCalculate,
          color: AppColors.equalsButton,
        ),
        ButtonWidget(
          text: AppStrings.additionSymbol,
          onPressed: () => onOperationPressed(OperationsType.addition),
          color: AppColors.operationButton,
        ),
      ],
    );
  }
}
