import 'package:calculator_05122025/app/app_calculator.dart';
import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/pages/calculator_page.dart';
import 'package:calculator_05122025/pages/splash_page.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const beforeStart = Duration(milliseconds: 200);

  setUp(() {
    SharedPreferences.setMockInitialValues({
      AppStrings.prefAdConsentKey: false,
    });
  });

  tearDown(() async {
    await SettingsController.instance.setThemeMode(ThemeMode.system);
  });

  Future<void> pumpThroughSplash(WidgetTester tester) async {
    await tester.pump(beforeStart);
    await tester.pump(AppSplashTimeline.totalDuration);
    await tester.pumpAndSettle();
  }

  group('AppCalculator', () {
    testWidgets('abre a SplashPage como tela inicial', (tester) async {
      await tester.pumpWidget(const AppCalculator());

      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(CalculatorPage), findsNothing);

      await pumpThroughSplash(tester);
    });

    testWidgets('depois da splash exibe a CalculatorPage', (tester) async {
      await tester.pumpWidget(const AppCalculator());

      await pumpThroughSplash(tester);

      expect(find.byType(CalculatorPage), findsOneWidget);
      expect(find.byType(SplashPage), findsNothing);
    });

    testWidgets('chama onSplashReady uma única vez', (tester) async {
      var calls = 0;

      await tester.pumpWidget(AppCalculator(onSplashReady: () => calls++));
      expect(calls, 1);

      await pumpThroughSplash(tester);

      expect(calls, 1);
    });

    testWidgets('funciona sem onSplashReady', (tester) async {
      await tester.pumpWidget(const AppCalculator());

      await pumpThroughSplash(tester);

      expect(tester.takeException(), isNull);
    });

    testWidgets('mudar o tema depois da splash não traz a splash de volta', (
      tester,
    ) async {
      await tester.pumpWidget(const AppCalculator());
      await pumpThroughSplash(tester);

      await SettingsController.instance.setThemeMode(ThemeMode.dark);
      await tester.pumpAndSettle();

      expect(find.byType(SplashPage), findsNothing);
      expect(find.byType(CalculatorPage), findsOneWidget);
    });

    testWidgets('mudar o tema durante a splash não reinicia a animação', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(AppCalculator(onSplashReady: () => calls++));
      await tester.pump(beforeStart);

      await SettingsController.instance.setThemeMode(ThemeMode.dark);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SplashPage), findsOneWidget);
      expect(calls, 1);

      await pumpThroughSplash(tester);
      expect(find.byType(CalculatorPage), findsOneWidget);
    });
  });
}
