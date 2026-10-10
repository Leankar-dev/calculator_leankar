import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/splash/splash_logo_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';

void main() {
  const logoWidth = 200.0;
  const startScale = 0.8;

  Widget createTestWidget(double value) {
    return L10nTestApp(
      child: Center(
        child: SplashLogoWidget(
          animation: AlwaysStoppedAnimation(value),
          logoWidth: logoWidth,
          startScale: startScale,
        ),
      ),
    );
  }

  double readScale(WidgetTester tester) {
    final transform = tester.widget<Transform>(
      find
          .descendant(
            of: find.byType(SplashLogoWidget),
            matching: find.byType(Transform),
          )
          .first,
    );
    return transform.transform.entry(0, 0);
  }

  group('SplashLogoWidget', () {
    testWidgets('começa com a escala inicial', (tester) async {
      await tester.pumpWidget(createTestWidget(0.0));

      expect(readScale(tester), closeTo(startScale, 0.0001));
    });

    testWidgets('fica em escala normal entre a chegada e a saída', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(0.5));

      expect(readScale(tester), closeTo(1.0, 0.0001));
    });

    testWidgets('termina com a escala de saída', (tester) async {
      await tester.pumpWidget(createTestWidget(1.0));

      expect(readScale(tester), closeTo(AppSizes.splashLogoExitScale, 0.0001));
    });

    testWidgets('a escala muda durante o aperto da tecla', (tester) async {
      await tester.pumpWidget(createTestWidget(0.17));
      final pressed = readScale(tester);

      await tester.pumpWidget(createTestWidget(0.5));
      final settled = readScale(tester);

      expect(pressed, isNot(closeTo(settled, 0.0001)));
    });

    testWidgets('usa o asset do logo da splash com a largura pedida', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(0.5));

      final image = tester.widget<Image>(find.byType(Image));

      expect(
        (image.image as AssetImage).assetName,
        AppStrings.splashLogoAssetPath,
      );
      expect(image.width, logoWidth);
      expect(image.gaplessPlayback, isTrue);
      expect(image.excludeFromSemantics, isTrue);
    });

    testWidgets('envolve a imagem no brilho diagonal', (tester) async {
      await tester.pumpWidget(createTestWidget(0.5));

      expect(find.byType(ShaderMask), findsOneWidget);
    });
  });
}
