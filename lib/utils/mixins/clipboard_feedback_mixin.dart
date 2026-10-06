import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/enums/paste_result.dart';
import 'package:calculator_05122025/utils/extensions/paste_result_l10n_extension.dart';
import 'package:flutter/material.dart';

mixin ClipboardFeedbackMixin<T extends StatefulWidget> on State<T> {
  static const Duration _snackBarDuration = Duration(seconds: 1);

  Future<void> copyWithFeedback(Future<bool> Function() copy) async {
    final wasCopied = await copy();
    if (!wasCopied || !mounted) return;
    _showSnackBar(AppLocalizations.of(context).snackbarValueCopied);
  }

  Future<void> pasteWithFeedback(
    Future<PasteResult> Function() paste,
  ) async {
    final result = await paste();
    if (!mounted) return;
    final message = result.feedbackMessage(AppLocalizations.of(context));
    if (message == null) return;
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: _snackBarDuration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
