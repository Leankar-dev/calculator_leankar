import 'package:calculator_05122025/utils/constants.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class FirstRowWidget extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onBackspace;
  final VoidCallback onPercentage;

  const FirstRowWidget({
    super.key,
    required this.onClear,
    required this.onBackspace,
    required this.onPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonWidget(
          text: 'C',
          onPressed: onClear,
          color: AppConstants.clearButtonColor,
        ),
        ButtonWidget(
          text: AppConstants.backspaceSymbol,
          onPressed: onBackspace,
          color: AppConstants.backspaceButtonColor,
        ),
        ButtonWidget(
          text: AppConstants.percentSymbol,
          onPressed: onPercentage,
          color: AppConstants.operationButtonColor,
        ),
      ],
    );
  }
}
