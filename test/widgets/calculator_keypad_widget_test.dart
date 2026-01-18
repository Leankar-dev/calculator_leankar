import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<String> pressedNumbers;
  late List<OperationsType> pressedOperations;
  late bool clearPressed;
  late bool backspacePressed;
  late bool percentagePressed;
  late bool decimalPressed;
  late bool calculatePressed;

  setUp(() {
    pressedNumbers = [];
    pressedOperations = [];
    clearPressed = false;
    backspacePressed = false;
    percentagePressed = false;
    decimalPressed = false;
    calculatePressed = false;
  });

  Widget createTestWidget() {
    return NeumorphicApp(
      home: Scaffold(
        body: CalculatorKeypadWidget(
          onClear: () => clearPressed = true,
          onBackspace: () => backspacePressed = true,
          onPercentage: () => percentagePressed = true,
          onDecimal: () => decimalPressed = true,
          onCalculate: () => calculatePressed = true,
          onNumberPressed: (number) => pressedNumbers.add(number),
          onOperationPressed: (operation) => pressedOperations.add(operation),
        ),
      ),
    );
  }

  group('CalculatorKeypadWidget', () {
    testWidgets('deve renderizar todos os botões numéricos', (tester) async {
      await tester.pumpWidget(createTestWidget());

      for (var i = 0; i <= 9; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
    });

    testWidgets('deve renderizar botões de operação', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('\u{00F7}'), findsOneWidget); // divisão
      expect(find.text('\u{00D7}'), findsOneWidget); // multiplicação
      expect(find.text('\u{002D}'), findsOneWidget); // subtração
      expect(find.text('\u{002B}'), findsOneWidget); // adição
    });

    testWidgets('deve renderizar botões especiais', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('C'), findsOneWidget);
      expect(find.text('\u{232B}'), findsOneWidget); // backspace
      expect(find.text('\u{0025}'), findsOneWidget); // porcentagem
      expect(find.text(','), findsOneWidget);
      expect(find.text('='), findsOneWidget);
    });

    testWidgets('deve chamar onNumberPressed ao pressionar número', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      expect(pressedNumbers, contains('5'));
    });

    testWidgets('deve chamar onClear ao pressionar C', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('C'));
      await tester.pumpAndSettle();

      expect(clearPressed, isTrue);
    });

    testWidgets('deve chamar onBackspace ao pressionar backspace', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('\u{232B}'));
      await tester.pumpAndSettle();

      expect(backspacePressed, isTrue);
    });

    testWidgets('deve chamar onPercentage ao pressionar %', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('\u{0025}'));
      await tester.pumpAndSettle();

      expect(percentagePressed, isTrue);
    });

    testWidgets('deve chamar onDecimal ao pressionar vírgula', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text(','));
      await tester.pumpAndSettle();

      expect(decimalPressed, isTrue);
    });

    testWidgets('deve chamar onCalculate ao pressionar =', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      expect(calculatePressed, isTrue);
    });

    testWidgets('deve chamar onOperationPressed para divisão', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('\u{00F7}'));
      await tester.pumpAndSettle();

      expect(pressedOperations, contains(OperationsType.division));
    });

    testWidgets('deve chamar onOperationPressed para multiplicação', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('\u{00D7}'));
      await tester.pumpAndSettle();

      expect(pressedOperations, contains(OperationsType.multiplication));
    });

    testWidgets('deve chamar onOperationPressed para subtração', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('\u{002D}'));
      await tester.pumpAndSettle();

      expect(pressedOperations, contains(OperationsType.subtraction));
    });

    testWidgets('deve chamar onOperationPressed para adição', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('\u{002B}'));
      await tester.pumpAndSettle();

      expect(pressedOperations, contains(OperationsType.addition));
    });

    testWidgets('deve conter ButtonWidgets', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ButtonWidget), findsWidgets);
    });

    testWidgets('deve permitir pressionar múltiplos números em sequência', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();

      expect(pressedNumbers, ['1', '2', '3']);
    });
  });
}
