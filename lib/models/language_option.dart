import 'dart:ui';

class LanguageOption {
  final Locale locale;
  final String flagEmoji;
  final String nativeName;

  const LanguageOption({
    required this.locale,
    required this.flagEmoji,
    required this.nativeName,
  });
}
