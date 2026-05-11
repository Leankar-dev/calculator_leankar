import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
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
        title: const Text(
          AppStrings.settingsPageTitle,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AppLogoSection(),
              const SizedBox(height: 40),
              ThemeSelectorWidget(controller: controller),
              const SizedBox(height: 24),
              const AppInfoCardWidget(),
              const SizedBox(height: 16),
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
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(24)),
          depth: 8,
          intensity: 0.8,
          lightSource: LightSource.topLeft,
          color: NeumorphicTheme.baseColor(context),
        ),
        padding: const EdgeInsets.all(20),
        child: Image.asset(AppStrings.logoAssetPath, height: 80),
      ),
    );
  }
}
