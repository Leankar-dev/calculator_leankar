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
        expect(NumberFormatter.format(double.nan), 'NaN');
      });

      test('deve tratar Infinity', () {
        expect(NumberFormatter.format(double.infinity), '∞');
        expect(NumberFormatter.format(double.negativeInfinity), '-∞');
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

      test(
        'deve interpretar ponto como decimal quando inequívoco (formato internacional)',
        () {
          expect(NumberFormatter.parse('3.14'), 3.14);
          expect(NumberFormatter.parse('19.99'), 19.99);
          expect(NumberFormatter.parse('0.5'), 0.5);
          expect(NumberFormatter.parse('-3.14'), -3.14);
        },
      );

      test(
        'deve continuar interpretando ponto como milhar quando ambíguo (3 dígitos após)',
        () {
          expect(NumberFormatter.parse('1.234'), 1234);
          expect(NumberFormatter.parse('12.345,67'), 12345.67);
        },
      );
      test(
        'deve interpretar ponto como decimal quando a parte inteira começa com zero ou tem mais de 3 dígitos',
        () {
          expect(NumberFormatter.parse('0.123'), 0.123);
          expect(NumberFormatter.parse('-0.123'), -0.123);
          expect(NumberFormatter.parse('1234.567'), 1234.567);
        },
      );

      test('deve aceitar vírgula decimal sem dígitos após ela', () {
        expect(NumberFormatter.parse('5,'), 5);
      });

      test('deve retornar null para valores não finitos', () {
        expect(NumberFormatter.parse('NaN'), isNull);
        expect(NumberFormatter.parse('Infinity'), isNull);
        expect(NumberFormatter.parse('1e999'), isNull);
      });
    });

    group('format em notação científica', () {
      test(
        'deve formatar potências exatas de dez sem arredondar o expoente',
        () {
          expect(NumberFormatter.format(1e12), '1e12');
          expect(NumberFormatter.format(1e13), '1e13');
          expect(NumberFormatter.format(1e15), '1e15');
          expect(NumberFormatter.format(1e100), '1e100');
        },
      );

      test('deve formatar mantissa decimal com vírgula', () {
        expect(NumberFormatter.format(1.5e12), '1,5e12');
        expect(NumberFormatter.format(-2.5e-7), '-2,5e-7');
      });

      test('deve formatar o menor número positivo representável', () {
        expect(NumberFormatter.format(5e-324), '4,9407e-324');
      });
    });

    group('toCanonicalString', () {
      test('deve escrever inteiros sem casas decimais', () {
        expect(NumberFormatter.toCanonicalString(42), '42');
        expect(NumberFormatter.toCanonicalString(-7), '-7');
        expect(NumberFormatter.toCanonicalString(-0.0), '0');
      });

      test('deve escrever decimais com vírgula', () {
        expect(NumberFormatter.toCanonicalString(0.5), '0,5');
      });

      test(
        'deve preservar inteiros acima do limite de 64 bits sem saturar',
        () {
          expect(
            NumberFormatter.toCanonicalString(1e19),
            '10000000000000000000',
          );
          expect(NumberFormatter.toCanonicalString(1e21), '1e+21');
        },
      );

      test('deve produzir texto que o parse converte de volta', () {
        for (final value in [0.1, 1e-7, 123456.789, 1e19, 1e25, -3.5e-9]) {
          final canonical = NumberFormatter.toCanonicalString(value);
          expect(NumberFormatter.parse(canonical), value);
        }
      });
    });
  });
}
