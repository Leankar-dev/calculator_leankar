import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final bool isAccent;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = NeumorphicTheme.baseColor(context);
    final bool hasCustomColor = color != null;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: NeumorphicButton(
          onPressed: onPressed,
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
            depth: 8,
            intensity: 0.65,
            surfaceIntensity: 0.25,
            color: hasCustomColor ? color!.withValues(alpha: 0.15) : baseColor,
            lightSource: LightSource.topLeft,
          ),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: hasCustomColor ? color : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
