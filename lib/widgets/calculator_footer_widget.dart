import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CalculatorFooterWidget extends StatelessWidget {
  const CalculatorFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.footerBottomPadding),
      child: Text(
        AppStrings.settingsWebsiteUrl,
        style: const TextStyle(
          fontSize: AppSizes.footerFontSize,
          color: AppColors.link,
        ),
      ),
    );
  }
}
