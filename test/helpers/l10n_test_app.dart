import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class L10nTestApp extends StatelessWidget {
  final Widget child;
  final Locale locale;

  const L10nTestApp({
    super.key,
    required this.child,
    this.locale = const Locale('pt', 'BR'),
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: SettingsController.supportedLocales,
      locale: locale,
      home: child,
    );
  }
}
