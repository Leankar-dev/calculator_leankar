# Estrutura do Projeto - Calculator Leankar

## Visao Geral

Aplicativo de calculadora Flutter com design neumórfico, seguindo o padrão MVC simplificado.

## Arvore de Diretorios

```
calculator_leankar/
├── lib/
│   ├── main.dart                    # Ponto de entrada do app
│   ├── app_calculator.dart          # Configuracao do NeumorphicApp
│   │
│   ├── controllers/
│   │   └── calculator_controller.dart   # Logica de negocio e estado
│   │
│   ├── models/
│   │   └── calculation_history.dart     # Modelo de historico de calculos
│   │
│   ├── pages/
│   │   └── calculator_page.dart         # Pagina principal da calculadora
│   │
│   ├── services/
│   │   ├── error_handler.dart           # Tratamento de erros
│   │   ├── logger_service.dart          # Servico de logging
│   │   └── storage_service.dart         # Persistencia de dados
│   │
│   ├── utils/
│   │   ├── constants.dart               # Constantes do app (cores, tamanhos)
│   │   ├── number_formatter.dart        # Formatacao de numeros
│   │   ├── responsive_utils.dart        # Utilitarios responsivos
│   │   ├── result.dart                  # Classe Result para tratamento de erros
│   │   └── enums/
│   │       ├── error_type.dart          # Tipos de erro
│   │       └── operations_type.dart     # Tipos de operacoes matematicas
│   │
│   └── widgets/
│       ├── button_widget.dart               # Botao neumórfico reutilizavel
│       ├── calculator_display_widget.dart   # Display da calculadora
│       ├── calculator_footer_widget.dart    # Rodape com logo
│       ├── calculator_keypad_widget.dart    # Teclado numerico completo
│       ├── first_row_widget.dart            # Linha: C, backspace, %
│       ├── number_row_widget.dart           # Linha de numeros + operacao
│       ├── last_row_widget.dart             # Linha: 0, virgula, =, +
│       ├── history_bottom_sheet.dart        # Bottom sheet do historico
│       ├── history_header_widget.dart       # Cabecalho do historico
│       ├── history_empty_state_widget.dart  # Estado vazio do historico
│       ├── history_item_widget.dart         # Item individual do historico
│       ├── history_list_widget.dart         # Lista de itens do historico
│       ├── portrait_layout_widget.dart      # Layout modo retrato
│       └── landscape_layout_widget.dart     # Layout modo paisagem
│
├── assets/
│   └── images/
│       └── logo2.png                # Logo da Leankar
│
├── test/
│   └── widget_test.dart             # Testes de widget
│
├── docs/
│   ├── structure.md                 # Este arquivo
│   └── release-notes-internal-testing.txt
│
├── android/                         # Configuracoes Android
├── ios/                             # Configuracoes iOS
├── web/                             # Configuracoes Web
├── windows/                         # Configuracoes Windows
│
├── pubspec.yaml                     # Dependencias do projeto
├── CLAUDE.md                        # Instrucoes para o Claude Code
└── README.md                        # Documentacao principal
```

## Arquitetura

### Padrao MVC Simplificado

```
┌─────────────────────────────────────────────────────────────┐
│                         View (UI)                           │
│  ┌─────────────────┐  ┌─────────────────────────────────┐  │
│  │  calculator_    │  │           widgets/              │  │
│  │  page.dart      │  │  - button_widget                │  │
│  │                 │  │  - calculator_display_widget    │  │
│  │  Escuta o       │  │  - calculator_keypad_widget     │  │
│  │  controller     │  │  - portrait_layout_widget       │  │
│  │                 │  │  - landscape_layout_widget      │  │
│  │                 │  │  - history_bottom_sheet         │  │
│  └────────┬────────┘  └─────────────────────────────────┘  │
│           │                                                 │
└───────────┼─────────────────────────────────────────────────┘
            │ ListenableBuilder
            ▼
┌─────────────────────────────────────────────────────────────┐
│                   Controller (Logica)                       │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              calculator_controller.dart              │   │
│  │                                                      │   │
│  │  - Gerencia estado (ChangeNotifier)                  │   │
│  │  - Operacoes matematicas                             │   │
│  │  - Historico de calculos                             │   │
│  │  - Notifica listeners (notifyListeners)              │   │
│  └─────────────────────────────────────────────────────┘   │
│                           │                                 │
└───────────────────────────┼─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Model / Services                         │
│  ┌──────────────────┐  ┌────────────────────────────────┐  │
│  │ calculation_     │  │         services/              │  │
│  │ history.dart     │  │  - storage_service             │  │
│  │                  │  │  - logger_service              │  │
│  │                  │  │  - error_handler               │  │
│  └──────────────────┘  └────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Fluxo de Dados

```
Usuario toca botao
        │
        ▼
ButtonWidget (onPressed)
        │
        ▼
CalculatorPage (callback)
        │
        ▼
CalculatorController (metodo)
        │
        ├── Atualiza estado interno
        ├── Salva historico (StorageService)
        └── Chama notifyListeners()
                    │
                    ▼
            ListenableBuilder
                    │
                    ▼
            UI atualizada (rebuild)
```

## Dependencias Principais

| Pacote | Versao | Descricao |
|--------|--------|-----------|
| flutter_neumorphic_plus | ^3.3.0 | Design neumórfico |
| shared_preferences | ^2.2.2 | Persistencia local |
| intl | ^0.19.0 | Formatacao de datas |

## Convencoes

### Nomenclatura de Arquivos
- Widgets: `*_widget.dart`
- Pages: `*_page.dart`
- Controllers: `*_controller.dart`
- Services: `*_service.dart`
- Models: nome no singular `.dart`
- Enums: `*_type.dart`

### Widgets
- Todos os widgets sao classes (StatelessWidget ou StatefulWidget)
- Nao usar funcoes que retornam Widget
- Usar `const` quando possivel
- Parametros obrigatorios com `required`

### Formatacao
- Separador decimal: virgula (`,`) - padrao brasileiro
- Simbolos Unicode para operacoes matematicas

## Comandos Uteis

```bash
# Dependencias
flutter pub get

# Executar
flutter run

# Analise estatica
flutter analyze

# Testes
flutter test

# Build
flutter build apk        # Android
flutter build ios        # iOS
flutter build windows    # Windows
```
