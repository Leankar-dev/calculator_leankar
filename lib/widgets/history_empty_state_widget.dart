import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class HistoryEmptyStateWidget extends StatelessWidget {
  const HistoryEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.historyEmptyPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.history,
              size: AppSizes.historyEmptyIconSize,
              color: AppColors.iconDisabled,
            ),
            const SizedBox(height: AppSizes.historyEmptyIconSpacing),
            Text(
              l10n.historyEmptyMessage,
              style: const TextStyle(
                fontSize: AppSizes.historyEmptyFontSize,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
