import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class BannerAdPlaceholderWidget extends StatelessWidget {
  final double height;

  const BannerAdPlaceholderWidget({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -1,
          intensity: 0.5,
          color: NeumorphicTheme.baseColor(context),
          boxShape: const NeumorphicBoxShape.rect(),
        ),
      ),
    );
  }
}
