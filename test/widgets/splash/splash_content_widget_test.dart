import 'package:calculator_05122025/models/splash_layout_metrics.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/widgets/splash/splash_content_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_key_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_logo_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_tagline_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_title_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';
import '../../helpers/text_scaled_box.dart';

void main() {
  Widget createTestWidget({
    double value = 0.6,
    bool showOrbit = true,
    double textScale = 1.0,
  }) {
    return L10nTestApp(
      child: TextScaledBox(
        textScale: textScale,
        child: SplashContentWidget(
          animation: AlwaysStoppedAnimation(value),
          showOrbit: showOrbit,
        ),
      ),
    );
  }

  void useScreen(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  group('SplashContentWidget', () {
    testWidgets('mantém o logo no centro exato da tela', (tester) async {
      useScreen(tester, const Size(320, 568));

      await tester.pumpWidget(createTestWidget());

      expect(
        tester.getCenter(find.byType(SplashLogoWidget)),
        const Offset(160, 284),
      );
    });

    testWidgets('mostra as seis teclas quando a órbita está ativa', (
      tester,
    ) async {
      useScreen(tester, const Size(320, 568));

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SplashKeyWidget), findsNWidgets(6));
    });

    testWidgets('omite as teclas quando a órbita está desligada', (
      tester,
    ) async {
      useScreen(tester, const Size(320, 568));

      await tester.pumpWidget(createTestWidget(showOrbit: false));

      expect(find.byType(SplashKeyWidget), findsNothing);
      expect(find.byType(SplashLogoWidget), findsOneWidget);
      expect(find.byType(SplashTitleWidget), findsOneWidget);
      expect(find.byType(SplashTaglineWidget), findsOneWidget);
    });

    testWidgets('o título fica abaixo da órbita e a tagline abaixo do título', (
      tester,
    ) async {
      useScreen(tester, const Size(320, 568));
      final metrics = SplashLayoutMetrics.fromShortestSide(320);

      await tester.pumpWidget(createTestWidget());

      final titleTop = tester.getTopLeft(find.byType(SplashTitleWidget)).dy;
      final taglineTop = tester.getTopLeft(find.byType(SplashTaglineWidget)).dy;

      expect(titleTop, closeTo(284 + metrics.titleOffsetFromCenter, 0.5));
      expect(taglineTop, greaterThan(titleTop));
    });

    testWidgets('em tela larga limita o logo à largura máxima', (tester) async {
      useScreen(tester, const Size(1024, 768));

      await tester.pumpWidget(createTestWidget());

      expect(
        tester.getSize(find.byType(SplashLogoWidget)).width,
        lessThanOrEqualTo(
          AppSizes.maxCalculatorWidth * AppSizes.splashLogoWidthFactor + 0.01,
        ),
      );
      expect(
        tester.getCenter(find.byType(SplashLogoWidget)),
        const Offset(512, 384),
      );
    });

    testWidgets('cabe em 320x568 com texto ampliado sem overflow', (
      tester,
    ) async {
      useScreen(tester, const Size(320, 568));

      await tester.pumpWidget(createTestWidget(textScale: 1.5));

      expect(tester.takeException(), isNull);
      expect(
        tester.getBottomRight(find.byType(SplashTaglineWidget)).dy,
        lessThanOrEqualTo(568),
      );
    });

    testWidgets('em tela muito baixa reduz o texto em vez de estourar', (
      tester,
    ) async {
      useScreen(tester, const Size(320, 320));

      await tester.pumpWidget(createTestWidget(textScale: 1.5));

      expect(tester.takeException(), isNull);
    });
  });
}
