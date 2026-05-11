import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class HistoryHeaderWidget extends StatelessWidget {
  final bool hasHistory;
  final VoidCallback onClearHistory;

  const HistoryHeaderWidget({
    super.key,
    required this.hasHistory,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.historyHeaderPaddingH, vertical: AppSizes.historyHeaderPaddingV),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.historyTitle,
            style: TextStyle(
              fontSize: AppSizes.historyTitleFontSize,
              fontWeight: FontWeight.bold,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
          if (hasHistory)
            NeumorphicButton(
              style: NeumorphicStyle(
                depth: AppSizes.historyClearButtonDepth,
                intensity: AppSizes.historyClearButtonIntensity,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(AppSizes.historyClearButtonBorderRadius),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.historyClearButtonPaddingH, vertical: AppSizes.historyClearButtonPaddingV),
              onPressed: () {
                Navigator.pop(context);
                onClearHistory();
              },
              child: const Text(
                AppStrings.historyClearButton,
                style: TextStyle(
                  fontSize: AppSizes.historyClearButtonFontSize,
                  color: AppColors.clearHistoryText,
                ),
              ),
            ),
        ],
      ),
    );
  }
}