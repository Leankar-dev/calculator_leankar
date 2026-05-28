import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final SettingsController controller;

  const LanguageSelectorWidget({super.key, required this.controller});

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
            l10n.settingsLanguageSection,
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
              return Column(
                children: SettingsController.supportedLocales
                    .map(
                      (locale) => _LanguageTile(
                        locale: locale,
                        isSelected: controller.locale == locale,
                        onTap: () => controller.setLocale(locale),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  static const Map<String, String> _flagEmojis = {
    'pt_BR': '🇧🇷',
    'en': '🇺🇸',
    'es': '🇪🇸',
    'it': '🇮🇹',
    'fr': '🇫🇷',
  };

  static const Map<String, String> _nativeNames = {
    'pt_BR': 'Português',
    'en': 'English',
    'es': 'Español',
    'it': 'Italiano',
    'fr': 'Français',
  };

  String get _localeKey {
    if (locale.countryCode != null) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.drawerItemMarginV),
      style: NeumorphicStyle(
        depth: isSelected
            ? -AppSizes.drawerItemDepth
            : AppSizes.drawerItemDepth,
        intensity: AppSizes.drawerItemIntensity,
        boxShape: NeumorphicBoxShape.roundRect(
          const BorderRadius.all(
            Radius.circular(AppSizes.settingsCardBorderRadius / 2),
          ),
        ),
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Text(
            _flagEmojis[_localeKey] ?? '',
            style: const TextStyle(fontSize: AppSizes.drawerTitleFontSize),
          ),
          const SizedBox(width: AppSizes.drawerItemIconSpacing),
          Text(
            _nativeNames[_localeKey] ?? locale.languageCode,
            style: TextStyle(
              fontSize: AppSizes.drawerItemFontSize,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: AppColors.imcNormal,
              size: AppSizes.drawerItemFontSize + 4,
            ),
        ],
      ),
    );
  }
}
