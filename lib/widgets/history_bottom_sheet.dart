import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

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
          _buildHeader(context),
          const Divider(height: 1),
          Flexible(
            child: history.isEmpty
                ? _buildEmptyState(context)
                : _buildHistoryList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
          if (history.isNotEmpty)
            NeumorphicButton(
              style: NeumorphicStyle(
                depth: 2,
                intensity: 0.6,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              onPressed: () {
                Navigator.pop(context);
                onClearHistory();
              },
              child: Text(
                'Clear',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[400],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Sem Histórico de cálculos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return _buildHistoryItem(context, item);
      },
    );
  }

  Widget _buildHistoryItem(BuildContext context, CalculationHistory item) {
    final dateFormat = DateFormat('dd/MM HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: NeumorphicButton(
        style: NeumorphicStyle(
          depth: 2,
          intensity: 0.5,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: const EdgeInsets.all(12),
        onPressed: () {
          Navigator.pop(context);
          onItemTap(item);
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.expression,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '= ${item.result}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: NeumorphicTheme.defaultTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              dateFormat.format(item.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
