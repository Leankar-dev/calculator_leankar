import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:calculator_05122025/widgets/history_empty_state_widget.dart';
import 'package:calculator_05122025/widgets/history_header_widget.dart';
import 'package:calculator_05122025/widgets/history_list_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class HistoryBottomSheet extends StatelessWidget {
  final List<CalculationHistory> history;
  final void Function(CalculationHistory) onItemTap;
  final VoidCallback onClearHistory;

  const HistoryBottomSheet({
    super.key,
    required this.history,
    required this.onItemTap,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: NeumorphicTheme.baseColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HistoryHeaderWidget(
            hasHistory: history.isNotEmpty,
            onClearHistory: onClearHistory,
          ),
          const Divider(height: 1),
          Flexible(
            child: history.isEmpty
                ? const HistoryEmptyStateWidget()
                : HistoryListWidget(
                    history: history,
                    onItemTap: onItemTap,
                  ),
          ),
        ],
      ),
    );
  }
}
