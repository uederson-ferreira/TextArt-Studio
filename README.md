<div align="center">

# TextArt Studio

**Editor criativo de texto e elementos visuais para Android, iOS e Web (PWA)**

[![Flutter](https://img.shields.io/badge/Flutter-3.41.1-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Clean_Architecture-BLoC-7C3AED?style=for-the-badge)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-MIT-EC4899?style=for-the-badge)](LICENSE)

[Reportar Bug](https://github.com/uederson-ferreira/TextArt-Studio/issues) · [Solicitar Feature](https://github.com/uederson-ferreira/TextArt-Studio/issues)

</div>

---

## Sobre o Projeto

TextArt Studio é um editor criativo *mobile-first* que permite adicionar textos estilizados, stickers e elementos visuais sobre qualquer fundo. Focado em oferecer a maior variedade de fontes e recursos de customização, com experiência fluida e intuitiva.

**Diferenciais:**
- Mais de **900 fontes** via Google Fonts com preview em tempo real
- Canvas interativo com gestos naturais (mover, escalar, rotacionar)
- Sistema de **Undo/Redo** com até 30 estados
- **Persistência local** automática de projetos (sem login necessário)
- Exportação em PNG de alta resolução
- Design *dark-first* com identidade visual própria

---

## Funcionalidades Implementadas (MVP)

| Feature | Status |
|---|---|
| Canvas com múltiplos elementos | ✅ |
| Gestos: mover, escalar, rotacionar | ✅ |
| Seleção e deleção de elementos | ✅ |
| Adicionar texto com fonte personalizada | ✅ |
| Seletor de fontes (28 fontes curadas + busca) | ✅ |
| Paleta de cores rápidas para texto | ✅ |
| Editar texto já posicionado no canvas | ✅ |
| Ajuste de tamanho via slider | ✅ |
| Stickers / Emojis | ✅ |
| Fundo colorido (12 cores predefinidas) | ✅ |
| Exportar PNG e compartilhar | ✅ |
| Persistência local de projetos (SharedPreferences) | ✅ |
| Auto-save ao sair do editor | ✅ |
| Undo / Redo (30 estados) | ✅ |
| Home com grid de projetos recentes | ✅ |
| Deletar projeto (long press) | ✅ |
| Navegação com animação de slide | ✅ |
| Tema dark com identidade visual própria | ✅ |
| Suporte Android / iOS / Web (PWA) | ✅ |

---

## Stack & Arquitetura

### Tecnologias

| Categoria | Pacote | Versão |
|---|---|---|
| Framework | Flutter | 3.41.1 |
| Estado | flutter_bloc + equatable | ^8.1.6 |
| Navegação | go_router | ^14.3.0 |
| Injeção de dependência | get_it | ^8.0.2 |
| Fontes | google_fonts | ^6.2.1 |
| SVG / Animações | flutter_svg + lottie | ^2.0.10 / ^3.1.2 |
| Persistência local | shared_preferences | ^2.3.2 |
| Export / Share | screenshot + share_plus | ^3.0.0 / ^10.0.2 |
| Firebase (preparado) | firebase_core + auth + firestore | ^3.4.0 |

### Padrão Arquitetural

O projeto segue **Clean Architecture** com separação em três camadas por feature:

```
Presentation  →  BLoC (eventos, estados, bloc)
                 Pages + Widgets
Domain        →  Entities + Repository interfaces
Data          →  Repository implementations + Datasources
```

Comunicação unidirecional: `UI → Event → BLoC → State → UI`

---

## Estrutura do Projeto

```
lib/
├── app.dart                        # MaterialApp.router + tema
├── main.dart                       # Entry point (prod)
├── main_dev.dart                   # Entry point (dev)
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Paleta de cores + gradientes
│   │   ├── app_typography.dart     # Estilos de texto (Poppins + Inter)
│   │   ├── app_sizes.dart          # Grid 4px: espaçamentos, radii, durações
│   │   └── app_constants.dart      # Limites de negócio, chaves, categorias
│   ├── theme/
│   │   └── app_theme.dart          # ThemeData dark + light
│   ├── navigation/
│   │   └── app_router.dart         # GoRouter: /, /editor, /editor/:id
│   └── di/
│       └── injection_container.dart # GetIt: setup de todos os deps
│
├── features/
│   ├── home/
│   │   └── presentation/pages/home_page.dart
│   │
│   ├── editor/
│   │   ├── domain/entities/
│   │   │   ├── project.dart        # Project + CanvasBackground enum
│   │   │   ├── text_element.dart   # TextElement + serialização JSON
│   │   │   └── sticker_element.dart
│   │   └── presentation/
│   │       ├── bloc/               # EditorBloc, Events, State, HistoryManager
│   │       ├── pages/editor_page.dart
│   │       └── widgets/
│   │           ├── canvas_widget.dart          # Render + gestos
│   │           ├── editor_toolbar.dart         # Toolbar + painéis
│   │           └── element_controls_overlay.dart
│   │
│   ├── projects/
│   │   ├── domain/repositories/project_repository.dart
│   │   ├── data/repositories/project_repository_impl.dart  # SharedPreferences
│   │   └── presentation/bloc/      # ProjectBloc, Events, State
│   │
│   ├── fonts/
│   │   ├── domain/                 # FontEntity + FontCategory
│   │   ├── data/                   # FontRepositoryImpl (28 fontes curadas)
│   │   └── presentation/           # FontBloc + FontPickerPage
│   │
│   ├── stickers/
│   │   ├── domain/                 # StickerEntity + StickerCategory
│   │   ├── data/                   # StickerRepositoryImpl (50 emojis)
│   │   └── presentation/           # StickerBloc + StickerPickerPage
│   │
│   └── export/
│       ├── domain/usecases/export_to_image.dart  # RepaintBoundary → PNG
│       └── presentation/widgets/export_options_sheet.dart
│
└── shared/
    └── widgets/
        ├── gradient_button.dart        # Botão primário com gradiente
        ├── premium_badge.dart          # Badge dourado Premium
        └── premium_lock_overlay.dart   # Blur + lock icon + CTA
```

---

## Como Executar

### Pré-requisitos

- [Flutter SDK 3.41+](https://docs.flutter.dev/get-started/install) instalado
- Para iOS: Xcode 15+ e CocoaPods
- Para Android: Android Studio com SDK 21+

### Instalação

```bash
# 1. Clone o repositório
git clone https://github.com/uederson-ferreira/TextArt-Studio.git
cd TextArt-Studio

# 2. Instale as dependências
flutter pub get

# 3. Execute (escolha a plataforma)
flutter run -d chrome        # Web / PWA
flutter run -d android       # Android
flutter run -d ios           # iOS
```

### Verificar dispositivos disponíveis

```bash
flutter devices
```

---

## Testes

```bash
# Rodar testes unitários e de widget
flutter test

# Analisar código
flutter analyze
```

---

## Roadmap

### v1.0 — MVP (atual)
- [x] Canvas interativo com texto e stickers
- [x] 28 fontes Google Fonts com seletor e busca
- [x] Edição em tempo real de elementos no canvas
- [x] Persistência local automática de projetos
- [x] Exportação PNG + compartilhamento
- [x] Undo / Redo (30 estados)

### v1.1 — Qualidade do Editor
- [ ] Duplo-toque para editar texto diretamente no canvas
- [ ] Seletor de cor completo (color wheel)
- [ ] Alinhamento de texto (esquerda / centro / direita)
- [ ] Sombra e contorno configuráveis via painel
- [ ] Fundo com imagem da galeria (image_picker)
- [ ] SVG reais via Twemoji (flutter_svg)
- [ ] Ordenação de camadas (Z-index)

### v1.2 — Backend & Sync
- [ ] Firebase Auth (Google / Apple / Email)
- [ ] Sincronização de projetos no Firestore
- [ ] Upload de thumbnails no Firebase Storage

### v2.0 — Premium
- [ ] Exportação em vídeo MP4 (Lottie + ffmpeg)
- [ ] Mais de 500 fontes desbloqueadas
- [ ] Exportação 4K (pixel ratio 4×)
- [ ] Paywall via RevenueCat

---

## Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature
   ```bash
   git checkout -b feature/minha-feature
   ```
3. Commit com mensagem descritiva (seguindo [Conventional Commits](https://www.conventionalcommits.org/pt-br/))
   ```bash
   git commit -m "feat: adiciona seletor de cor avançado"
   ```
4. Push para a branch
   ```bash
   git push origin feature/minha-feature
   ```
5. Abra um Pull Request

---

## Licença

Distribuído sob a licença MIT. Veja [`LICENSE`](LICENSE) para mais informações.

---

<div align="center">

Feito com Flutter por [Uederson Ferreira](https://github.com/uederson-ferreira)

</div>
