import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CalculatorFooterWidget extends StatelessWidget {
  const CalculatorFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        'https://leankar.dev',
        style: TextStyle(
          fontSize: 13,
          color: Colors.blue,
        ),
      ),
    );
  }
}
