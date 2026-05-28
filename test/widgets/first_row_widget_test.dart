import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/first_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget({
    VoidCallback? onClear,
    VoidCallback? onBackspace,
    VoidCallback? onPercentage,
  }) {
    return L10nTestApp(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: FirstRowWidget(
                onClear: onClear ?? () {},
                onBackspace: onBackspace ?? () {},
                onPercentage: onPercentage ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  group('FirstRowWidget', () {
    testWidgets('deve exibir botão C', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('deve exibir botão backspace', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text(AppStrings.backspaceSymbol), findsOneWidget);
    });

    testWidgets('deve exibir botão de porcentagem', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text(AppStrings.percentSymbol), findsOneWidget);
    });

    testWidgets('deve chamar onClear ao pressionar C', (tester) async {
      bool called = false;

      await tester.pumpWidget(createTestWidget(onClear: () => called = true));

      await tester.tap(find.text('C'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('deve chamar onBackspace ao pressionar backspace', (
      tester,
    ) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(onBackspace: () => called = true),
      );

      await tester.tap(find.text(AppStrings.backspaceSymbol));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('deve chamar onPercentage ao pressionar %', (tester) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(onPercentage: () => called = true),
      );

      await tester.tap(find.text(AppStrings.percentSymbol));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });
  });
}
