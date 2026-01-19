import 'package:calculator_05122025/pages/calculator_page.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget() {
    return const NeumorphicApp(
      home: CalculatorPage(),
    );
  }

  Finder findInDisplay(String text) {
    return find.descendant(
      of: find.byType(CalculatorDisplayWidget),
      matching: find.text(text),
    );
  }

  group('CalculatorPage', () {
    testWidgets('deve renderizar CalculatorDisplayWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorDisplayWidget), findsOneWidget);
    });

    testWidgets('deve renderizar CalculatorKeypadWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CalculatorKeypadWidget), findsOneWidget);
    });

    testWidgets('deve exibir título "Calculator"', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Calculator'), findsOneWidget);
    });

    testWidgets('deve exibir "0" inicialmente no display', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(findInDisplay('0'), findsOneWidget);
    });

    testWidgets('deve atualizar display ao pressionar número', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      expect(findInDisplay('5'), findsOneWidget);
    });

    testWidgets('deve realizar operação de adição', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('8'));
      await tester.pumpAndSettle();

      final addButton = find.text('\u{002B}');
      await tester.ensureVisible(addButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();

      final equalsButton = find.text('=');
      await tester.ensureVisible(equalsButton);
      await tester.pumpAndSettle();
      await tester.tap(equalsButton);
      await tester.pumpAndSettle();

      expect(findInDisplay('10'), findsOneWidget);
    });

    testWidgets('deve realizar operação de subtração', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('9'));
      await tester.pumpAndSettle();

      final subButton = find.text('\u{002D}');
      await tester.ensureVisible(subButton);
      await tester.pumpAndSettle();
      await tester.tap(subButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();

      final equalsButton = find.text('=');
      await tester.ensureVisible(equalsButton);
      await tester.pumpAndSettle();
      await tester.tap(equalsButton);
      await tester.pumpAndSettle();

      expect(findInDisplay('5'), findsOneWidget);
    });

    testWidgets('deve realizar operação de multiplicação', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('6'));
      await tester.pumpAndSettle();

      final mulButton = find.text('\u{00D7}');
      await tester.ensureVisible(mulButton);
      await tester.pumpAndSettle();
      await tester.tap(mulButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('7'));
      await tester.pumpAndSettle();

      final equalsButton = find.text('=');
      await tester.ensureVisible(equalsButton);
      await tester.pumpAndSettle();
      await tester.tap(equalsButton);
      await tester.pumpAndSettle();

      expect(findInDisplay('42'), findsOneWidget);
    });

    testWidgets('deve realizar operação de divisão', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('8'));
      await tester.pumpAndSettle();

      final divButton = find.text('\u{00F7}');
      await tester.ensureVisible(divButton);
      await tester.pumpAndSettle();
      await tester.tap(divButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();

      final equalsButton = find.text('=');
      await tester.ensureVisible(equalsButton);
      await tester.pumpAndSettle();
      await tester.tap(equalsButton);
      await tester.pumpAndSettle();

      expect(findInDisplay('4'), findsOneWidget);
    });

    testWidgets('deve limpar display ao pressionar C', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C'));
      await tester.pumpAndSettle();

      expect(findInDisplay('0'), findsOneWidget);
    });

    testWidgets('deve apagar último dígito com backspace', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('\u{232B}')); // backspace
      await tester.pumpAndSettle();

      expect(findInDisplay('12'), findsOneWidget);
    });

    testWidgets('deve adicionar vírgula decimal', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();

      final commaButton = find.text(',');
      await tester.ensureVisible(commaButton);
      await tester.pumpAndSettle();
      await tester.tap(commaButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();

      expect(findInDisplay('3,14'), findsOneWidget);
    });

    testWidgets('deve mostrar erro na divisão por zero', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      final divButton = find.text('\u{00F7}');
      await tester.ensureVisible(divButton);
      await tester.pumpAndSettle();
      await tester.tap(divButton);
      await tester.pumpAndSettle();

      final zeroButton = find.text('0');
      await tester.ensureVisible(zeroButton);
      await tester.pumpAndSettle();
      await tester.tap(zeroButton);
      await tester.pumpAndSettle();

      final equalsButton = find.text('=');
      await tester.ensureVisible(equalsButton);
      await tester.pumpAndSettle();
      await tester.tap(equalsButton);
      await tester.pumpAndSettle();

      expect(findInDisplay('Erro'), findsOneWidget);
    });

    testWidgets('deve calcular porcentagem', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      final zeroButton = find.text('0');
      await tester.ensureVisible(zeroButton);
      await tester.pumpAndSettle();
      await tester.tap(zeroButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{0025}')); // %
      await tester.pumpAndSettle();

      expect(findInDisplay('0,5'), findsOneWidget);
    });

    testWidgets('deve exibir expressão durante operação', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      final addButton = find.text('\u{002B}');
      await tester.ensureVisible(addButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(findInDisplay('5 +'), findsOneWidget);
    });

    group('Entrada por teclado', () {
      testWidgets('deve aceitar entrada de números pelo teclado', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.digit7);
        await tester.pumpAndSettle();

        expect(findInDisplay('7'), findsOneWidget);
      });

      testWidgets('deve aceitar Enter para calcular', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.text('5'));
        await tester.pumpAndSettle();

        final addButton = find.text('\u{002B}');
        await tester.ensureVisible(addButton);
        await tester.pumpAndSettle();
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        await tester.tap(find.text('3'));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(findInDisplay('8'), findsOneWidget);
      });

      testWidgets('deve aceitar Escape para limpar', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.text('9'));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(findInDisplay('0'), findsOneWidget);
      });

      testWidgets('deve aceitar Backspace para apagar', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.text('1'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('2'));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();

        expect(findInDisplay('1'), findsOneWidget);
      });
    });
  });
}
