import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _historyKey = AppStrings.prefHistoryKey;

  Future<Result<bool>> saveHistory(
    List<CalculationHistory> history, {
    String key = _historyKey,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = CalculationHistory.encodeList(history);
      final success = await prefs.setString(key, jsonString);

      if (success) {
        logger.logStorage(
          'Histórico salvo',
          details: '${history.length} itens',
        );
        return Result.success(true);
      } else {
        logger.logStorage('Salvar histórico', success: false);
        return Result.failure(ErrorType.historySaveError);
      }
    } catch (e, stackTrace) {
      logger.logError(
        ErrorType.historySaveError,
        tag: 'StorageService',
        details: e.toString(),
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(ErrorType.historySaveError, e.toString());
    }
  }

  Future<Result<List<CalculationHistory>>> loadHistory({
    String key = _historyKey,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(key);

      if (jsonString == null || jsonString.isEmpty) {
        logger.logStorage('Histórico carregado', details: 'Vazio');
        return Result.success([]);
      }

      final result = CalculationHistory.decodeList(jsonString);

      if (result.isSuccess) {
        logger.logStorage(
          'Histórico carregado',
          details: '${result.value.length} itens',
        );
        return Result.success(result.value);
      } else {
        logger.warning(
          'Dados corrompidos detectados, limpando histórico',
          tag: 'StorageService',
        );
        await _clearCorruptedData(prefs, key);
        return Result.failure(result.error!, result.errorDetails);
      }
    } catch (e, stackTrace) {
      logger.logError(
        ErrorType.historyLoadError,
        tag: 'StorageService',
        details: e.toString(),
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(ErrorType.historyLoadError, e.toString());
    }
  }

  Future<Result<bool>> clearHistory({String key = _historyKey}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(key);

      if (success) {
        logger.logStorage('Histórico limpo');
        return Result.success(true);
      } else {
        logger.logStorage('Limpar histórico', success: false);
        return Result.failure(ErrorType.historyClearError);
      }
    } catch (e, stackTrace) {
      logger.logError(
        ErrorType.historyClearError,
        tag: 'StorageService',
        details: e.toString(),
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(ErrorType.historyClearError, e.toString());
    }
  }

  Future<void> _clearCorruptedData(SharedPreferences prefs, String key) async {
    try {
      await prefs.remove(key);
      logger.debug('Dados corrompidos removidos', tag: 'StorageService');
    } catch (e) {
      logger.warning(
        'Falha ao remover dados corrompidos: $e',
        tag: 'StorageService',
      );
    }
  }
}
