import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ScientificModeRowWidget extends StatelessWidget {
  final AngleMode angleMode;
  final bool isShiftActive;
  final VoidCallback onToggleAngleMode;
  final VoidCallback onToggleShift;
  final VoidCallback onLockShift;
  final VoidCallback onPi;
  final VoidCallback onEuler;

  const ScientificModeRowWidget({
    super.key,
    required this.angleMode,
    required this.isShiftActive,
    required this.onToggleAngleMode,
    required this.onToggleShift,
    required this.onLockShift,
    required this.onPi,
    required this.onEuler,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonWidget(
          key: const ValueKey('scientific_angle_mode'),
          text: angleMode == AngleMode.deg
              ? AppScientificStrings.degMode
              : AppScientificStrings.radMode,
          onPressed: onToggleAngleMode,
          color: AppColors.operationButton,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_shift'),
          text: AppScientificStrings.shift,
          onPressed: onToggleShift,
          onLongPress: onLockShift,
          color: isShiftActive ? AppColors.scientificShiftActive : null,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_pi'),
          text: AppScientificStrings.pi,
          onPressed: onPi,
          color: AppColors.scientificConstant,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_euler'),
          text: AppScientificStrings.euler,
          onPressed: onEuler,
          color: AppColors.scientificConstant,
        ),
      ],
    );
  }
}
