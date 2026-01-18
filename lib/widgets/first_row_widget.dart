import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class FirstRowWidget extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onBackspace;
  final VoidCallback onPercentage;

  const FirstRowWidget({
    super.key,
    required this.onClear,
    required this.onBackspace,
    required this.onPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonWidget(
          text: 'C',
          onPressed: onClear,
          color: const Color(0xFFE57373),
        ),
        ButtonWidget(
          text: '\u{232B}',
          onPressed: onBackspace,
          color: const Color(0xFFFFB74D),
        ),
        ButtonWidget(
          text: '\u{0025}',
          onPressed: onPercentage,
          color: const Color(0xFF64B5F6),
        ),
      ],
    );
  }
}
