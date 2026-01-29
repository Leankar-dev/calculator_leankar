import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class HistoryHeaderWidget extends StatelessWidget {
  final bool hasHistory;
  final VoidCallback onClearHistory;

  const HistoryHeaderWidget({
    super.key,
    required this.hasHistory,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
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
          if (hasHistory)
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
}
