import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/models/imc_result.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class ImcIdealWeightWidget extends StatelessWidget {
  final ImcResult result;

  const ImcIdealWeightWidget({super.key, required this.result});

  Color _statusColor() {
    final diff = result.idealWeightDifference;
    if (diff == 0.0) return AppColors.imcNormal;
    if (diff < 0) return AppColors.imcUnderweight;
    return result.classification.color;
  }

  String _statusLabel(AppLocalizations l10n) {
    final diff = result.idealWeightDifference;
    if (diff == 0.0) return l10n.imcIdealWeightOnRange;
    if (diff < 0) return l10n.imcIdealWeightBelow;
    return l10n.imcIdealWeightAbove;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusColor = _statusColor();
    final statusLabel = _statusLabel(l10n);
    final isWithinRange = result.idealWeightDifference == 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        const SizedBox(height: AppSizes.imcIdealWeightTopSpacing),
        Text(
          l10n.imcIdealWeightTitle,
          style: const TextStyle(
            fontSize: AppSizes.imcIdealWeightTitleFontSize,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w600,
            letterSpacing: AppSizes.imcIdealWeightTitleLetterSpacing,
          ),
        ),
        const SizedBox(height: AppSizes.imcIdealWeightInnerSpacing),
        _IdealWeightRow(
          label: l10n.imcIdealWeightRangeLabel,
          value: result.formattedIdealWeightRange,
        ),
        const SizedBox(height: AppSizes.imcIdealWeightInnerSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.imcIdealWeightStatusLabel,
              style: const TextStyle(color: AppColors.secondaryText),
            ),
            _IdealWeightStatusBadge(label: statusLabel, color: statusColor),
          ],
        ),
        if (!isWithinRange) ...[
          const SizedBox(height: AppSizes.imcIdealWeightInnerSpacing),
          _IdealWeightRow(
            label: l10n.imcIdealWeightDiffLabel,
            value: result.formattedIdealWeightDifference,
            valueColor: statusColor,
          ),
        ],
      ],
    );
  }
}

class _IdealWeightRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _IdealWeightRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryText)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.imcResultDetailFontSize,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _IdealWeightStatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _IdealWeightStatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.imcIdealWeightStatusPaddingH,
        vertical: AppSizes.imcIdealWeightStatusPaddingV,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(
          AppSizes.imcIdealWeightStatusBorderRadius,
        ),
        border: Border.all(
          color: color,
          width: AppSizes.imcIdealWeightStatusBorderWidth,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.imcIdealWeightStatusFontSize,
        ),
      ),
    );
  }
}
