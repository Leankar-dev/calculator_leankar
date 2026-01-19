import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/services/storage_service.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';

class MockStorageService extends StorageService {
  List<CalculationHistory> _history = [];
  bool shouldFail = false;

  @override
  Future<Result<bool>> saveHistory(List<CalculationHistory> history) async {
    if (shouldFail) {
      return Result.failure(ErrorType.historySaveError, 'Mock save error');
    }
    _history = List.from(history);
    return Result.success(true);
  }

  @override
  Future<Result<List<CalculationHistory>>> loadHistory() async {
    if (shouldFail) {
      return Result.failure(ErrorType.historyLoadError, 'Mock load error');
    }
    return Result.success(List.from(_history));
  }

  @override
  Future<Result<bool>> clearHistory() async {
    if (shouldFail) {
      return Result.failure(ErrorType.historyClearError, 'Mock clear error');
    }
    _history.clear();
    return Result.success(true);
  }
}
