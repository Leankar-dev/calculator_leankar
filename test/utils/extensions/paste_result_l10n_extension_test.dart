import 'package:calculator_05122025/l10n/app_localizations_en.dart';
import 'package:calculator_05122025/utils/enums/paste_result.dart';
import 'package:calculator_05122025/utils/extensions/paste_result_l10n_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('PasteResultL10nExtension', () {
    test('success não possui mensagem de feedback', () {
      expect(PasteResult.success.feedbackMessage(l10n), isNull);
    });

    test('emptyClipboard usa a mensagem de área de transferência vazia', () {
      expect(
        PasteResult.emptyClipboard.feedbackMessage(l10n),
        l10n.snackbarEmptyClipboard,
      );
    });

    test('invalidFormat usa a mensagem de colagem inválida', () {
      expect(
        PasteResult.invalidFormat.feedbackMessage(l10n),
        l10n.snackbarInvalidPaste,
      );
    });

    test('outOfRange usa a mensagem de valor fora do limite', () {
      expect(
        PasteResult.outOfRange.feedbackMessage(l10n),
        l10n.snackbarOutOfRange,
      );
    });
  });
}
