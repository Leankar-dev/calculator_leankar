import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AdConsentSettingsWidget extends StatelessWidget {
  final AdConsentController controller;

  const AdConsentSettingsWidget({super.key, required this.controller});

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
            l10n.settingsAdsSection,
            style: const TextStyle(
              fontSize: AppSizes.settingsSectionLabelFontSize,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
              letterSpacing: AppSizes.settingsSectionLabelLetterSpacing,
            ),
          ),
          const SizedBox(height: AppSizes.settingsSectionToThemeSpacing),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsAdsConsentTitle,
                      style: const TextStyle(
                        fontSize: AppSizes.drawerItemFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.settingsAdsTitleToDescriptionSpacing,
                    ),
                    Text(
                      l10n.settingsAdsConsentDescription,
                      style: const TextStyle(
                        fontSize: AppSizes.settingsAdsDescriptionFontSize,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.settingsAdsTextToSwitchSpacing),
              ListenableBuilder(
                listenable: controller,
                builder: (context, child) {
                  return NeumorphicSwitch(
                    key: const ValueKey('ad_consent_switch'),
                    value: controller.state.canRequestAds,
                    onChanged: controller.submitUserChoice,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
