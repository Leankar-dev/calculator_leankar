import 'package:calculator_05122025/utils/number_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumberFormatter', () {
    group('format', () {
      test('deve formatar número inteiro sem casas decimais', () {
        expect(NumberFormatter.format(42), '42');
        expect(NumberFormatter.format(0), '0');
        expect(NumberFormatter.format(-5), '-5');
      });

      test('deve formatar número com separador de milhares', () {
        expect(NumberFormatter.format(1000), '1.000');
        expect(NumberFormatter.format(1000000), '1.000.000');
        expect(NumberFormatter.format(999999999), '999.999.999');
      });

      test('deve formatar número decimal com vírgula', () {
        expect(NumberFormatter.format(3.14), '3,14');
        expect(NumberFormatter.format(0.5), '0,5');
        expect(NumberFormatter.format(1.25), '1,25');
      });

      test('deve remover zeros à direita após decimal', () {
        expect(NumberFormatter.format(1.50), '1,5');
        expect(NumberFormatter.format(2.100), '2,1');
        expect(NumberFormatter.format(3.000), '3');
      });

      test('deve formatar decimal com separador de milhares', () {
        expect(NumberFormatter.format(1234.56), '1.234,56');
        expect(NumberFormatter.format(1000000.99), '1.000.000,99');
      });

      test('deve usar notação científica para números muito pequenos', () {
        final result = NumberFormatter.format(0.0000001);
        expect(result.contains('e'), isTrue);
      });

      test('deve usar notação científica para números muito grandes', () {
        final result = NumberFormatter.format(1e13);
        expect(result.contains('e'), isTrue);
      });

      test('deve tratar NaN', () {
        expect(NumberFormatter.format(double.nan), 'Erro: Inválido');
      });

      test('deve tratar Infinity', () {
        expect(NumberFormatter.format(double.infinity), 'Erro: Infinito');
        expect(NumberFormatter.format(double.negativeInfinity), 'Erro: Infinito');
      });

      test('deve formatar números negativos com milhares', () {
        expect(NumberFormatter.format(-1000), '-1.000');
        expect(NumberFormatter.format(-1234567), '-1.234.567');
      });
    });

    group('parse', () {
      test('deve fazer parse de número simples', () {
        expect(NumberFormatter.parse('42'), 42);
        expect(NumberFormatter.parse('0'), 0);
        expect(NumberFormatter.parse('-5'), -5);
      });

      test('deve fazer parse de número com vírgula decimal', () {
        expect(NumberFormatter.parse('3,14'), 3.14);
        expect(NumberFormatter.parse('0,5'), 0.5);
      });

      test('deve fazer parse de número com separador de milhares', () {
        expect(NumberFormatter.parse('1.000'), 1000);
        expect(NumberFormatter.parse('1.000.000'), 1000000);
        expect(NumberFormatter.parse('999.999.999'), 999999999);
      });

      test('deve fazer parse de decimal com milhares', () {
        expect(NumberFormatter.parse('1.234,56'), 1234.56);
      });

      test('deve fazer parse de notação científica', () {
        expect(NumberFormatter.parse('1e5'), 100000);
        expect(NumberFormatter.parse('1,5e3'), 1500);
      });

      test('deve retornar null para string inválida', () {
        expect(NumberFormatter.parse('abc'), isNull);
        expect(NumberFormatter.parse(''), isNull);
      });

      test('deve fazer parse de número negativo', () {
        expect(NumberFormatter.parse('-1.000'), -1000);
        expect(NumberFormatter.parse('-3,14'), -3.14);
      });
    });

    group('isValidNumber', () {
      test('deve validar números válidos', () {
        expect(NumberFormatter.isValidNumber('42'), isTrue);
        expect(NumberFormatter.isValidNumber('3,14'), isTrue);
        expect(NumberFormatter.isValidNumber('1.000'), isTrue);
      });

      test('deve invalidar strings inválidas', () {
        expect(NumberFormatter.isValidNumber('abc'), isFalse);
        expect(NumberFormatter.isValidNumber(''), isFalse);
      });
    });

    group('formatForHistory', () {
      test('deve formatar texto numérico', () {
        expect(NumberFormatter.formatForHistory('1000'), '1.000');
      });

      test('deve retornar texto original se inválido', () {
        expect(NumberFormatter.formatForHistory('abc'), 'abc');
      });
    });
  });
}
