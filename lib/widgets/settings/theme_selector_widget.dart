import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ThemeSelectorWidget extends StatelessWidget {
  final SettingsController controller;

  const ThemeSelectorWidget({super.key, required this.controller});

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.settingsAppearanceSection,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    label: Text(AppStrings.themeOptionSystem),
                    icon: Icon(Icons.brightness_auto_outlined),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text(AppStrings.themeOptionLight),
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text(AppStrings.themeOptionDark),
                    icon: Icon(Icons.dark_mode_outlined),
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
