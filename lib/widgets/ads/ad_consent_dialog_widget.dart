import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AdConsentDialogWidget extends StatelessWidget {
  final AdConsentController? controller;

  const AdConsentDialogWidget({super.key, this.controller});

  AdConsentController get _controller =>
      controller ?? AdConsentController.instance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(AppSizes.adConsentDialogBorderRadius),
          ),
        ),
        padding: const EdgeInsets.all(AppSizes.adConsentDialogPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.adConsentDialogTitle,
              style: TextStyle(
                fontSize: AppSizes.adConsentDialogTitleFontSize,
                fontWeight: FontWeight.bold,
                color: NeumorphicTheme.defaultTextColor(context),
              ),
            ),
            const SizedBox(height: AppSizes.adConsentDialogTitleBodySpacing),
            Text(
              l10n.adConsentDialogBody,
              style: TextStyle(
                fontSize: AppSizes.adConsentDialogBodyFontSize,
                color: NeumorphicTheme.defaultTextColor(context),
              ),
            ),
            const SizedBox(
              height: AppSizes.adConsentDialogBodyButtonsSpacing,
            ),
            Row(
              children: [
                Expanded(
                  child: _AdConsentDialogButton(
                    label: l10n.adConsentDecline,
                    color: AppColors.clearButton,
                    onPressed: () => _submit(context, false),
                  ),
                ),
                const SizedBox(width: AppSizes.adConsentDialogButtonSpacing),
                Expanded(
                  child: _AdConsentDialogButton(
                    label: l10n.adConsentAccept,
                    color: AppColors.equalsButton,
                    onPressed: () => _submit(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, bool accepted) async {
    await _controller.submitUserChoice(accepted);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _AdConsentDialogButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _AdConsentDialogButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        depth: AppSizes.adConsentDialogButtonDepth,
        intensity: AppSizes.adConsentDialogButtonIntensity,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(AppSizes.adConsentDialogButtonBorderRadius),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.adConsentDialogButtonPaddingH,
        vertical: AppSizes.adConsentDialogButtonPaddingV,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppSizes.adConsentDialogButtonFontSize,
          color: color,
        ),
      ),
    );
  }
}
