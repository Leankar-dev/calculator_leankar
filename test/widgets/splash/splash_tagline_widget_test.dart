import 'package:calculator_05122025/widgets/splash/splash_tagline_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';
import '../../helpers/text_scaled_box.dart';

void main() {
  const taglinePtBr = 'Calcule tudo. Em um só app.';

  Widget createTestWidget(
    double value, {
    double textScale = 1.0,
    Locale locale = const Locale('pt', 'BR'),
  }) {
    return L10nTestApp(
      locale: locale,
      child: TextScaledBox(
        textScale: textScale,
        child: Center(
          child: SplashTaglineWidget(animation: AlwaysStoppedAnimation(value)),
        ),
      ),
    );
  }

  double readOpacity(WidgetTester tester) {
    return tester
        .widget<Opacity>(
          find.descendant(
            of: find.byType(SplashTaglineWidget),
            matching: find.byType(Opacity),
          ),
        )
        .opacity;
  }

  group('SplashTaglineWidget', () {
    testWidgets('exibe a tagline em português', (tester) async {
      await tester.pumpWidget(createTestWidget(0.7));

      expect(find.text(taglinePtBr), findsOneWidget);
    });

    testWidgets('exibe a tagline em inglês', (tester) async {
      await tester.pumpWidget(
        createTestWidget(0.7, locale: const Locale('en')),
      );

      expect(find.text('Calculate everything. In one app.'), findsOneWidget);
    });

    testWidgets('começa invisível', (tester) async {
      await tester.pumpWidget(createTestWidget(0.0));

      expect(readOpacity(tester), 0.0);
    });

    testWidgets('fica totalmente visível depois da revelação', (tester) async {
      await tester.pumpWidget(createTestWidget(0.7));

      expect(readOpacity(tester), 1.0);
    });

    testWidgets('some de novo no fim da saída', (tester) async {
      await tester.pumpWidget(createTestWidget(1.0));

      expect(readOpacity(tester), 0.0);
    });

    testWidgets('desliza para cima enquanto aparece', (tester) async {
      await tester.pumpWidget(createTestWidget(0.5));
      final revealing = tester.getTopLeft(find.text(taglinePtBr)).dy;

      await tester.pumpWidget(createTestWidget(0.7));
      final revealed = tester.getTopLeft(find.text(taglinePtBr)).dy;

      expect(revealing, greaterThan(revealed));
    });

    testWidgets('é decorativa e fica fora da árvore de semântica', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(0.7));

      expect(
        find.descendant(
          of: find.byType(SplashTaglineWidget),
          matching: find.byType(ExcludeSemantics),
        ),
        findsWidgets,
      );
    });

    testWidgets('cabe em 320x568 com texto ampliado sem overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestWidget(0.7, textScale: 1.5));

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(SplashTaglineWidget)).width,
        lessThanOrEqualTo(320),
      );
    });
  });
}
