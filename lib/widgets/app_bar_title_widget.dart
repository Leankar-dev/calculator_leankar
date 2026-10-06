import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AppBarTitleWidget extends StatelessWidget {
  final String text;

  const AppBarTitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}
