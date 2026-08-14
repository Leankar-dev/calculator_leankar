import 'package:calculator_05122025/widgets/scientific/memory_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget({
    bool hasMemoryValue = true,
    VoidCallback? onMemoryAdd,
    VoidCallback? onMemorySubtract,
    VoidCallback? onMemoryRecall,
    VoidCallback? onMemoryClear,
  }) {
    return L10nTestApp(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: MemoryRowWidget(
                hasMemoryValue: hasMemoryValue,
                onMemoryAdd: onMemoryAdd ?? () {},
                onMemorySubtract: onMemorySubtract ?? () {},
                onMemoryRecall: onMemoryRecall ?? () {},
                onMemoryClear: onMemoryClear ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  group('MemoryRowWidget', () {
    testWidgets('mostra M+, M-, MR, MC', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('M+'), findsOneWidget);
      expect(find.text('M-'), findsOneWidget);
      expect(find.text('MR'), findsOneWidget);
      expect(find.text('MC'), findsOneWidget);
    });

    testWidgets('M+ chama onMemoryAdd', (tester) async {
      var called = false;
      await tester.pumpWidget(
        createTestWidget(onMemoryAdd: () => called = true),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_memory_add')));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets('M- chama onMemorySubtract', (tester) async {
      var called = false;
      await tester.pumpWidget(
        createTestWidget(onMemorySubtract: () => called = true),
      );
      await tester.tap(
        find.byKey(const ValueKey('scientific_memory_subtract')),
      );
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets('MR chama onMemoryRecall quando hasMemoryValue é true', (
      tester,
    ) async {
      var called = false;
      await tester.pumpWidget(
        createTestWidget(
          hasMemoryValue: true,
          onMemoryRecall: () => called = true,
        ),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_memory_recall')));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets(
      'MR não chama onMemoryRecall quando hasMemoryValue é false',
      (tester) async {
        var called = false;
        await tester.pumpWidget(
          createTestWidget(
            hasMemoryValue: false,
            onMemoryRecall: () => called = true,
          ),
        );
        await tester.tap(
          find.byKey(const ValueKey('scientific_memory_recall')),
        );
        await tester.pumpAndSettle();
        expect(called, isFalse);
      },
    );

    testWidgets(
      'MC não chama onMemoryClear quando hasMemoryValue é false',
      (tester) async {
        var called = false;
        await tester.pumpWidget(
          createTestWidget(
            hasMemoryValue: false,
            onMemoryClear: () => called = true,
          ),
        );
        await tester.tap(find.byKey(const ValueKey('scientific_memory_clear')));
        await tester.pumpAndSettle();
        expect(called, isFalse);
      },
    );
  });
}
