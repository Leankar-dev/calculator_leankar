import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/widgets/scientific/paren_power_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget({
    bool isShiftActive = false,
    VoidCallback? onOpenParen,
    VoidCallback? onCloseParen,
    void Function(ScientificFunctionType)? onFunction,
  }) {
    return L10nTestApp(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: ParenPowerRowWidget(
                isShiftActive: isShiftActive,
                onOpenParen: onOpenParen ?? () {},
                onCloseParen: onCloseParen ?? () {},
                onFunction: onFunction ?? (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  group('ParenPowerRowWidget', () {
    testWidgets('modo normal mostra (, ), x², 1/x', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('('), findsOneWidget);
      expect(find.text(')'), findsOneWidget);
      expect(find.text('x²'), findsOneWidget);
      expect(find.text('1/x'), findsOneWidget);
    });

    testWidgets('modo SHIFT mostra |x| e não mostra 1/x', (tester) async {
      await tester.pumpWidget(createTestWidget(isShiftActive: true));
      expect(find.text('|x|'), findsOneWidget);
      expect(find.text('1/x'), findsNothing);
    });

    testWidgets('( chama onOpenParen', (tester) async {
      var called = false;
      await tester.pumpWidget(
        createTestWidget(onOpenParen: () => called = true),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_open_paren')));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets(') chama onCloseParen', (tester) async {
      var called = false;
      await tester.pumpWidget(
        createTestWidget(onCloseParen: () => called = true),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_close_paren')));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets('x² normal chama onFunction com square', (tester) async {
      ScientificFunctionType? received;
      await tester.pumpWidget(
        createTestWidget(onFunction: (f) => received = f),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_square_or_abs')));
      await tester.pumpAndSettle();
      expect(received, ScientificFunctionType.square);
    });

    testWidgets('|x| em SHIFT chama onFunction com absoluteValue', (
      tester,
    ) async {
      ScientificFunctionType? received;
      await tester.pumpWidget(
        createTestWidget(isShiftActive: true, onFunction: (f) => received = f),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_square_or_abs')));
      await tester.pumpAndSettle();
      expect(received, ScientificFunctionType.absoluteValue);
    });

    testWidgets('1/x chama onFunction com reciprocal', (tester) async {
      ScientificFunctionType? received;
      await tester.pumpWidget(
        createTestWidget(onFunction: (f) => received = f),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_reciprocal')));
      await tester.pumpAndSettle();
      expect(received, ScientificFunctionType.reciprocal);
    });
  });
}
