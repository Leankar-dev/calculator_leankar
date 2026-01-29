import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/widgets/history_item_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class HistoryListWidget extends StatelessWidget {
  final List<CalculationHistory> history;
  final void Function(CalculationHistory) onItemTap;

  const HistoryListWidget({
    super.key,
    required this.history,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return HistoryItemWidget(
          item: item,
          onItemTap: onItemTap,
        );
      },
    );
  }
}
