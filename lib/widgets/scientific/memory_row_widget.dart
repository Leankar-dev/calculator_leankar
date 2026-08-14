import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
import 'package:calculator_05122025/widgets/button_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class MemoryRowWidget extends StatelessWidget {
  final bool hasMemoryValue;
  final VoidCallback onMemoryAdd;
  final VoidCallback onMemorySubtract;
  final VoidCallback onMemoryRecall;
  final VoidCallback onMemoryClear;

  const MemoryRowWidget({
    super.key,
    required this.hasMemoryValue,
    required this.onMemoryAdd,
    required this.onMemorySubtract,
    required this.onMemoryRecall,
    required this.onMemoryClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonWidget(
          key: const ValueKey('scientific_memory_add'),
          text: AppScientificStrings.memoryAdd,
          onPressed: onMemoryAdd,
          color: AppColors.backspaceButton,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_memory_subtract'),
          text: AppScientificStrings.memorySubtract,
          onPressed: onMemorySubtract,
          color: AppColors.backspaceButton,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_memory_recall'),
          text: AppScientificStrings.memoryRecall,
          onPressed: hasMemoryValue ? onMemoryRecall : () {},
          color: hasMemoryValue
              ? AppColors.backspaceButton
              : AppColors.iconDisabled,
        ),
        ButtonWidget(
          key: const ValueKey('scientific_memory_clear'),
          text: AppScientificStrings.memoryClear,
          onPressed: hasMemoryValue ? onMemoryClear : () {},
          color: hasMemoryValue
              ? AppColors.clearButton
              : AppColors.iconDisabled,
        ),
      ],
    );
  }
}
