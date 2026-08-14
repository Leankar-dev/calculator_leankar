import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/widgets/scientific/log_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget({
    bool isShiftActive = false,
    void Function(ScientificFunctionType)? onFunction,
    void Function(String)? onBinaryOperator,
  }) {
    return L10nTestApp(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: LogRowWidget(
                isShiftActive: isShiftActive,
                onFunction: onFunction ?? (_) {},
                onBinaryOperator: onBinaryOperator ?? (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  group('LogRowWidget', () {
    testWidgets('modo normal mostra log, ln, n!, √', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('log'), findsOneWidget);
      expect(find.text('ln'), findsOneWidget);
      expect(find.text('n!'), findsOneWidget);
      expect(find.text('√'), findsOneWidget);
    });

    testWidgets('modo SHIFT mostra 10^x, e^x, nPr, ³√', (tester) async {
      await tester.pumpWidget(createTestWidget(isShiftActive: true));
      expect(find.text('10^x'), findsOneWidget);
      expect(find.text('e^x'), findsOneWidget);
      expect(find.text('nPr'), findsOneWidget);
      expect(find.text('³√'), findsOneWidget);
    });

    testWidgets('log normal chama onFunction com log', (tester) async {
      ScientificFunctionType? received;
      await tester.pumpWidget(
        createTestWidget(onFunction: (f) => received = f),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_log_or_exp10')));
      await tester.pumpAndSettle();
      expect(received, ScientificFunctionType.log);
    });

    testWidgets('10^x em SHIFT chama onFunction com exp10', (tester) async {
      ScientificFunctionType? received;
      await tester.pumpWidget(
        createTestWidget(isShiftActive: true, onFunction: (f) => received = f),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_log_or_exp10')));
      await tester.pumpAndSettle();
      expect(received, ScientificFunctionType.exp10);
    });

    testWidgets('n! normal chama onFunction com factorial', (tester) async {
      ScientificFunctionType? received;
      await tester.pumpWidget(
        createTestWidget(onFunction: (f) => received = f),
      );
      await tester.tap(
        find.byKey(const ValueKey('scientific_factorial_or_npr')),
      );
      await tester.pumpAndSettle();
      expect(received, ScientificFunctionType.factorial);
    });

    testWidgets('nPr em SHIFT chama onBinaryOperator com P', (tester) async {
      String? received;
      await tester.pumpWidget(
        createTestWidget(
          isShiftActive: true,
          onBinaryOperator: (op) => received = op,
        ),
      );
      await tester.tap(
        find.byKey(const ValueKey('scientific_factorial_or_npr')),
      );
      await tester.pumpAndSettle();
      expect(received, 'P');
    });
  });
}
