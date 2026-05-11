import 'package:calculator_05122025/app_calculator.dart';
import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SettingsController.instance.loadSettings();
  runApp(const MyApp());
}