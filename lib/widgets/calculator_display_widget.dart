import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CalculatorDisplayWidget extends StatelessWidget {
  final String displayText;
  final String expressionDisplay;

  const CalculatorDisplayWidget({
    super.key,
    required this.displayText,
    required this.expressionDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          depth: -8,
          intensity: 0.8,
          lightSource: LightSource.topLeft,
          color: const Color(0xFF64B5F6).withValues(alpha: 0.15),
        ),
        child: Container(
          height: 160,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (expressionDisplay.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    expressionDisplay,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
