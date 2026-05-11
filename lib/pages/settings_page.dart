import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/settings/app_info_card_widget.dart';
import 'package:calculator_05122025/widgets/settings/theme_selector_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller;

  const SettingsPage({super.key, required this.controller});

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
          AppStrings.settingsPageTitle,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.settingsBodyPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AppLogoSection(),
              const SizedBox(height: AppSizes.settingsLogoToSectionSpacing),
              ThemeSelectorWidget(controller: controller),
              const SizedBox(height: AppSizes.settingsSectionSpacing),
              const AppInfoCardWidget(),
              const SizedBox(height: AppSizes.settingsBottomSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppLogoSection extends StatelessWidget {
  const _AppLogoSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(AppSizes.settingsLogoBorderRadius)),
          depth: AppSizes.settingsLogoDepth,
          intensity: AppSizes.settingsLogoIntensity,
          lightSource: LightSource.topLeft,
          color: NeumorphicTheme.baseColor(context),
        ),
        padding: const EdgeInsets.all(AppSizes.settingsLogoPadding),
        child: Image.asset(AppStrings.logoAssetPath, height: AppSizes.settingsLogoHeight),
      ),
    );
  }
}
