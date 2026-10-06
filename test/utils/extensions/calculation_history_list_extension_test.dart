import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/extensions/calculation_history_list_extension.dart';
import 'package:flutter_test/flutter_test.dart';

CalculationHistory _entry(String label) => CalculationHistory(
  expression: label,
  result: label,
  timestamp: DateTime.utc(2026, 1, 1),
);

void main() {
  group('CalculationHistoryListExtension', () {
    test('coloca a nova entrada no início sem alterar a lista original', () {
      final original = [_entry('a'), _entry('b')];

      final updated = original.withEntryAtFront(_entry('novo'));

      expect(updated.map((e) => e.expression), ['novo', 'a', 'b']);
      expect(original.map((e) => e.expression), ['a', 'b']);
    });

    test('funciona com lista vazia', () {
      final updated = <CalculationHistory>[].withEntryAtFront(_entry('x'));

      expect(updated.map((e) => e.expression), ['x']);
    });

    test('descarta as entradas mais antigas acima do limite', () {
      final full = List.generate(
        AppSizes.maxHistoryItems,
        (index) => _entry('item$index'),
      );

      final updated = full.withEntryAtFront(_entry('novo'));

      expect(updated.length, AppSizes.maxHistoryItems);
      expect(updated.first.expression, 'novo');
      expect(
        updated.last.expression,
        'item${AppSizes.maxHistoryItems - 2}',
      );
    });
  });
}
