import 'package:calculator_05122025/controllers/splash_controller.dart';
import 'package:calculator_05122025/pages/splash_page.dart';
import 'package:calculator_05122025/utils/constants/app_splash_timeline.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/splash_status.dart';
import 'package:calculator_05122025/widgets/splash/splash_background_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_key_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_logo_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_orbit_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_tagline_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_title_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n_test_app.dart';
import '../helpers/text_scaled_box.dart';
import '../mocks/mock_logger_service.dart';

void main() {
  const destinationText = 'destino';
  const beforeStart = Duration(milliseconds: 200);

  late MockLoggerService logger;
  late SplashController controller;

  setUp(() {
    logger = MockLoggerService();
    controller = SplashController(loggerService: logger);
  });

  tearDown(() {
    controller.dispose();
  });

  Widget createTestWidget({
    VoidCallback? onFirstFrame,
    double textScale = 1.0,
  }) {
    return L10nTestApp(
      child: TextScaledBox(
        textScale: textScale,
        child: SplashPage(
          controller: controller,
          onFirstFrame: onFirstFrame,
          nextPageBuilder: (_) => const Text(destinationText),
        ),
      ),
    );
  }

  Future<void> pumpUntilRunning(WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump(beforeStart);
  }

  group('SplashPage', () {
    testWidgets('renderiza fundo, logo, órbita, título e tagline', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(beforeStart);
      await tester.pump(const Duration(milliseconds: 900));

      expect(find.byType(SplashBackgroundWidget), findsOneWidget);
      expect(find.byType(SplashLogoWidget), findsOneWidget);
      expect(find.byType(SplashOrbitWidget), findsOneWidget);
      expect(find.byType(SplashTitleWidget), findsOneWidget);
      expect(find.text('Calcule tudo. Em um só app.'), findsOneWidget);

      final titleLetters = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(SplashTitleWidget),
              matching: find.byType(Text),
            ),
          )
          .map((text) => text.data)
          .join();
      expect(titleLetters, AppStrings.appName.replaceAll(' ', ''));
      expect(find.byType(SplashTaglineWidget), findsOneWidget);
    });

    testWidgets('chama onFirstFrame exatamente uma vez', (tester) async {
      var calls = 0;

      await tester.pumpWidget(createTestWidget(onFirstFrame: () => calls++));
      expect(calls, 1);

      await tester.pump(beforeStart);
      await tester.pump(AppSplashTimeline.totalDuration);
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('inicia a animação depois do pré-carregamento do logo', (
      tester,
    ) async {
      await pumpUntilRunning(tester);

      expect(controller.state.status, SplashStatus.running);
      expect(controller.state.reduceMotion, isFalse);
    });

    testWidgets('ao fim da animação navega para o destino e sai da árvore', (
      tester,
    ) async {
      await pumpUntilRunning(tester);
      await tester.pump(AppSplashTimeline.totalDuration);
      await tester.pumpAndSettle();

      expect(find.text(destinationText), findsOneWidget);
      expect(find.byType(SplashPage), findsNothing);
      expect(controller.state.status, SplashStatus.finished);
      expect(
        Navigator.of(tester.element(find.text(destinationText))).canPop(),
        isFalse,
      );
    });

    testWidgets('toque durante a animação acelera até o destino', (
      tester,
    ) async {
      await pumpUntilRunning(tester);
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.byType(SplashPage));
      await tester.pump();
      expect(controller.state.skipRequested, isTrue);

      const frame = Duration(milliseconds: 16);
      final limit =
          AppSplashTimeline.skipDuration +
          AppSplashTimeline.routeTransitionDuration +
          Duration(milliseconds: 150);
      var elapsed = Duration.zero;
      while (find.byType(SplashPage).evaluate().isNotEmpty && elapsed < limit) {
        await tester.pump(frame);
        elapsed += frame;
      }

      expect(find.byType(SplashPage), findsNothing);
      expect(find.text(destinationText), findsOneWidget);
    });

    testWidgets('dois toques rápidos não navegam duas vezes', (tester) async {
      await pumpUntilRunning(tester);
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.byType(SplashPage));
      await tester.tap(find.byType(SplashPage));
      await tester.pumpAndSettle();

      expect(find.text(destinationText), findsOneWidget);
      expect(logger.warningMessages, contains(contains('requestSkip')));
    });

    testWidgets('a saída da animação coloca o controller em exiting', (
      tester,
    ) async {
      await pumpUntilRunning(tester);

      await tester.pump(AppSplashTimeline.totalDuration * 0.85);

      expect(controller.state.status, SplashStatus.exiting);
      await tester.pumpAndSettle();
    });

    testWidgets('expõe o rótulo de semântica da splash', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpUntilRunning(tester);

      expect(find.bySemanticsLabel('Leankar Calc, carregando'), findsOneWidget);
      handle.dispose();
      await tester.pumpAndSettle();
    });

    testWidgets('sem timers pendentes quando descartada antes de terminar', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 50));

      await tester.pumpWidget(const SizedBox());
      await tester.pump(AppSplashTimeline.totalDuration);

      expect(tester.takeException(), isNull);
    });

    testWidgets('não descarta o controller recebido por injeção', (
      tester,
    ) async {
      await pumpUntilRunning(tester);
      await tester.pump(AppSplashTimeline.totalDuration);
      await tester.pumpAndSettle();

      expect(find.byType(SplashPage), findsNothing);
      expect(() => controller.addListener(() {}), returnsNormally);
    });

    testWidgets('descarta o controller que ela mesma criou', (tester) async {
      await tester.pumpWidget(
        L10nTestApp(
          child: SplashPage(
            nextPageBuilder: (_) => const Text(destinationText),
          ),
        ),
      );
      await tester.pump(beforeStart);
      await tester.pump(AppSplashTimeline.totalDuration);
      await tester.pumpAndSettle();

      expect(find.text(destinationText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('cabe em 320x568 com texto ampliado sem overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestWidget(textScale: 1.5));
      await tester.pump(beforeStart);
      await tester.pump(const Duration(milliseconds: 900));

      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
    });
  });

  group('SplashPage com movimento reduzido', () {
    void enableReducedMotion(WidgetTester tester) {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
    }

    testWidgets('mostra logo, título e tagline sem teclas', (tester) async {
      enableReducedMotion(tester);

      await pumpUntilRunning(tester);

      expect(controller.state.reduceMotion, isTrue);
      expect(find.byType(SplashKeyWidget), findsNothing);
      expect(find.byType(SplashOrbitWidget), findsNothing);
      expect(find.byType(SplashLogoWidget), findsOneWidget);
      expect(find.text('Calcule tudo. Em um só app.'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('título e tagline ficam totalmente visíveis', (tester) async {
      enableReducedMotion(tester);

      await pumpUntilRunning(tester);

      final opacities = tester
          .widgetList<Opacity>(
            find.descendant(
              of: find.byType(SplashTitleWidget),
              matching: find.byType(Opacity),
            ),
          )
          .map((opacity) => opacity.opacity);
      expect(opacities, everyElement(1.0));
      await tester.pumpAndSettle();
    });

    testWidgets('navega depois da pausa e da transição curta', (tester) async {
      enableReducedMotion(tester);

      await pumpUntilRunning(tester);
      await tester.pump(AppSplashTimeline.reducedMotionHold);
      await tester.pump(AppSplashTimeline.reducedMotionTransition);
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text(destinationText), findsOneWidget);
      expect(find.byType(SplashPage), findsNothing);
    });

    testWidgets('toque pula a pausa imediatamente', (tester) async {
      enableReducedMotion(tester);

      await pumpUntilRunning(tester);
      await tester.tap(find.byType(SplashPage));
      await tester.pump();
      await tester.pump(AppSplashTimeline.reducedMotionTransition);
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text(destinationText), findsOneWidget);
      expect(find.byType(SplashPage), findsNothing);
    });
  });
}
