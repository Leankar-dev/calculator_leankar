import 'package:calculator_05122025/models/calculation_history.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class HistoryItemWidget extends StatelessWidget {
  final CalculationHistory item;
  final void Function(CalculationHistory) onItemTap;

  const HistoryItemWidget({
    super.key,
    required this.item,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
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
