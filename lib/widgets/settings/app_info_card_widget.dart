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
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.6,
        boxShape: NeumorphicBoxShape.roundRect(
          const BorderRadius.all(Radius.circular(16)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.settingsAboutSection,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: AppStrings.settingsVersionLabel,
            value: _version.isEmpty ? '—' : 'v$_version',
          ),
          const _InfoDivider(),
          const _InfoRow(
            label: AppStrings.settingsDeveloperLabel,
            value: AppStrings.settingsDeveloperName,
          ),
          const _InfoDivider(),
          const _InfoRow(
            label: AppStrings.settingsEmailLabel,
            value: AppStrings.settingsEmail,
          ),
          const _InfoDivider(),
          const _InfoRow(
            label: AppStrings.settingsWebsiteLabel,
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
    return const Divider(height: 1, thickness: 0.5);
  }
}
