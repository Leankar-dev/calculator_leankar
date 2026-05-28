import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class HistoryItemWidget extends StatelessWidget {
  final CalculationHistory item;
  final void Function(CalculationHistory) onItemTap;

  const HistoryItemWidget({
    super.key,
    required this.item,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppStrings.historyDateFormat);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.historyItemMarginH,
        vertical: AppSizes.historyItemMarginV,
      ),
      child: NeumorphicButton(
        style: NeumorphicStyle(
          depth: AppSizes.historyItemDepth,
          intensity: AppSizes.historyItemIntensity,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(AppSizes.historyItemBorderRadius),
          ),
        ),
        padding: const EdgeInsets.all(AppSizes.historyItemPadding),
        onPressed: () {
          Navigator.pop(context);
          onItemTap(item);
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.expression,
                    style: const TextStyle(
                      fontSize: AppSizes.historyItemExpressionFontSize,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: AppSizes.historyItemInnerSpacing),
                  Text(
                    '${AppStrings.historyResultPrefix}${item.result}',
                    style: TextStyle(
                      fontSize: AppSizes.historyItemResultFontSize,
                      fontWeight: FontWeight.bold,
                      color: NeumorphicTheme.defaultTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              dateFormat.format(item.timestamp),
              style: const TextStyle(
                fontSize: AppSizes.historyItemTimestampFontSize,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
