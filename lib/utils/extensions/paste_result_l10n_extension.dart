import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/utils/enums/paste_result.dart';

extension PasteResultL10nExtension on PasteResult {
  String? feedbackMessage(AppLocalizations l10n) {
    switch (this) {
      case PasteResult.success:
        return null;
      case PasteResult.emptyClipboard:
        return l10n.snackbarEmptyClipboard;
      case PasteResult.invalidFormat:
        return l10n.snackbarInvalidPaste;
      case PasteResult.outOfRange:
        return l10n.snackbarOutOfRange;
    }
  }
}
