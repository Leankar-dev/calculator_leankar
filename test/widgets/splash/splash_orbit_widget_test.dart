import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/enums/splash_symbol.dart';
import 'package:calculator_05122025/widgets/splash/splash_key_widget.dart';
import 'package:calculator_05122025/widgets/splash/splash_orbit_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';
import '../../helpers/text_scaled_box.dart';

void main() {
  const tileExtent = 80.0;
  const keyExtent = tileExtent * AppSizes.splashKeyExtentFactor;
  const radius = tileExtent * AppSizes.splashOrbitRadiusFactor + keyExtent / 2;

  Widget createTestWidget(double value, {double textScale = 1.0}) {
    return L10nTestApp(
      child: TextScaledBox(
        textScale: textScale,
        child: Center(
          child: SplashOrbitWidget(
            animation: AlwaysStoppedAnimation(value),
            tileExtent: tileExtent,
          ),
        ),
      ),
    );
  }

  List<Offset> readKeyCenters(WidgetTester tester) {
    return tester
        .widgetList(find.byType(SplashKeyWidget))
        .map((key) => tester.getCenter(find.byWidget(key)))
        .toList();
  }

  List<double> readDistancesFromCenter(WidgetTester tester) {
    final center = tester.getCenter(find.byType(SplashOrbitWidget));
    return readKeyCenters(
      tester,
    ).map((keyCenter) => (keyCenter - center).distance).toList();
  }

  group('SplashOrbitWidget', () {
    testWidgets('renderiza uma tecla para cada símbolo', (tester) async {
      await tester.pumpWidget(createTestWidget(0.5));

      expect(
        find.byType(SplashKeyWidget),
        findsNWidgets(SplashSymbol.values.length),
      );
    });

    testWidgets('ocupa um quadrado com o dobro do raio da órbita', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(0.5));

      expect(
        tester.getSize(find.byType(SplashOrbitWidget)),
        const Size(radius * 2, radius * 2),
      );
    });

    testWidgets('as teclas começam todas no centro', (tester) async {
      await tester.pumpWidget(createTestWidget(0.0));

      for (final distance in readDistancesFromCenter(tester)) {
        expect(distance, closeTo(0.0, 0.0001));
      }
    });

    testWidgets('depois da explosão as teclas ficam afastadas do centro', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(0.5));

      for (final distance in readDistancesFromCenter(tester)) {
        expect(distance, greaterThan(0.0));
        expect(
          distance,
          closeTo(radius, AppSizes.splashKeyFloatAmplitude + 0.01),
        );
      }
    });

    testWidgets('as teclas ocupam posições distintas', (tester) async {
      await tester.pumpWidget(createTestWidget(0.5));

      expect(readKeyCenters(tester).toSet(), hasLength(6));
    });

    testWidgets('na saída as teclas voltam ao centro', (tester) async {
      await tester.pumpWidget(createTestWidget(1.0));

      for (final distance in readDistancesFromCenter(tester)) {
        expect(distance, closeTo(0.0, 0.0001));
      }
    });

    testWidgets('cabe em 320x568 com texto ampliado sem overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestWidget(0.5, textScale: 1.5));

      expect(tester.takeException(), isNull);
    });
  });
}
