# Estrutura do Projeto - Calculator Leankar

## Visão Geral

Aplicativo de calculadora Flutter com design neumórfico, seguindo o padrão MVC simplificado.
Versão atual: **0.7.6+1** | SDK Dart: `^3.10.1`

## Árvore de Diretórios

```
calculator_leankar/
│
├── lib/
│   ├── main.dart                            # Ponto de entrada do app
│   ├── app_calculator.dart                  # Configuração do NeumorphicApp e temas
│   │
│   ├── controllers/
│   │   └── calculator_controller.dart       # Estado e lógica de negócio (ChangeNotifier)
│   │
│   ├── models/
│   │   └── calculation_history.dart         # Modelo de histórico com serialização JSON
│   │
│   ├── pages/
│   │   └── calculator_page.dart             # Página principal com KeyboardListener
│   │
│   ├── services/
│   │   ├── error_handler.dart               # Singleton: validação e tratamento de erros
│   │   ├── logger_service.dart              # Singleton: logging com níveis (debug/info/warn/error)
│   │   └── storage_service.dart             # Wrapper SharedPreferences para histórico
│   │
│   ├── utils/
│   │   ├── constants.dart                   # Constantes globais (cores, tamanhos, limites)
│   │   ├── number_formatter.dart            # Formatação pt_BR, notação científica, parse
│   │   ├── responsive_utils.dart            # Tamanhos adaptativos por largura de tela
│   │   ├── result.dart                      # Result<T> — padrão Either para erros funcionais
│   │   └── enums/
│   │       ├── error_type.dart              # Enum com 10+ tipos de erro da calculadora
│   │       └── operations_type.dart         # Enum das operações aritméticas (+, -, ×, ÷)
│   │
│   └── widgets/
│       ├── Botões e display
│       │   ├── button_widget.dart               # Botão neumórfico com Semantics e HapticFeedback
│       │   ├── calculator_display_widget.dart   # Display côncavo: expressão + resultado
│       │   └── calculator_footer_widget.dart    # Rodapé com logo Leankar
│       │
│       ├── Teclado
│       │   ├── calculator_keypad_widget.dart    # Container do teclado numérico
│       │   ├── first_row_widget.dart            # Linha: C, ⌫, %
│       │   ├── number_row_widget.dart           # Linha genérica: 3 números + operação
│       │   └── last_row_widget.dart             # Linha: 0, vírgula, =, +
│       │
│       ├── Layouts
│       │   ├── portrait_layout_widget.dart      # Column: display → keypad → footer
│       │   └── landscape_layout_widget.dart     # Row flex 2:3 (display : keypad)
│       │
│       └── Histórico
│           ├── history_bottom_sheet.dart        # Bottom sheet 60% altura
│           ├── history_header_widget.dart       # Cabeçalho com botão limpar
│           ├── history_list_widget.dart         # ListView.builder do histórico
│           ├── history_item_widget.dart         # Item: expressão + resultado + data
│           └── history_empty_state_widget.dart  # Estado vazio com ícone
│
├── test/
│   ├── controllers/
│   │   └── calculator_controller_test.dart  # ~140 testes unitários (edge cases, histórico, clipboard)
│   │
│   ├── pages/
│   │   └── calculator_page_test.dart        # Testes de integração da página principal
│   │
│   ├── utils/
│   │   └── number_formatter_test.dart       # Testes do formatador de números
│   │
│   ├── widgets/
│   │   ├── button_widget_test.dart              # Renderização e callbacks do botão
│   │   ├── calculator_display_widget_test.dart  # Display e overflow de texto
│   │   └── calculator_keypad_widget_test.dart   # Grade de botões do teclado
│   │
│   └── mocks/
│       └── mock_storage_service.dart        # Mock do StorageService para testes isolados
│
├── assets/
│   └── images/
│       └── logo2.png                        # Logo da Leankar (AppBar)
│
├── docs/
│   ├── structure.md                         # Este arquivo
│   └── melhorias/
│       ├── sugestoes-melhorias-completo.md  # Backlog de melhorias (v6.0, 46 itens)
│       └── melhorias_001.md                 # Detalhamento de melhorias pontuais
│
├── android/                                 # Configurações Android
├── ios/                                     # Configurações iOS
├── web/                                     # Configurações Web
├── windows/                                 # Configurações Windows
│
├── analysis_options.yaml                    # Regras de lint (flutter_lints)
├── pubspec.yaml                             # Dependências do projeto
├── CLAUDE.md                                # Instruções para o Claude Code
└── README.md                                # Documentação principal
```

## Arquitetura

### Padrão MVC Simplificado

```
┌──────────────────────────────────────────────────────────────────┐
│                           View (UI)                              │
│  ┌──────────────────────┐  ┌────────────────────────────────┐   │
│  │  calculator_page.dart│  │          widgets/              │   │
│  │                      │  │  - portrait_layout_widget      │   │
│  │  KeyboardListener    │  │  - landscape_layout_widget     │   │
│  │  ListenableBuilder   │  │  - button_widget               │   │
│  │                      │  │  - calculator_display_widget   │   │
│  │  Detecta orientação  │  │  - calculator_keypad_widget    │   │
│  │  e roteia o layout   │  │  - history_bottom_sheet        │   │
│  └──────────┬───────────┘  └────────────────────────────────┘   │
└─────────────┼────────────────────────────────────────────────────┘
              │ ListenableBuilder / callbacks
              ▼
┌──────────────────────────────────────────────────────────────────┐
│                       Controller (Lógica)                        │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │                 calculator_controller.dart                 │  │
│  │                                                            │  │
│  │  Estado:  displayText, firstOperand, secondOperand,        │  │
│  │           currentOperation, shouldResetDisplay,            │  │
│  │           history, isLoading, hasError                     │  │
│  │                                                            │  │
│  │  Métodos: appendNumber, appendDecimal, setOperationType,   │  │
│  │           calculateResult, calculatePercentage, backspace,  │  │
│  │           clearDisplay, copyToClipboard, pasteFromClipboard│  │
│  │           loadHistory, clearHistory, useHistoryResult      │  │
│  └──────────────────────────┬─────────────────────────────────┘  │
└─────────────────────────────┼────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
┌─────────────────┐ ┌─────────────────┐ ┌──────────────────────┐
│ calculation_    │ │ storage_service │ │ error_handler /      │
│ history.dart    │ │ .dart           │ │ logger_service.dart  │
│                 │ │                 │ │                      │
│ Modelo com      │ │ SharedPrefs     │ │ Singletons globais   │
│ serialização    │ │ JSON encode/    │ │ (nota: candidatos a  │
│ JSON e tryFrom  │ │ decode +        │ │ injeção futura)      │
│ Json seguro     │ │ recuperação de  │ │                      │
│                 │ │ dados corrompidos│ │                      │
└─────────────────┘ └─────────────────┘ └──────────────────────┘
```

### Fluxo de Dados — Operação Típica

```
Usuário toca botão / pressiona tecla
              │
              ▼
   ButtonWidget.onPressed()
   ou KeyboardListener.onKeyEvent()
              │
              ▼
   CalculatorPage (callback mapeado)
              │
              ▼
   CalculatorController.método()
              │
              ├── Valida entrada (ErrorHandler)
              ├── Atualiza estado interno
              ├── Formata número (NumberFormatter)
              ├── Persiste histórico (StorageService) ← async
              └── notifyListeners()
                          │
                          ▼
              ListenableBuilder reconstrói
                          │
                          ▼
              UI atualizada (rebuild seletivo)
```

### Fluxo do Histórico

```
Controller.calculateResult()
              │
              ├── Adiciona CalculationHistory à lista
              └── StorageService.saveHistory() ← fire-and-forget (.then)
                          │
                          ▼
              SharedPreferences ← JSON encoded

Usuário abre histórico
              │
              ▼
   CalculatorPage → showModalBottomSheet
              │
              ▼
   HistoryBottomSheet
     ├── HistoryHeaderWidget  (título + botão limpar)
     └── HistoryListWidget
           └── HistoryItemWidget × N  (toque → useHistoryResult)
```

## Dependências Principais

| Pacote | Versão | Descrição |
|--------|--------|-----------|
| `flutter_neumorphic_plus` | ^3.5.0 | Design system neumórfico |
| `shared_preferences` | ^2.5.4 | Persistência local de histórico |
| `intl` | ^0.20.2 | Formatação de números (pt_BR) e datas |
| `cupertino_icons` | ^1.0.8 | Ícones estilo iOS |

Dev:

| Pacote | Versão | Descrição |
|--------|--------|-----------|
| `flutter_lints` | ^6.0.0 | Regras de análise estática |
| `flutter_test` | sdk | Framework de testes |

## Convenções

### Nomenclatura de Arquivos
- Widgets: `*_widget.dart`
- Pages: `*_page.dart`
- Controllers: `*_controller.dart`
- Services: `*_service.dart`
- Models: nome no singular (ex: `calculation_history.dart`)
- Enums: `*_type.dart`

### Widgets
- Todos os widgets são classes (`StatelessWidget` ou `StatefulWidget`)
- Não usar funções que retornam `Widget`
- Usar `const` quando possível
- Parâmetros obrigatórios com `required`
- Acessibilidade: `Semantics` em elementos interativos

### Formatação Numérica
- Separador decimal: vírgula (`,`) — padrão brasileiro
- Separador de milhar: ponto (`.`)
- Notação científica automática para valores >= 1e12
- Limite de entrada: 15 dígitos

### Tratamento de Erros
- Padrão `Result<T>` para operações que podem falhar
- `ErrorHandler` centraliza validações (NaN, Infinity, overflow, divisão por zero)
- Erros exibidos no display (ex: `"Erro: Div/0"`)

## Cobertura de Testes

| Camada | Arquivo de Teste | Status |
|--------|-----------------|--------|
| Controller | `calculator_controller_test.dart` | ~140 testes — completo |
| Page | `calculator_page_test.dart` | Fluxos principais |
| Utils | `number_formatter_test.dart` | Formatação e parse |
| Widget: button | `button_widget_test.dart` | Renderização e click |
| Widget: display | `calculator_display_widget_test.dart` | Display e overflow |
| Widget: keypad | `calculator_keypad_widget_test.dart` | Grade de botões |
| Widget: layouts | — | Sem cobertura (pendente #44) |
| Widget: histórico | — | Sem cobertura (pendente #44) |
| Mock | `mock_storage_service.dart` | Mock para testes isolados |

## Comandos Úteis

```bash
# Dependências
flutter pub get

# Executar
flutter run

# Análise estática
flutter analyze

# Testes
flutter test

# Testes com cobertura
flutter test --coverage

# Build
flutter build apk        # Android
flutter build ios        # iOS
flutter build windows    # Windows
```

---

*Última atualização: 01/05/2026*
