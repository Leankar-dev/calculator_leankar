import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CalculatorFooterWidget extends StatefulWidget {
  const CalculatorFooterWidget({super.key});

  @override
  State<CalculatorFooterWidget> createState() => _CalculatorFooterWidgetState();
}

class _CalculatorFooterWidgetState extends State<CalculatorFooterWidget> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = info.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.footerBottomPadding),
      child: Text(
        _version.isEmpty
            ? AppStrings.settingsWebsiteUrl
            : 'v$_version • ${AppStrings.settingsWebsiteUrl}',
        style: const TextStyle(
          fontSize: AppSizes.footerFontSize,
          color: AppColors.link,
        ),
      ),
    );
  }
}
