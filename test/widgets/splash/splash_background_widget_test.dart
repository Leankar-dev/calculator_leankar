import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/widgets/splash/splash_background_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget(double value) {
    return L10nTestApp(
      child: SplashBackgroundWidget(animation: AlwaysStoppedAnimation(value)),
    );
  }

  LinearGradient readGradient(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(SplashBackgroundWidget),
        matching: find.byType(DecoratedBox),
      ),
    );
    return (box.decoration as BoxDecoration).gradient! as LinearGradient;
  }

  group('SplashBackgroundWidget', () {
    testWidgets('começa com a cor plana da splash nativa', (tester) async {
      await tester.pumpWidget(createTestWidget(0.0));

      final gradient = readGradient(tester);

      expect(gradient.colors.first, AppColors.splashNativeFlat);
      expect(gradient.colors.last, AppColors.splashNativeFlat);
    });

    testWidgets('termina com o gradiente completo', (tester) async {
      await tester.pumpWidget(createTestWidget(1.0));

      final gradient = readGradient(tester);

      expect(gradient.colors.first, AppColors.splashGradientStart);
      expect(gradient.colors.last, AppColors.splashGradientEnd);
    });

    testWidgets('o gradiente vai do canto superior esquerdo ao inferior', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(1.0));

      final gradient = readGradient(tester);

      expect(gradient.begin, Alignment.topLeft);
      expect(gradient.end, Alignment.bottomRight);
    });

    testWidgets('preenche todo o espaço disponível', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestWidget(0.5));

      expect(
        tester.getSize(find.byType(SplashBackgroundWidget)),
        const Size(320, 568),
      );
    });
  });
}
