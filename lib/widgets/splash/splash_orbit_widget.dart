import 'package:calculator_05122025/models/splash_layout_metrics.dart';
import 'package:calculator_05122025/utils/enums/splash_symbol.dart';
import 'package:calculator_05122025/widgets/splash/splash_orbit_key_widget.dart';
import 'package:flutter/widgets.dart';

class SplashOrbitWidget extends StatelessWidget {
  final Animation<double> animation;
  final double tileExtent;

  const SplashOrbitWidget({
    super.key,
    required this.animation,
    required this.tileExtent,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = SplashLayoutMetrics.fromTileExtent(tileExtent);
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: metrics.orbitRadius * 2,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            for (final symbol in SplashSymbol.values)
              SplashOrbitKeyWidget(
                animation: animation,
                symbol: symbol,
                keyExtent: metrics.keyExtent,
                radius: metrics.orbitRadius,
              ),
          ],
        ),
      ),
    );
  }
}
