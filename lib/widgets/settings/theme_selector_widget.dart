import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ThemeSelectorWidget extends StatelessWidget {
  final SettingsController controller;

  const ThemeSelectorWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Neumorphic(
      style: NeumorphicStyle(
        depth: AppSizes.settingsCardDepth,
        intensity: AppSizes.settingsCardIntensity,
        boxShape: NeumorphicBoxShape.roundRect(
          const BorderRadius.all(
            Radius.circular(AppSizes.settingsCardBorderRadius),
          ),
        ),
      ),
      padding: const EdgeInsets.all(AppSizes.settingsCardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsAppearanceSection,
            style: const TextStyle(
              fontSize: AppSizes.settingsSectionLabelFontSize,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
              letterSpacing: AppSizes.settingsSectionLabelLetterSpacing,
            ),
          ),
          const SizedBox(height: AppSizes.settingsSectionToThemeSpacing),
          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    label: Text(l10n.themeOptionSystem),
                    icon: const Icon(Icons.brightness_auto_outlined),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text(l10n.themeOptionLight),
                    icon: const Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeOptionDark),
                    icon: const Icon(Icons.dark_mode_outlined),
                  ),
                ],
                selected: {controller.themeMode},
                onSelectionChanged: (modes) =>
                    controller.setThemeMode(modes.first),
              );
            },
          ),
        ],
      ),
    );
  }
}
