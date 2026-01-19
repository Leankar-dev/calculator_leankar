import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // ============================================
  // CORES DOS BOTÕES
  // ============================================

  static const Color clearButtonColor = Color(0xFFE57373);

  static const Color backspaceButtonColor = Color(0xFFFFB74D);

  static const Color operationButtonColor = Color(0xFF64B5F6);

  static const Color equalsButtonColor = Color(0xFF81C784);

  static const Color primaryTextColor = Color(0xDD000000);

  static const Color secondaryTextColor = Color(0xFF757575);

  // ============================================
  // TAMANHOS BASE (para ResponsiveUtils)
  // ============================================

  static const double baseWidth = 375.0;

  static const double maxCalculatorWidth = 500.0;

  static const double minWidth = 280.0;

  static const double displayHeightPortrait = 160.0;

  static const double displayHeightLandscape = 100.0;

  static const double displayFontSize = 48.0;

  static const double expressionFontSize = 20.0;

  static const double buttonFontSizePortrait = 24.0;

  static const double buttonFontSizeLandscape = 20.0;

  static const double buttonPaddingPortrait = 16.0;

  static const double buttonPaddingLandscape = 10.0;

  static const double buttonSpacing = 6.0;

  static const double displayPadding = 16.0;

  // ============================================
  // LIMITES DE TAMANHO (para clamp)
  // ============================================

  static const double displayHeightMin = 120.0;

  static const double displayHeightMax = 200.0;

  static const double displayHeightLandscapeMin = 80.0;

  static const double displayHeightLandscapeMax = 140.0;

  static const double displayFontSizeMin = 32.0;

  static const double displayFontSizeMax = 64.0;

  static const double expressionFontSizeMin = 14.0;

  static const double expressionFontSizeMax = 28.0;

  static const double buttonFontSizeMin = 18.0;

  static const double buttonFontSizeMax = 32.0;

  static const double buttonFontSizeLandscapeMin = 16.0;

  static const double buttonFontSizeLandscapeMax = 28.0;

  static const double buttonPaddingMin = 10.0;

  static const double buttonPaddingMax = 22.0;

  static const double buttonPaddingLandscapeMin = 6.0;

  static const double buttonPaddingLandscapeMax = 14.0;

  static const double buttonSpacingMin = 4.0;

  static const double buttonSpacingMax = 10.0;

  // ============================================
  // ESTILOS NEUMÓRFICOS
  // ============================================

  static const double buttonBorderRadius = 16.0;

  static const double displayBorderRadius = 20.0;

  static const double buttonDepth = 8.0;

  static const double displayDepth = -8.0;

  static const double buttonIntensity = 0.65;

  static const double displayIntensity = 0.8;

  static const double buttonSurfaceIntensity = 0.25;

  static const double colorAlpha = 0.15;

  // ============================================
  // FORMATAÇÃO DE NÚMEROS
  // ============================================

  static const int maxDecimalPlaces = 8;

  static const String decimalSeparator = ',';

  static const String divisionByZeroError = 'Erro: Div/0';

  static const String infinityError = 'Erro: Infinito';

  static const String nanError = 'Erro: Inválido';

  static const String overflowError = 'Erro: Overflow';

  static const String genericError = 'Erro';

  static const String initialDisplayValue = '0';

  /// Limite máximo para exibição de números
  static const double maxDisplayValue = 1e15;

  // ============================================
  // SÍMBOLOS UNICODE
  // ============================================

  static const String backspaceSymbol = '\u{232B}';

  static const String percentSymbol = '\u{0025}';

  static const String additionSymbol = '\u{002B}';

  static const String subtractionSymbol = '\u{002D}';

  static const String multiplicationSymbol = '\u{00D7}';

  static const String divisionSymbol = '\u{00F7}';

  // ============================================
  // RESPONSIVIDADE
  // ============================================

  static const double tabletBreakpoint = 600.0;

  static const int displayFlexLandscape = 2;

  static const int keypadFlexLandscape = 3;
}
