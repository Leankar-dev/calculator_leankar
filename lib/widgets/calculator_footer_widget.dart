import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CalculatorFooterWidget extends StatelessWidget {
  const CalculatorFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(12),
              ),
              depth: 3,
              intensity: 0.5,
              color: NeumorphicTheme.baseColor(context),
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/images/logo2.png',
              height: 45,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'https://leankar.dev',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
