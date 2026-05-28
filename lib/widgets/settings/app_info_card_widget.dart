import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoCardWidget extends StatefulWidget {
  const AppInfoCardWidget({super.key});

  @override
  State<AppInfoCardWidget> createState() => _AppInfoCardWidgetState();
}

class _AppInfoCardWidgetState extends State<AppInfoCardWidget> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _version = info.version);
    }
  }

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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.settingsInfoCardPaddingH,
        vertical: AppSizes.settingsInfoCardPaddingV,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsAboutSection,
            style: const TextStyle(
              fontSize: AppSizes.settingsSectionLabelFontSize,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
              letterSpacing: AppSizes.settingsSectionLabelLetterSpacing,
            ),
          ),
          const SizedBox(height: AppSizes.settingsSectionToInfoSpacing),
          _InfoRow(
            label: l10n.settingsVersionLabel,
            value: _version.isEmpty
                ? AppStrings.versionPlaceholder
                : '${AppStrings.versionPrefix}$_version',
          ),
          const _InfoDivider(),
          _InfoRow(
            label: l10n.settingsDeveloperLabel,
            value: AppStrings.settingsDeveloperName,
          ),
          const _InfoDivider(),
          _InfoRow(
            label: l10n.settingsEmailLabel,
            value: AppStrings.settingsEmail,
          ),
          const _InfoDivider(),
          _InfoRow(
            label: l10n.settingsWebsiteLabel,
            value: AppStrings.settingsWebsite,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.settingsInfoRowPaddingV,
      ),
      child: Row(
        children: [
          SizedBox(
            width: AppSizes.settingsInfoLabelWidth,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: AppSizes.settingsInfoFontSize,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: AppSizes.settingsInfoFontSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: AppSizes.settingsDividerHeight,
      thickness: AppSizes.settingsDividerThickness,
    );
  }
}
