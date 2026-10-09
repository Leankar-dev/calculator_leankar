import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/pages/calculator_page.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsController.instance,
      builder: (context, child) => NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appTitle,
        themeMode: SettingsController.instance.themeMode,
        locale: SettingsController.instance.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: SettingsController.supportedLocales,
        theme: const NeumorphicThemeData(
          baseColor: AppColors.themeBaseLight,
          lightSource: LightSource.topLeft,
          depth: AppSizes.appThemeDepthLight,
          intensity: AppSizes.appThemeIntensityLight,
        ),
        darkTheme: const NeumorphicThemeData(
          baseColor: AppColors.themeBaseDark,
          lightSource: LightSource.topLeft,
          depth: AppSizes.appThemeDepthDark,
          intensity: AppSizes.appThemeIntensityDark,
        ),
        home: const CalculatorPage(),
      ),
    );
  }
}
