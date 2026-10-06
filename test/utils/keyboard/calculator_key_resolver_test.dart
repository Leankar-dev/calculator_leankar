import 'package:calculator_05122025/utils/enums/calculator_key_action.dart';
import 'package:calculator_05122025/utils/keyboard/calculator_key_resolver.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

KeyDownEvent _keyDown(LogicalKeyboardKey key, {String? character}) {
  return KeyDownEvent(
    physicalKey: PhysicalKeyboardKey.keyA,
    logicalKey: key,
    character: character,
    timeStamp: Duration.zero,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CalculatorKeyResolver', () {
    test('dígitos resolvem para digit', () {
      for (final digit in ['0', '5', '9']) {
        expect(
          CalculatorKeyResolver.resolve(
            _keyDown(LogicalKeyboardKey.digit1, character: digit),
          ),
          CalculatorKeyAction.digit,
        );
      }
    });

    test('Enter, Numpad Enter e "=" resolvem para calculate', () {
      expect(
        CalculatorKeyResolver.resolve(_keyDown(LogicalKeyboardKey.enter)),
        CalculatorKeyAction.calculate,
      );
      expect(
        CalculatorKeyResolver.resolve(_keyDown(LogicalKeyboardKey.numpadEnter)),
        CalculatorKeyAction.calculate,
      );
      expect(
        CalculatorKeyResolver.resolve(
          _keyDown(LogicalKeyboardKey.equal, character: '='),
        ),
        CalculatorKeyAction.calculate,
      );
    });

    test('Backspace resolve para backspace', () {
      expect(
        CalculatorKeyResolver.resolve(_keyDown(LogicalKeyboardKey.backspace)),
        CalculatorKeyAction.backspace,
      );
    });

    test('Escape e Delete resolvem para clear', () {
      expect(
        CalculatorKeyResolver.resolve(_keyDown(LogicalKeyboardKey.escape)),
        CalculatorKeyAction.clear,
      );
      expect(
        CalculatorKeyResolver.resolve(_keyDown(LogicalKeyboardKey.delete)),
        CalculatorKeyAction.clear,
      );
    });

    test('operadores resolvem para as ações aritméticas', () {
      final expectations = {
        '+': CalculatorKeyAction.add,
        '-': CalculatorKeyAction.subtract,
        '*': CalculatorKeyAction.multiply,
        'x': CalculatorKeyAction.multiply,
        'X': CalculatorKeyAction.multiply,
        '/': CalculatorKeyAction.divide,
      };
      expectations.forEach((character, expected) {
        expect(
          CalculatorKeyResolver.resolve(
            _keyDown(LogicalKeyboardKey.keyA, character: character),
          ),
          expected,
          reason: 'caractere "$character"',
        );
      });
    });

    test('vírgula e ponto resolvem para decimal', () {
      expect(
        CalculatorKeyResolver.resolve(
          _keyDown(LogicalKeyboardKey.comma, character: ','),
        ),
        CalculatorKeyAction.decimal,
      );
      expect(
        CalculatorKeyResolver.resolve(
          _keyDown(LogicalKeyboardKey.period, character: '.'),
        ),
        CalculatorKeyAction.decimal,
      );
    });

    test('teclas desconhecidas e sem caractere resolvem para null', () {
      expect(
        CalculatorKeyResolver.resolve(_keyDown(LogicalKeyboardKey.shiftLeft)),
        isNull,
      );
      expect(
        CalculatorKeyResolver.resolve(
          _keyDown(LogicalKeyboardKey.keyQ, character: 'q'),
        ),
        isNull,
      );
    });

    test('letras específicas de cada calculadora ficam para a página', () {
      for (final character in ['c', 'C', 's', '%', '(', '!', '^']) {
        expect(
          CalculatorKeyResolver.resolve(
            _keyDown(LogicalKeyboardKey.keyA, character: character),
          ),
          isNull,
          reason: 'caractere "$character"',
        );
      }
    });
  });
}
