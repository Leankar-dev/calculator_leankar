import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ImcCalculatorPage extends StatelessWidget {
  const ImcCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: const Text(
          AppStrings.imcPageTitle,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
      ),
      body: const SafeArea(
        child: _UnderConstructionBody(),
      ),
    );
  }
}

class _UnderConstructionBody extends StatelessWidget {
  const _UnderConstructionBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Neumorphic(
              style: const NeumorphicStyle(
                depth: 4,
                intensity: 0.6,
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              padding: const EdgeInsets.all(32),
              child: const Icon(
                Icons.construction_outlined,
                size: 64,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              AppStrings.imcUnderConstructionTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.imcUnderConstructionDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
