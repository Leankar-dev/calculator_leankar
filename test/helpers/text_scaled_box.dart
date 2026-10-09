import 'package:flutter/widgets.dart';

class TextScaledBox extends StatelessWidget {
  final double textScale;
  final Widget child;

  const TextScaledBox({
    super.key,
    required this.textScale,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: child,
    );
  }
}
