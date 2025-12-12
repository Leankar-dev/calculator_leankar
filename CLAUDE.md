# CLAUDE.md

Este arquivo fornece orientações ao Claude Code (claude.ai/code) ao trabalhar com o código neste repositório.

## Visão Geral do Projeto

Um aplicativo de calculadora Flutter com design neumórfico usando o pacote `flutter_neumorphic_plus`. O app suporta operações aritméticas básicas e entrada via teclado.

## Comandos Comuns

```bash
# Obter dependências
flutter pub get

# Executar o app
flutter run

# Analisar código
flutter analyze

# Executar testes
flutter test

# Executar um único arquivo de teste
flutter test test/widget_test.dart

# Build para release
flutter build apk        # Android
flutter build ios        # iOS
flutter build windows    # Windows
```

## Arquitetura

O app segue um padrão simples similar ao MVC:

- **Controller** (`lib/controllers/calculator_controller.dart`): Um `ChangeNotifier` que gerencia o estado da calculadora (texto do display, operandos, operação atual). Lida com toda a lógica de cálculo e notifica os listeners quando há mudanças de estado.

- **Page** (`lib/pages/calculator_page.dart`): UI principal que escuta o controller e lida com entrada do teclado via `KeyboardListener`.

- **Widgets** (`lib/widgets/`):
  - `calculator_display_widget.dart`: Exibe a expressão atual e o resultado
  - `calculator_keypad_widget.dart`: Renderiza a grade de botões da calculadora
  - `button_widget.dart`: Componente de botão neumórfico reutilizável

- **Utils** (`lib/utils/enums/operations_type.dart`): Enum que define as operações aritméticas com seus símbolos de exibição.

## Padrões Importantes

- Usa vírgula (`,`) como separador decimal (padrão brasileiro/português)
- Temas via `NeumorphicApp` com suporte a tema claro/escuro
- Atalhos de teclado: números, operadores (`+`, `-`, `*`, `/`), Enter/= para calcular, Backspace para apagar, Escape/Delete para limpar
