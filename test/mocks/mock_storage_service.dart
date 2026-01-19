import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/services/storage_service.dart';

class MockStorageService extends StorageService {
  List<CalculationHistory> _history = [];

  @override
  Future<void> saveHistory(List<CalculationHistory> history) async {
    _history = List.from(history);
  }

  @override
  Future<List<CalculationHistory>> loadHistory() async {
    return List.from(_history);
  }

  @override
  Future<void> clearHistory() async {
    _history.clear();
  }
}
