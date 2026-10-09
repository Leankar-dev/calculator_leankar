import 'package:calculator_05122025/widgets/splash/splash_shimmer_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';

void main() {
  const childKey = Key('shimmer-child');

  Widget createTestWidget(double value) {
    return L10nTestApp(
      child: Center(
        child: SplashShimmerWidget(
          animation: AlwaysStoppedAnimation(value),
          child: const SizedBox(key: childKey, width: 100, height: 50),
        ),
      ),
    );
  }

  group('SplashShimmerWidget', () {
    for (final value in [0.0, 0.6, 1.0]) {
      testWidgets('monta sem erro com animação em $value', (tester) async {
        await tester.pumpWidget(createTestWidget(value));

        expect(find.byKey(childKey), findsOneWidget);
        expect(find.byType(ShaderMask), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('não altera o tamanho do filho', (tester) async {
      await tester.pumpWidget(createTestWidget(0.6));

      expect(tester.getSize(find.byKey(childKey)), const Size(100, 50));
    });
  });
}
