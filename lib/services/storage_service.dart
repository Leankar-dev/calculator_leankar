import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _historyKey = 'calculation_history';

  Future<Result<bool>> saveHistory(List<CalculationHistory> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = CalculationHistory.encodeList(history);
      final success = await prefs.setString(_historyKey, jsonString);

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

  Future<Result<List<CalculationHistory>>> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_historyKey);

      if (jsonString == null || jsonString.isEmpty) {
        logger.logStorage('Histórico carregado', details: 'Vazio');
        return Result.success([]);
      }

      final result = CalculationHistory.decodeList(jsonString);

      return result.fold(
        onSuccess: (history) {
          logger.logStorage(
            'Histórico carregado',
            details: '${history.length} itens',
          );
          return Result.success(history);
        },
        onFailure: (error, details) {
          logger.warning(
            'Dados corrompidos detectados, limpando histórico',
            tag: 'StorageService',
          );
          _clearCorruptedData(prefs);
          return Result.failure(error, details);
        },
      );
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

  Future<Result<bool>> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(_historyKey);

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

  void _clearCorruptedData(SharedPreferences prefs) {
    try {
      prefs.remove(_historyKey);
    } catch (_) {}
  }
}
