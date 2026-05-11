import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ImcCalculatorPage extends StatelessWidget {
  const ImcCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        leading: NeumorphicButton(
          onPressed: () => Navigator.of(context).pop(),
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: AppSizes.appBarMenuButtonDepth,
            intensity: AppSizes.appBarMenuButtonIntensity,
          ),
          padding: const EdgeInsets.all(AppSizes.appBarMenuButtonPadding),
          child: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryText),
        ),
        title: const Text(
          AppStrings.imcPageTitle,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
      ),
      body: const SafeArea(
        child: _UnderConstructionBody(),
      ),
    );
  }
}

class _UnderConstructionBody extends StatelessWidget {
  const _UnderConstructionBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.imcPlaceholderPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Neumorphic(
              style: const NeumorphicStyle(
                depth: AppSizes.imcPlaceholderIconDepth,
                intensity: AppSizes.imcPlaceholderIconIntensity,
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              padding: const EdgeInsets.all(AppSizes.imcPlaceholderIconContainerPadding),
              child: const Icon(
                Icons.construction_outlined,
                size: AppSizes.imcPlaceholderIconSize,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSizes.imcPlaceholderIconSpacing),
            const Text(
              AppStrings.imcUnderConstructionTitle,
              style: TextStyle(
                fontSize: AppSizes.imcPlaceholderTitleFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: AppSizes.imcPlaceholderTitleSpacing),
            Text(
              AppStrings.imcUnderConstructionDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: AppSizes.imcPlaceholderDescriptionFontSize, color: AppColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
