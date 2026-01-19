import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _historyKey = 'calculation_history';

  Future<void> saveHistory(List<CalculationHistory> history) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = CalculationHistory.encodeList(history);
    await prefs.setString(_historyKey, jsonString);
  }

  Future<List<CalculationHistory>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    return CalculationHistory.decodeList(jsonString);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
