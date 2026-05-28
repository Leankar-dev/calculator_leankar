import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AppDrawerWidget extends StatelessWidget {
  final VoidCallback onHistoryTap;
  final VoidCallback onImcTap;
  final VoidCallback onSettingsTap;

  const AppDrawerWidget({
    super.key,
    required this.onHistoryTap,
    required this.onImcTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Drawer(
      backgroundColor: NeumorphicTheme.baseColor(context),
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(),
            const Divider(),
            _DrawerItem(
              icon: Icons.history,
              label: l10n.drawerItemHistory,
              onTap: () {
                Navigator.of(context).pop();
                onHistoryTap();
              },
            ),
            _DrawerItem(
              icon: Icons.monitor_weight_outlined,
              label: l10n.drawerItemImc,
              onTap: () {
                Navigator.of(context).pop();
                onImcTap();
              },
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: l10n.drawerItemSettings,
              onTap: () {
                Navigator.of(context).pop();
                onSettingsTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.drawerHeaderPadding),
      child: Row(
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(AppSizes.drawerLogoBorderRadius),
              ),
              depth: AppSizes.drawerLogoDepth,
              intensity: AppSizes.drawerLogoIntensity,
            ),
            padding: const EdgeInsets.all(AppSizes.drawerLogoPadding),
            child: Image.asset(
              AppStrings.logoAssetPath,
              height: AppSizes.drawerLogoHeight,
            ),
          ),
          const SizedBox(width: AppSizes.drawerLogoTitleSpacing),
          const Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: AppSizes.drawerTitleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.drawerItemMarginH,
        vertical: AppSizes.drawerItemMarginV,
      ),
      style: const NeumorphicStyle(
        depth: AppSizes.drawerItemDepth,
        intensity: AppSizes.drawerItemIntensity,
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.iconMuted),
          const SizedBox(width: AppSizes.drawerItemIconSpacing),
          Text(
            label,
            style: const TextStyle(fontSize: AppSizes.drawerItemFontSize),
          ),
        ],
      ),
    );
  }
}
