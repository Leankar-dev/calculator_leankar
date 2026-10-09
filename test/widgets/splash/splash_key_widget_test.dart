import 'package:calculator_05122025/utils/enums/splash_symbol.dart';
import 'package:calculator_05122025/widgets/splash/splash_key_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';

void main() {
  const extent = 40.0;

  Widget createTestWidget(SplashSymbol symbol) {
    return L10nTestApp(
      child: Center(
        child: SplashKeyWidget(symbol: symbol, extent: extent),
      ),
    );
  }

  group('SplashKeyWidget', () {
    for (final symbol in SplashSymbol.values) {
      testWidgets('mostra o rótulo de ${symbol.name}', (tester) async {
        await tester.pumpWidget(createTestWidget(symbol));

        expect(find.text(symbol.label), findsOneWidget);
      });

      testWidgets('${symbol.name} tem o lado pedido', (tester) async {
        await tester.pumpWidget(createTestWidget(symbol));

        expect(
          tester.getSize(find.byType(SplashKeyWidget)),
          const Size(extent, extent),
        );
      });

      testWidgets('${symbol.name} usa a cor do símbolo no texto', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(symbol));

        final text = tester.widget<Text>(find.text(symbol.label));

        expect(text.style?.color, symbol.color);
        expect(text.style?.fontWeight, FontWeight.bold);
      });
    }

    testWidgets('é decorativa e fica fora da árvore de semântica', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(SplashSymbol.addition));

      expect(
        find.descendant(
          of: find.byType(SplashKeyWidget),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
    });

    testWidgets('desenha as duas sombras neumórficas', (tester) async {
      await tester.pumpWidget(createTestWidget(SplashSymbol.percent));

      final box = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(SplashKeyWidget),
          matching: find.byType(DecoratedBox),
        ),
      );
      final shadows = (box.decoration as BoxDecoration).boxShadow!;

      expect(shadows, hasLength(2));
      expect(shadows.first.offset.dx, greaterThan(0));
      expect(shadows.last.offset.dx, lessThan(0));
    });
  });
}
