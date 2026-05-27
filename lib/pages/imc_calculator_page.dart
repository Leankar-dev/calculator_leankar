import 'package:calculator_05122025/controllers/imc_controller.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/imc/imc_calculate_button_widget.dart';
import 'package:calculator_05122025/widgets/imc/imc_input_field_widget.dart';
import 'package:calculator_05122025/widgets/imc/imc_result_card_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ImcCalculatorPage extends StatefulWidget {
  const ImcCalculatorPage({super.key});

  @override
  State<ImcCalculatorPage> createState() => _ImcCalculatorPageState();
}

class _ImcCalculatorPageState extends State<ImcCalculatorPage> {
  final ImcController _controller = ImcController();
  final TextEditingController _weightTextController = TextEditingController();
  final TextEditingController _heightTextController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _weightTextController.dispose();
    _heightTextController.dispose();
    super.dispose();
  }

  void _onReset() {
    _controller.reset();
    _weightTextController.clear();
    _heightTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        leading: NeumorphicButton(
          onPressed: () => Navigator.of(context).pop(),
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: AppSizes.appBarMenuButtonDepth,
            intensity: AppSizes.appBarMenuButtonIntensity,
          ),
          padding: const EdgeInsets.all(AppSizes.appBarMenuButtonPadding),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryText,
          ),
        ),
        title: const Text(
          AppStrings.imcPageTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        actions: [
          NeumorphicButton(
            style: const NeumorphicStyle(
              depth: AppSizes.imcResetButtonDepth,
              intensity: AppSizes.imcResetButtonIntensity,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(AppSizes.imcResetButtonPadding),
            onPressed: _onReset,
            child: const Icon(Icons.refresh, color: AppColors.iconMuted),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.imcBodyPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ImcInputFieldWidget(
                    label: AppStrings.imcWeightLabel,
                    unit: AppStrings.imcWeightUnit,
                    hint: AppStrings.imcWeightHint,
                    controller: _weightTextController,
                    onChanged: _controller.setWeight,
                  ),
                  const SizedBox(height: AppSizes.imcInputSpacing),
                  ImcInputFieldWidget(
                    label: AppStrings.imcHeightLabel,
                    unit: AppStrings.imcHeightUnit,
                    hint: AppStrings.imcHeightHint,
                    controller: _heightTextController,
                    onChanged: _controller.setHeight,
                  ),
                  const SizedBox(height: AppSizes.imcErrorBottomSpacing),
                  if (_controller.hasError)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSizes.imcErrorBottomSpacing,
                      ),
                      child: Text(
                        _controller.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.clearButton,
                          fontSize: AppSizes.imcErrorFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Center(
                    child: ImcCalculateButtonWidget(
                      onPressed: _controller.calculate,
                    ),
                  ),
                  if (_controller.hasResult) ...[
                    const SizedBox(height: AppSizes.imcButtonToResultSpacing),
                    ImcResultCardWidget(result: _controller.result!),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
