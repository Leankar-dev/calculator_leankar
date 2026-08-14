import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';

class ScientificCalculationException implements Exception {
  final ScientificErrorType errorType;
  final String? details;

  const ScientificCalculationException(this.errorType, [this.details]);
}
