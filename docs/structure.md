# Estrutura do Projeto - Calculator Leankar

## Visão Geral

Aplicativo de calculadora Flutter com design neumórfico, seguindo um padrão de controllers (`ChangeNotifier`) + páginas + widgets, sem framework de DI.
Versão atual: **0.10.2+10** | SDK Dart: `^3.12.0`

## Árvore de Diretórios

```
calculator_leankar/
│
├── lib/
│   ├── main.dart                              # Ponto de entrada: carrega settings/consentimento, roda o app
│   ├── app_calculator.dart                    # NeumorphicApp: tema, locale, delegates de l10n
│   │
│   ├── controllers/
│   │   ├── calculator_controller.dart         # Estado e lógica de negócio da calculadora (ChangeNotifier)
│   │   ├── calculator_state.dart              # Estado imutável da calculadora (copyWith)
│   │   ├── imc_controller.dart                # Estado e lógica de negócio do IMC (ChangeNotifier)
│   │   ├── settings_controller.dart           # Tema, idioma e detecção de instalação/atualização
│   │   ├── ad_consent_controller.dart         # Diálogo de consentimento próprio para anúncios (sem UMP)
│   │   └── ad_consent_state.dart              # Estado imutável do consentimento de anúncios
│   │
│   ├── models/
│   │   ├── calculation_history.dart           # Modelo de histórico com serialização JSON
│   │   └── imc_result.dart                    # Modelo do resultado de IMC (classificação, peso ideal)
│   │
│   ├── pages/
│   │   ├── calculator_page.dart               # Página principal com KeyboardListener
│   │   ├── imc_calculator_page.dart           # Página da calculadora de IMC
│   │   └── settings_page.dart                 # Página de configurações (tema/idioma)
│   │
│   ├── services/
│   │   ├── error_handler.dart                 # Singleton: validação e tratamento de erros
│   │   ├── logger_service.dart                # Singleton: logging com níveis (debug/info/warn/error)
│   │   ├── storage_service.dart               # Wrapper SharedPreferences para histórico
│   │   └── level_play_ad_service.dart         # Inicialização do SDK Unity LevelPlay (Android)
│   │
│   ├── widgets/
│   │   ├── Botões e display
│   │   │   ├── button_widget.dart               # Botão neumórfico com Semantics e HapticFeedback
│   │   │   ├── calculator_display_widget.dart   # Display côncavo: expressão + resultado
│   │   │   └── calculator_footer_widget.dart    # Rodapé com logo Leankar
│   │   │
│   │   ├── Teclado
│   │   │   ├── calculator_keypad_widget.dart    # Container do teclado numérico
│   │   │   ├── first_row_widget.dart            # Linha: C, ⌫, %
│   │   │   ├── number_row_widget.dart           # Linha genérica: 3 números + operação
│   │   │   └── last_row_widget.dart             # Linha: 0, vírgula, =, +
│   │   │
│   │   ├── Layouts
│   │   │   ├── portrait_layout_widget.dart      # Column: display → keypad → footer
│   │   │   └── landscape_layout_widget.dart     # Row flex 2:3 (display : keypad)
│   │   │
│   │   ├── Histórico e navegação
│   │   │   ├── history_bottom_sheet.dart        # Bottom sheet 60% altura
│   │   │   ├── history_header_widget.dart       # Cabeçalho com botão limpar
│   │   │   ├── history_list_widget.dart         # ListView.builder do histórico
│   │   │   ├── history_item_widget.dart         # Item: expressão + resultado + data
│   │   │   ├── history_empty_state_widget.dart  # Estado vazio com ícone
│   │   │   └── app_drawer_widget.dart           # Drawer: acesso a IMC e Configurações
│   │   │
│   │   ├── imc/
│   │   │   ├── imc_input_field_widget.dart      # Campo de entrada de peso/altura
│   │   │   ├── imc_calculate_button_widget.dart # Botão de calcular
│   │   │   ├── imc_result_card_widget.dart      # Card com o resultado numérico do IMC
│   │   │   ├── imc_classification_badge_widget.dart # Badge com a classificação (abaixo/normal/acima etc.)
│   │   │   ├── imc_gauge_widget.dart            # Gauge visual da faixa de IMC
│   │   │   └── imc_ideal_weight_widget.dart     # Faixa de peso ideal calculada
│   │   │
│   │   ├── settings/
│   │   │   ├── theme_selector_widget.dart       # Seletor segmentado de tema (claro/escuro/sistema)
│   │   │   ├── language_selector_widget.dart    # Seletor de idioma
│   │   │   └── app_info_card_widget.dart        # Card com versão do app (package_info_plus)
│   │   │
│   │   └── ads/
│   │       ├── ad_banner_footer_widget.dart     # Decide exibir banner/placeholder; vazio fora do Android
│   │       ├── banner_ad_widget.dart            # Wrapper do banner do Unity LevelPlay
│   │       ├── banner_ad_placeholder_widget.dart# Placeholder enquanto o SDK carrega
│   │       └── ad_consent_dialog_widget.dart    # Diálogo de aceitar/recusar anúncios
│   │
│   ├── utils/
│   │   ├── constants/
│   │   │   ├── app_colors.dart                  # Paleta de cores (tema claro/escuro)
│   │   │   ├── app_sizes.dart                   # Tamanhos, paddings, depths neumórficos
│   │   │   ├── app_strings.dart                 # Strings fixas e chaves de SharedPreferences
│   │   │   └── app_ad_unit_ids.dart              # ID do banner do Unity LevelPlay
│   │   ├── enums/
│   │   │   ├── error_type.dart                  # Tipos de erro da calculadora
│   │   │   ├── operations_type.dart             # Operações aritméticas (+, -, ×, ÷)
│   │   │   ├── paste_result.dart                # Resultado da operação de colar (Ctrl+V)
│   │   │   ├── ad_consent_load_status.dart      # Estados do fluxo de consentimento de anúncios
│   │   │   ├── imc_error_type.dart              # Erros de validação do IMC
│   │   │   └── imc_classification.dart          # Faixas de classificação do IMC
│   │   ├── extensions/
│   │   │   └── imc_classification_l10n_extension.dart # Tradução da classificação de IMC
│   │   ├── env/
│   │   │   ├── app_env.dart                     # Declaração @Envied (UNITY_APP_KEY_ANDROID)
│   │   │   └── app_env.g.dart                   # Gerado por build_runner — NUNCA editar manualmente
│   │   ├── number_formatter.dart                # Formatação pt_BR, notação científica, parse
│   │   ├── responsive_utils.dart                # Tamanhos adaptativos por largura de tela
│   │   └── result.dart                          # Result<T> — padrão Either para erros funcionais
│   │
│   └── l10n/
│       ├── app_en.arb / app_es.arb / app_fr.arb / app_it.arb / app_pt.arb / app_pt_BR.arb  # Fontes
│       └── app_localizations*.dart              # Gerado por `flutter gen-l10n` — NUNCA editar manualmente
│
├── test/                                        # Espelha a estrutura de lib/ (mesmas subpastas)
│   ├── controllers/    # calculator, imc, settings, ad_consent
│   ├── mocks/          # mock_storage_service, mock_logger_service, mock_error_handler, mock_level_play_ad_service
│   ├── models/         # imc_result
│   ├── pages/          # calculator_page, imc_calculator_page, settings_page
│   ├── services/       # level_play_ad_service
│   ├── utils/          # number_formatter, enums/imc_classification
│   ├── helpers/        # l10n_test_app.dart — app de teste com AppLocalizations
│   └── widgets/        # button, display, keypad, layouts, histórico, imc/, settings/, ads/
│
├── assets/
│   └── images/                               # Logo da Leankar
│
├── docs/
│   ├── structure.md                          # Este arquivo
│   ├── politica_privacidade/index.md         # Política de privacidade (EN/PT-BR/ES/FR)
│   └── melhorias/                            # Backlog e planos de migração (ex.: AdMob → Unity LevelPlay)
│
├── android/                                  # Configurações Android (único alvo com anúncios)
├── ios/                                      # Configurações iOS
├── web/                                      # Configurações Web
├── windows/                                  # Configurações Windows
│
├── .env.example                              # Modelo de variáveis de ambiente (copiar para .env)
├── .env                                      # Não versionado — UNITY_APP_KEY_ANDROID
├── analysis_options.yaml                     # Regras de lint (flutter_lints, sem regras customizadas)
├── l10n.yaml                                 # Configuração do flutter gen-l10n
├── pubspec.yaml                              # Dependências do projeto
├── CLAUDE.md                                 # Instruções para o Claude Code
└── README.md                                 # Documentação principal
```

## Arquitetura

### Padrão Controller + Página + Widgets

```
┌──────────────────────────────────────────────────────────────────┐
│                           View (UI)                              │
│  ┌──────────────────────┐  ┌────────────────────────────────┐   │
│  │  calculator_page.dart│  │          widgets/              │   │
│  │  imc_calculator_page │  │  - layouts, keypad, display     │   │
│  │  settings_page       │  │  - imc/, settings/, ads/         │   │
│  │                      │  │                                  │   │
│  │  KeyboardListener    │  │                                  │   │
│  │  ListenableBuilder   │  │                                  │   │
│  └──────────┬───────────┘  └────────────────────────────────┘   │
└─────────────┼────────────────────────────────────────────────────┘
              │ ListenableBuilder / callbacks
              ▼
┌──────────────────────────────────────────────────────────────────┐
│                    Controllers (ChangeNotifier)                  │
│  calculator_controller │ imc_controller │ settings_controller     │
│  ad_consent_controller                                            │
│                                                                    │
│  Dependências injetadas via construtor opcional, com fallback     │
│  para singleton: `Service? service, ... service ?? Service.instance`│
└─────────────────────────────┬────────────────────────────────────┘
                              │
              ┌───────────────┼──────────────────┬─────────────────┐
              ▼               ▼                  ▼                 ▼
┌─────────────────┐ ┌─────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│ storage_service │ │ error_handler /  │ │ level_play_ad_   │ │ calculation_      │
│ .dart           │ │ logger_service   │ │ service.dart     │ │ history.dart /    │
│                 │ │ .dart            │ │                  │ │ imc_result.dart   │
│ SharedPrefs     │ │ Singletons       │ │ SDK Unity        │ │ Modelos com       │
│ JSON encode/    │ │ globais          │ │ LevelPlay        │ │ serialização e    │
│ decode          │ │                  │ │ (Android only)   │ │ tryFromJson seguro│
└─────────────────┘ └─────────────────┘ └──────────────────┘ └──────────────────┘
```

### Fluxo de Dados — Operação Típica da Calculadora

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
              ├── Atualiza estado interno (CalculatorState imutável)
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

### Fluxo de Consentimento de Anúncios (Android apenas)

```
main() → AdConsentController.instance.loadPersistedConsent()
              │
              ▼
   CalculatorPage.initState()
     ├── AdConsentController.instance.addListener(...)
     └── AdConsentController.instance.initialize()
              │
              ├── Sem preferência salva → loadStatus = pendingUserChoice
              │        │
              │        ▼
              │   AdConsentDialogWidget exibido (aceitar/recusar)
              │        │
              │        ▼
              │   submitUserChoice(accepted)
              │
              └── Preferência salva → _applyConsent(valor salvo)
                          │
                          ├── LevelPlayPrivacySettings.setGDPRConsents({'UnityAds': accepted})
                          ├── Se accepted == true → LevelPlayAdService.initialize()
                          └── Se accepted == false → SDK nunca é inicializado, nenhum anúncio é exibido

AdBannerFooterWidget
  ├── Plataforma != Android → SizedBox.shrink()
  ├── loadStatus == loading → BannerAdPlaceholderWidget
  ├── canRequestAds == false → SizedBox.shrink()
  └── canRequestAds == true → BannerAdWidget
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

Usuário abre histórico (drawer ou atalho `H`)
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
| `shared_preferences` | ^2.5.5 | Persistência local (histórico, tema, idioma, consentimento) |
| `intl` | ^0.20.2 | Formatação de números (pt_BR) e datas |
| `package_info_plus` | ^10.1.0 | Versão/build do app (tela de configurações, detecção de update) |
| `unity_levelplay_mediation` | ^9.2.0 | Anúncios banner via Unity LevelPlay (Android apenas) |
| `envied` | ^1.3.8 | Exposição ofuscada da chave do Unity App a partir de `.env` |
| `cupertino_icons` | ^1.0.8 | Ícones estilo iOS |

Dev:

| Pacote | Versão | Descrição |
|--------|--------|-----------|
| `flutter_lints` | ^6.0.0 | Regras de análise estática |
| `flutter_test` | sdk | Framework de testes |
| `envied_generator` | ^1.3.8 | Gera `app_env.g.dart` a partir de `@Envied` |
| `build_runner` | ^2.15.1 | Executa os geradores de código (envied) |

## Convenções

### Nomenclatura de Arquivos
- Widgets: `*_widget.dart`
- Pages: `*_page.dart`
- Controllers: `*_controller.dart`
- Services: `*_service.dart`
- Models: nome no singular (ex: `calculation_history.dart`)
- Enums: `*_type.dart` ou nome descritivo (ex: `imc_classification.dart`)

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

### Ambiente e Build
- `.env` (não versionado, ver `.env.example`) fornece `UNITY_APP_KEY_ANDROID`
- `envied` + `build_runner` geram `lib/utils/env/app_env.g.dart` — nunca editar manualmente, sempre regenerar com `dart run build_runner build --delete-conflicting-outputs`
- Anúncios (Unity LevelPlay) só existem no Android; iOS/Web/Windows não têm integração de anúncios

## Cobertura de Testes

O projeto tem **383 testes automatizados**, todos passando (`flutter test`), organizados espelhando a estrutura de `lib/`:

| Camada | Diretório de Teste | Cobre |
|--------|--------------------|-------|
| Controllers | `test/controllers/` | calculator, imc, settings, ad_consent |
| Models | `test/models/` | imc_result |
| Pages | `test/pages/` | calculator_page, imc_calculator_page, settings_page |
| Services | `test/services/` | level_play_ad_service |
| Utils | `test/utils/` | number_formatter, enums (imc_classification) |
| Widgets | `test/widgets/` | botão, display, teclado, layouts, histórico, drawer |
| Widgets: imc | `test/widgets/imc/` | input, badge, gauge, result card, peso ideal, botão calcular |
| Widgets: settings | `test/widgets/settings/` | app_info_card, theme_selector |
| Widgets: ads | `test/widgets/ads/` | banner_ad, banner_ad_placeholder, ad_consent_dialog |
| Mocks | `test/mocks/` | mock_storage_service, mock_logger_service, mock_error_handler, mock_level_play_ad_service (injetados via construtor, sem `mockito`/`mocktail`) |

## Comandos Úteis

```bash
# Dependências
flutter pub get

# Criar .env a partir do exemplo e preencher UNITY_APP_KEY_ANDROID
cp .env.example .env

# Gerar código (envied) — necessário antes de rodar/buildar
dart run build_runner build --delete-conflicting-outputs

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

*Última atualização: 08/08/2026*
