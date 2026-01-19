import 'dart:convert';

class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timestamp;

  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    return CalculationHistory(
      expression: json['expression'] as String,
      result: json['result'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  static String encodeList(List<CalculationHistory> history) {
    return jsonEncode(history.map((h) => h.toJson()).toList());
  }

  static List<CalculationHistory> decodeList(String jsonString) {
    final list = jsonDecode(jsonString) as List;
    return list.map((e) => CalculationHistory.fromJson(e)).toList();
  }
}
