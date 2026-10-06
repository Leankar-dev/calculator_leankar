import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/calculator_key_action.dart';
import 'package:flutter/services.dart';

class CalculatorKeyResolver {
  CalculatorKeyResolver._();

  static final RegExp _digitPattern = RegExp(r'^[0-9]$');

  static CalculatorKeyAction? resolve(KeyDownEvent event) {
    final logicalKey = event.logicalKey;
    final character = event.character;

    final isControlPressed =
        HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;

    if (isControlPressed) {
      if (logicalKey == LogicalKeyboardKey.keyC) {
        return CalculatorKeyAction.copy;
      }
      if (logicalKey == LogicalKeyboardKey.keyV) {
        return CalculatorKeyAction.paste;
      }
    }

    if (logicalKey == LogicalKeyboardKey.enter ||
        logicalKey == LogicalKeyboardKey.numpadEnter) {
      return CalculatorKeyAction.calculate;
    }

    if (logicalKey == LogicalKeyboardKey.backspace) {
      return CalculatorKeyAction.backspace;
    }

    if (logicalKey == LogicalKeyboardKey.escape ||
        logicalKey == LogicalKeyboardKey.delete) {
      return CalculatorKeyAction.clear;
    }

    if (character == null) {
      return null;
    }

    if (_digitPattern.hasMatch(character)) {
      return CalculatorKeyAction.digit;
    }

    return _resolveCharacter(character);
  }

  static CalculatorKeyAction? _resolveCharacter(String character) {
    switch (character) {
      case AppStrings.additionSymbol:
        return CalculatorKeyAction.add;
      case AppStrings.subtractionSymbol:
        return CalculatorKeyAction.subtract;
      case AppStrings.keyboardAsterisk:
      case AppStrings.keyboardXLower:
      case AppStrings.keyboardXUpper:
        return CalculatorKeyAction.multiply;
      case AppStrings.keyboardSlash:
        return CalculatorKeyAction.divide;
      case AppStrings.decimalSeparator:
      case AppStrings.keyboardDot:
        return CalculatorKeyAction.decimal;
      case AppStrings.equalsButtonText:
        return CalculatorKeyAction.calculate;
      default:
        return null;
    }
  }
}
