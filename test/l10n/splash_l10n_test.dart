import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class _SplashTexts {
  final Locale locale;
  final String tagline;
  final String semanticLabel;

  const _SplashTexts({
    required this.locale,
    required this.tagline,
    required this.semanticLabel,
  });
}

void main() {
  const expectedTexts = [
    _SplashTexts(
      locale: Locale('pt', 'BR'),
      tagline: 'Calcule tudo. Em um só app.',
      semanticLabel: 'Leankar Calc, carregando',
    ),
    _SplashTexts(
      locale: Locale('pt'),
      tagline: 'Calcule tudo. Em um só app.',
      semanticLabel: 'Leankar Calc, carregando',
    ),
    _SplashTexts(
      locale: Locale('en'),
      tagline: 'Calculate everything. In one app.',
      semanticLabel: 'Leankar Calc, loading',
    ),
    _SplashTexts(
      locale: Locale('es'),
      tagline: 'Calcula todo. En una sola app.',
      semanticLabel: 'Leankar Calc, cargando',
    ),
    _SplashTexts(
      locale: Locale('it'),
      tagline: 'Calcola tutto. In una sola app.',
      semanticLabel: 'Leankar Calc, caricamento',
    ),
    _SplashTexts(
      locale: Locale('fr'),
      tagline: 'Calculez tout. Dans une seule appli.',
      semanticLabel: 'Leankar Calc, chargement',
    ),
  ];

  group('textos da splash', () {
    for (final expected in expectedTexts) {
      group(expected.locale.toLanguageTag(), () {
        late AppLocalizations l10n;

        setUp(() async {
          l10n = await AppLocalizations.delegate.load(expected.locale);
        });

        test('splashTagline está traduzida', () {
          expect(l10n.splashTagline, expected.tagline);
        });

        test('splashSemanticLabel está traduzida e inclui a marca', () {
          expect(l10n.splashSemanticLabel, expected.semanticLabel);
          expect(l10n.splashSemanticLabel, startsWith('Leankar Calc'));
        });
      });
    }

    test('os cinco idiomas selecionáveis têm taglines distintas', () {
      final taglines = expectedTexts
          .where((expected) => expected.locale != const Locale('pt'))
          .map((expected) => expected.tagline)
          .toList();

      expect(taglines, hasLength(5));
      expect(taglines.toSet(), hasLength(5));
    });
  });
}
