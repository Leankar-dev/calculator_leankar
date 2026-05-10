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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        _version.isEmpty ? 'https://leankar.dev' : 'v$_version • https://leankar.dev',
        style: const TextStyle(
          fontSize: 13,
          color: Colors.blue,
        ),
      ),
    );
  }
}
