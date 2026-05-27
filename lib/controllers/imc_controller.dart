import 'package:calculator_05122025/models/imc_result.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter/foundation.dart';

class ImcController extends ChangeNotifier {
  final LoggerService _logger;

  String _weightInput = '';
  String _heightInput = '';
  ImcResult? _result;
  String? _errorMessage;

  ImcController({LoggerService? logger})
    : _logger = logger ?? LoggerService.instance;

  String get weightInput => _weightInput;
  String get heightInput => _heightInput;
  ImcResult? get result => _result;
  String? get errorMessage => _errorMessage;
  bool get hasResult => _result != null;
  bool get hasError => _errorMessage != null;

  void setWeight(String value) {
    _weightInput = value;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  void setHeight(String value) {
    _heightInput = value;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  void calculate() {
    _errorMessage = null;

    final weight = double.tryParse(_weightInput.replaceAll(',', '.'));
    final height = double.tryParse(_heightInput.replaceAll(',', '.'));

    if (weight == null || weight <= 0 || weight > 500) {
      _errorMessage = AppStrings.imcInvalidWeightError;
      notifyListeners();
      return;
    }

    if (height == null || height < 50 || height > 250) {
      _errorMessage = AppStrings.imcInvalidHeightError;
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
      _errorMessage = AppStrings.imcCalculationError;
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
    _errorMessage = null;
    notifyListeners();
  }
}
