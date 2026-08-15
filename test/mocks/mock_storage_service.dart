import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/services/storage_service.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';

class MockStorageService extends StorageService {
  final Map<String, List<CalculationHistory>> _historyByKey = {};
  bool shouldFail = false;

  @override
  Future<Result<bool>> saveHistory(
    List<CalculationHistory> history, {
    String key = AppStrings.prefHistoryKey,
  }) async {
    if (shouldFail) {
      return Result.failure(ErrorType.historySaveError, 'Mock save error');
    }
    _historyByKey[key] = List.from(history);
    return Result.success(true);
  }

  @override
  Future<Result<List<CalculationHistory>>> loadHistory({
    String key = AppStrings.prefHistoryKey,
  }) async {
    if (shouldFail) {
      return Result.failure(ErrorType.historyLoadError, 'Mock load error');
    }
    return Result.success(List.from(_historyByKey[key] ?? const []));
  }

  @override
  Future<Result<bool>> clearHistory({
    String key = AppStrings.prefHistoryKey,
  }) async {
    if (shouldFail) {
      return Result.failure(ErrorType.historyClearError, 'Mock clear error');
    }
    _historyByKey[key]?.clear();
    return Result.success(true);
  }
}
