import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';

extension CalculationHistoryListExtension on List<CalculationHistory> {
  List<CalculationHistory> withEntryAtFront(CalculationHistory entry) {
    final updated = [entry, ...this];
    if (updated.length <= AppSizes.maxHistoryItems) {
      return updated;
    }
    return updated.sublist(0, AppSizes.maxHistoryItems);
  }
}
