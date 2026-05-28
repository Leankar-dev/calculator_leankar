import 'package:calculator_05122025/models/imc_result.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/enums/imc_error_type.dart';
import 'package:flutter/foundation.dart';

class ImcController extends ChangeNotifier {
  final LoggerService _logger;

  String _weightInput = '';
  String _heightInput = '';
  ImcResult? _result;
  ImcErrorType? _errorType;

  ImcController({LoggerService? logger})
    : _logger = logger ?? LoggerService.instance;

  String get weightInput => _weightInput;
  String get heightInput => _heightInput;
  ImcResult? get result => _result;
  ImcErrorType? get errorType => _errorType;
  bool get hasResult => _result != null;
  bool get hasError => _errorType != null;

  void setWeight(String value) {
    _weightInput = value;
    _result = null;
    _errorType = null;
    notifyListeners();
  }

  void setHeight(String value) {
    _heightInput = value;
    _result = null;
    _errorType = null;
    notifyListeners();
  }

  void calculate() {
    _errorType = null;

    final weight = double.tryParse(_weightInput.replaceAll(',', '.'));
    final height = double.tryParse(_heightInput.replaceAll(',', '.'));

    if (weight == null || weight <= 0 || weight > 500) {
      _errorType = ImcErrorType.invalidWeight;
      notifyListeners();
      return;
    }

    if (height == null || height < 50 || height > 250) {
      _errorType = ImcErrorType.invalidHeight;
      notifyListeners();
      return;
    }

    try {
      _result = ImcResult.calculate(weightKg: weight, heightCm: height);
      _logger.info(
        'IMC calculado: ${_result!.imc}',
        tag: 'ImcController',
      );
    } catch (e, stackTrace) {
      _errorType = ImcErrorType.calculationError;
      _logger.error(
        'Erro no cálculo de IMC',
        tag: 'ImcController',
        error: e,
        stackTrace: stackTrace,
      );
    }

    notifyListeners();
  }

  void reset() {
    _weightInput = '';
    _heightInput = '';
    _result = null;
    _errorType = null;
    notifyListeners();
  }
}
