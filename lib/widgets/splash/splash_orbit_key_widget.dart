import 'package:calculator_05122025/models/splash_key_placement.dart';
import 'package:calculator_05122025/utils/enums/splash_symbol.dart';
import 'package:calculator_05122025/widgets/splash/splash_key_widget.dart';
import 'package:flutter/widgets.dart';

class SplashOrbitKeyWidget extends StatelessWidget {
  final Animation<double> animation;
  final SplashSymbol symbol;
  final double keyExtent;
  final double radius;

  const SplashOrbitKeyWidget({
    super.key,
    required this.animation,
    required this.symbol,
    required this.keyExtent,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: SplashKeyWidget(symbol: symbol, extent: keyExtent),
      builder: (context, child) {
        final placement = SplashKeyPlacement.fromAnimation(
          symbol: symbol,
          animationValue: animation.value,
          radius: radius,
        );
        return Transform.translate(
          offset: placement.offset,
          child: Transform.rotate(
            angle: placement.rotation,
            child: Transform.scale(scale: placement.scale, child: child),
          ),
        );
      },
    );
  }
}
