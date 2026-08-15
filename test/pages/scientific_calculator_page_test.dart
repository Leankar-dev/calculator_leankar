import 'package:calculator_05122025/pages/scientific_calculator_page.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:calculator_05122025/widgets/history_bottom_sheet.dart';
import 'package:calculator_05122025/widgets/scientific/scientific_keypad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget() {
    return const L10nTestApp(child: ScientificCalculatorPage());
  }

  Finder findInDisplay(String text) {
    return find.descendant(
      of: find.byType(CalculatorDisplayWidget),
      matching: find.text(text),
    );
  }

  Finder findButton(String text) {
    return find.descendant(
      of: find.byType(ScientificKeypadWidget),
      matching: find.text(text),
    );
  }

  Future<void> tapButton(WidgetTester tester, String text) async {
    final finder = findButton(text);
    await tester.ensureVisible(finder);
    await tester.pump();
    await tester.tap(finder);
    await tester.pump();
  }

  group('ScientificCalculatorPage', () {
    testWidgets('deve renderizar CalculatorDisplayWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorDisplayWidget), findsOneWidget);
    });

    testWidgets('deve renderizar ScientificKeypadWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ScientificKeypadWidget), findsOneWidget);
    });

    testWidgets('deve exibir título "Calculadora Científica"', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Calculadora Científica'), findsOneWidget);
    });

    testWidgets('deve exibir botão de voltar na AppBar', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('deve exibir "0" inicialmente no resultado', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(findInDisplay('0'), findsOneWidget);
    });

    testWidgets('deve atualizar o resultado ao pressionar número', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tapButton(tester, '5');
      await tester.pumpAndSettle();

      expect(findInDisplay('5'), findsOneWidget);
    });

    testWidgets('deve calcular uma expressão simples com o teclado na tela', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tapButton(tester, '2');
      await tapButton(tester, '+');
      await tapButton(tester, '3');
      await tapButton(tester, '=');
      await tester.pumpAndSettle();

      expect(findInDisplay('5'), findsOneWidget);
    });

    testWidgets('deve avaliar sin(30) tocando os botões científicos', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final sinButton = find.byKey(const ValueKey('scientific_sin'));
      await tester.ensureVisible(sinButton);
      await tester.tap(sinButton);
      await tester.pump();

      await tapButton(tester, '3');
      await tapButton(tester, '0');

      final closeParenButton = find.byKey(
        const ValueKey('scientific_close_paren'),
      );
      await tester.ensureVisible(closeParenButton);
      await tester.tap(closeParenButton);
      await tester.pumpAndSettle();

      expect(findInDisplay('0,5'), findsOneWidget);
    });

    testWidgets('teclado físico: dígito numérico atualiza o resultado', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.digit7);
      await tester.pumpAndSettle();

      expect(findInDisplay('7'), findsOneWidget);
    });

    testWidgets('teclado físico: Escape limpa a expressão', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.digit7);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(findInDisplay('0'), findsOneWidget);
    });

    testWidgets('deve exibir botão de histórico na AppBar', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    testWidgets('deve abrir o bottom sheet de histórico ao tocar no ícone', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryBottomSheet), findsOneWidget);
    });
  });
}
