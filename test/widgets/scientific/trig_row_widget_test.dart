import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/widgets/scientific/trig_row_widget.dart';
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
              child: TrigRowWidget(
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

  group('TrigRowWidget', () {
    testWidgets('modo normal mostra sin, cos, tan, xʸ', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('sin'), findsOneWidget);
      expect(find.text('cos'), findsOneWidget);
      expect(find.text('tan'), findsOneWidget);
      expect(find.text('xʸ'), findsOneWidget);
    });

    testWidgets('modo SHIFT mostra sin⁻¹, cos⁻¹, tan⁻¹, x³', (tester) async {
      await tester.pumpWidget(createTestWidget(isShiftActive: true));
      expect(find.text('sin⁻¹'), findsOneWidget);
      expect(find.text('cos⁻¹'), findsOneWidget);
      expect(find.text('tan⁻¹'), findsOneWidget);
      expect(find.text('x³'), findsOneWidget);
    });

    testWidgets('sin normal chama onFunction com ScientificFunctionType.sin', (
      tester,
    ) async {
      ScientificFunctionType? received;
      await tester.pumpWidget(
        createTestWidget(onFunction: (f) => received = f),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_sin')));
      await tester.pumpAndSettle();
      expect(received, ScientificFunctionType.sin);
    });

    testWidgets(
      'sin em SHIFT chama onFunction com ScientificFunctionType.asin',
      (tester) async {
        ScientificFunctionType? received;
        await tester.pumpWidget(
          createTestWidget(
            isShiftActive: true,
            onFunction: (f) => received = f,
          ),
        );
        await tester.tap(find.byKey(const ValueKey('scientific_sin')));
        await tester.pumpAndSettle();
        expect(received, ScientificFunctionType.asin);
      },
    );

    testWidgets('xʸ normal chama onBinaryOperator com ^', (tester) async {
      String? received;
      await tester.pumpWidget(
        createTestWidget(onBinaryOperator: (op) => received = op),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_power_or_cube')));
      await tester.pumpAndSettle();
      expect(received, '^');
    });

    testWidgets(
      'x³ em SHIFT chama onFunction com ScientificFunctionType.cube',
      (tester) async {
        ScientificFunctionType? received;
        await tester.pumpWidget(
          createTestWidget(
            isShiftActive: true,
            onFunction: (f) => received = f,
          ),
        );
        await tester.tap(
          find.byKey(const ValueKey('scientific_power_or_cube')),
        );
        await tester.pumpAndSettle();
        expect(received, ScientificFunctionType.cube);
      },
    );
  });
}
