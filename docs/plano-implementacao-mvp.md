# TextArt Studio — Plano de Implementação MVP

> **Stack:** Flutter 3.41.1 + Dart 3.11.0 | **Arquitetura:** Clean Architecture + BLoC
> **Plataformas:** Android · iOS · PWA
> **Última atualização:** 2026-02-19

---

## Status Geral

| Fase | Descrição | Status |
|------|-----------|--------|
| 0 | Instalar Flutter | ✅ Concluído |
| 1 | Criar projeto Flutter | ✅ Concluído |
| 2 | pubspec.yaml + assets | ✅ Concluído |
| 3 | Arquivos base (core, DI, navegação, entry points) | ✅ Concluído |
| 4 | Firebase setup | ⏳ Pendente |
| 5 | Features: Editor, Fontes, Stickers, Export | ✅ Concluído (MVP) |
| 6 | Permissões de plataforma | ✅ Concluído |
| 7 | RevenueCat + Paywall | ❌ Não iniciado |
| 8 | Auth (Google/Apple/Email) | ❌ Não iniciado |
| 9 | Persistência de projetos (Firestore) | ❌ Não iniciado |
| 10 | Export vídeo MP4 | ❌ Não iniciado |
| 11 | Testes + Loja (Play Store / App Store) | ❌ Não iniciado |

**Validação técnica:** `flutter analyze lib/` → 0 issues · `flutter build web` → ✅ Built

---

## Fase 0 — Flutter Instalado ✅

**Como foi feito:**
```bash
brew install flutter        # Flutter 3.41.1 / Dart 3.11.0
brew install cocoapods      # CocoaPods 1.16.2
```

**Estado atual do `flutter doctor`:**
```
[✓] Flutter (Channel stable, 3.41.1)
[✗] Android toolchain — Android Studio não instalado (SDK ausente)
[✓] Xcode 26.2 — CocoaPods instalado
[✓] Chrome — web OK
[✓] Network resources
```

> **Nota:** Android toolchain sem SDK. Para buildar Android, instalar Android Studio
> ou configurar `ANDROID_HOME` manualmente. Para o MVP web, não é bloqueante.

---

## Fase 1 — Projeto Flutter Criado ✅

**Estrutura gerada:**
```
TextArt-Studio/
├── android/          ✅
├── ios/              ✅
├── web/              ✅
├── test/             ✅
├── analysis_options.yaml  ✅
├── pubspec.yaml      ✅
└── lib/              (preservado — arquivos de tema existentes mantidos)
```

**Estratégia usada:** criado em `/tmp/textart_temp` e mesclado no projeto real,
preservando `lib/core/` já existente.

---

## Fase 2 — pubspec.yaml Implementado ✅

**Versões reais instaladas (resolvidas com sucesso):**

```yaml
# Canvas
flutter_painter_v2: ^2.1.0+1   # ⚠️ v2.1.1 não existe — usar ^2.1.0+1

# Fontes
google_fonts: ^6.2.1

# Stickers / Animação / Imagens
flutter_svg: ^2.0.10+1
lottie: ^3.1.2
cached_network_image: ^3.3.1

# Export / Share
screenshot: ^3.0.0
image: ^4.2.0
image_gallery_saver: ^2.0.3    # ⚠️ gallery_saver incompatível com google_fonts (conflito http)
share_plus: ^10.0.2

# Firebase
firebase_core: ^3.4.0
firebase_auth: ^5.2.0
cloud_firestore: ^5.3.0
firebase_storage: ^12.2.0
firebase_remote_config: ^5.1.0
firebase_analytics: ^11.3.0

# Estado
flutter_bloc: ^8.1.6
equatable: ^2.0.5

# Local Storage
hive_flutter: ^1.1.0
shared_preferences: ^2.3.2

# Navegação
go_router: ^14.3.0

# DI
get_it: ^8.0.2

# Network / Utils
dio: ^5.7.0
image_picker: ^1.1.2
path_provider: ^2.1.4
uuid: ^4.5.0
```

**Diretórios de assets criados:**
```
assets/
├── fonts/         (fontes locais — vazias; google_fonts faz download automático)
├── stickers/
│   ├── twemoji/   (SVGs — a preencher)
│   └── shapes/    (SVGs — a preencher)
├── lottie/        (JSONs — a preencher)
└── images/        (imagens estáticas — a preencher)
```

> **Decisão:** fontes NÃO estão bundled no app — `google_fonts` faz download/cache
> automaticamente. Não declarar `fonts:` no pubspec sem ter os arquivos .ttf locais.

**Pacotes removidos/substituídos:**
| Pacote original | Motivo | Substituído por |
|---|---|---|
| `matrix_gesture_detector` | Dart 3 incompatível (6 anos sem update) | `GestureDetector` nativo do Flutter |
| `gallery_saver ^2.3.2` | Conflito de `http` com `google_fonts ^6+` | `image_gallery_saver ^2.0.3` |

---

## Fase 3 — Arquivos Base Criados ✅

### 3.1 Core Constants

| Arquivo | Status | Conteúdo |
|---------|--------|----------|
| `lib/core/constants/app_colors.dart` | ✅ Pré-existia | Paleta dark/light + gradientes |
| `lib/core/constants/app_typography.dart` | ✅ Pré-existia | Hierarquia Poppins + Inter |
| `lib/core/theme/app_theme.dart` | ✅ Pré-existia | ThemeData dark + light completo |
| `lib/core/constants/app_sizes.dart` | ✅ Criado | Grade 4px, border radius, ícones, durações |
| `lib/core/constants/app_constants.dart` | ✅ Criado | Limites negócio, chaves Hive, categorias |

### 3.2 Navegação e DI

| Arquivo | Status | Conteúdo |
|---------|--------|----------|
| `lib/core/navigation/app_router.dart` | ✅ Criado | GoRouter: `/`, `/editor`, `/editor/:projectId` |
| `lib/core/di/injection_container.dart` | ✅ Criado | GetIt: FontRepository, StickerRepository, Blocs |

### 3.3 Entry Points

| Arquivo | Status | Conteúdo |
|---------|--------|----------|
| `lib/app.dart` | ✅ Criado | MaterialApp.router, dark-first, sem Firebase ainda |
| `lib/main.dart` | ✅ Criado | setupDependencies() + runApp — sem Firebase (pendente) |
| `lib/main_dev.dart` | ✅ Criado | Idêntico ao main.dart por ora |

---

## Fase 4 — Firebase Setup ⏳ PENDENTE

**Pré-requisitos:**
- [ ] Criar projeto no [console.firebase.google.com](https://console.firebase.google.com):
  - `textart-studio-prod`
  - `textart-studio-dev`
- [ ] Habilitar serviços: Auth, Firestore, Storage, Remote Config, Analytics, Crashlytics

**Comandos a executar:**
```bash
dart pub global activate flutterfire_cli

flutterfire configure \
  --project textart-studio-prod \
  --out lib/firebase_options.dart

flutterfire configure \
  --project textart-studio-dev \
  --out lib/firebase_options_dev.dart
```

**Depois de configurado, atualizar `lib/main.dart`:**
```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupDependencies();
  runApp(const TextArtStudioApp());
}
```

**Regras Firestore a configurar (ver `textart-studio-planejamento.md` seção 10.2)**

---

## Fase 5 — Features Implementadas ✅

### Sprint 1-2: Editor Base ✅

**Entities criadas:**

| Arquivo | Conteúdo |
|---------|----------|
| `lib/features/editor/domain/entities/text_element.dart` | id, text, fontFamily, fontSize, color, position, rotation, scale, opacity, shadow, stroke |
| `lib/features/editor/domain/entities/sticker_element.dart` | id, assetPath, type (svg/emoji/lottie/image), position, size, rotation, scale, opacity |
| `lib/features/editor/domain/entities/project.dart` | id, name, textElements, stickerElements, backgroundType, backgroundColor, backgroundImagePath, canvasWidth/Height |

**BLoC:**

| Arquivo | Conteúdo |
|---------|----------|
| `lib/features/editor/presentation/bloc/editor_bloc.dart` | Todos os handlers de evento |
| `lib/features/editor/presentation/bloc/editor_event.dart` | 14 eventos (Add/Update/Remove Text+Sticker, Select, Background, Undo, Redo, Save, Clear, Move, Scale, Rotate) |
| `lib/features/editor/presentation/bloc/editor_state.dart` | project, selectedElementId, canUndo, canRedo, status |
| `lib/features/editor/presentation/bloc/history_manager.dart` | Pilhas undo/redo, limite 30 estados |

**Pages e Widgets:**

| Arquivo | Conteúdo |
|---------|----------|
| `lib/features/editor/presentation/pages/editor_page.dart` | Scaffold completo, AppBar com undo/redo/save, canvas + toolbar |
| `lib/features/editor/presentation/widgets/canvas_widget.dart` | Stack em camadas: fundo → stickers → textos; GestureDetector por elemento |
| `lib/features/editor/presentation/widgets/editor_toolbar.dart` | 4 abas: Texto, Stickers, Fundo, Exportar; painéis expansíveis |
| `lib/features/editor/presentation/widgets/element_controls_overlay.dart` | Borda de seleção + botão delete no canto |
| `lib/features/home/presentation/pages/home_page.dart` | Hero com gradiente, grid de projetos (vazio no MVP), FAB "Novo Projeto" |

**Gestos implementados (sem `matrix_gesture_detector`):**
- `onPanUpdate` → move o elemento
- `onScaleUpdate` → escala + rotação simultâneas (gesture nativo Flutter)

---

### Sprint 3-4: Fontes ✅

| Arquivo | Conteúdo |
|---------|----------|
| `lib/features/fonts/domain/entities/font_entity.dart` | family, category (enum 6 categorias), isPremium, isCached |
| `lib/features/fonts/domain/repositories/font_repository.dart` | Interface abstrata |
| `lib/features/fonts/data/repositories/font_repository_impl.dart` | 28 fontes curadas (offline-first, sem Hive ainda — google_fonts cacheia automaticamente) |
| `lib/features/fonts/presentation/bloc/font_bloc.dart` | LoadByCategory, Search, Select |
| `lib/features/fonts/presentation/bloc/font_event.dart` | FontLoadByCategory, FontSearch, FontSelect |
| `lib/features/fonts/presentation/bloc/font_state.dart` | fonts, selectedCategory, searchQuery, selectedFamily |
| `lib/features/fonts/presentation/pages/font_picker_page.dart` | TabBar 6 categorias + busca + lista com preview em tempo real via GoogleFonts.getFont() |

**Fontes disponíveis no MVP (28):**
- Sem serifa: Roboto, Open Sans, Lato, Montserrat, Oswald, Raleway, Poppins, Inter, Nunito, Ubuntu
- Serifada: Playfair Display, Merriweather, Lora, PT Serif, Crimson Text
- Manuscrita: Pacifico, Dancing Script, Satisfy, Caveat, Kalam
- Display: Bebas Neue, Anton, Righteous, Abril Fatface, Fredoka One
- Mono: Source Code Pro, JetBrains Mono, Fira Code

---

### Sprint 5-6: Stickers ✅

| Arquivo | Conteúdo |
|---------|----------|
| `lib/features/stickers/domain/entities/sticker_entity.dart` | id, name, assetPath, category (enum 8 categorias), isPremium, isLocal |
| `lib/features/stickers/domain/repositories/sticker_repository.dart` | Interface abstrata |
| `lib/features/stickers/data/repositories/sticker_repository_impl.dart` | 50 emojis curados em 7 categorias (Rostos, Gestos, Objetos, Animais, Comida, Símbolos, Formas) |
| `lib/features/stickers/presentation/bloc/sticker_bloc.dart` | LoadByCategory, Search |
| `lib/features/stickers/presentation/bloc/sticker_event.dart` | StickerLoadByCategory, StickerSearch |
| `lib/features/stickers/presentation/bloc/sticker_state.dart` | stickers, selectedCategory |
| `lib/features/stickers/presentation/pages/sticker_picker_page.dart` | Grid 4 colunas + TabBar 8 categorias |

> **Nota:** Stickers atualmente renderizados como emoji texto. Para SVG real (Twemoji),
> adicionar arquivos em `assets/stickers/twemoji/` e atualizar `_buildStickerContent()`.

---

### Sprint 7-8: Export PNG ✅

| Arquivo | Conteúdo |
|---------|----------|
| `lib/features/export/domain/usecases/export_to_image.dart` | `RenderRepaintBoundary.toImage()` → adiciona watermark via Canvas API → retorna `Uint8List` |
| `lib/features/export/presentation/widgets/export_options_sheet.dart` | Preview, aviso watermark free, botões Salvar + Compartilhar (`Share.shareXFiles`) |

**API de share usada:** `Share.shareXFiles(files)` (share_plus 10.x)
**API de share NÃO compatível:** `SharePlus.instance.share(ShareParams(...))` → só share_plus 12+

---

### Shared Widgets ✅

| Arquivo | Conteúdo |
|---------|----------|
| `lib/shared/widgets/gradient_button.dart` | Botão gradiente violeta→rosa, largura full por padrão |
| `lib/shared/widgets/premium_badge.dart` | Badge dourado ⭐ PRO, modo compact |
| `lib/shared/widgets/premium_lock_overlay.dart` | BackdropFilter blur + lock + CTA upgrade |

---

## Fase 6 — Permissões de Plataforma ✅

### Android — `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29"/>
```

### iOS — `ios/Runner/Info.plist`
```xml
NSPhotoLibraryUsageDescription    → "TextArt Studio precisa acessar sua galeria..."
NSPhotoLibraryAddUsageDescription → "TextArt Studio precisa salvar imagens na sua galeria."
NSCameraUsageDescription          → "TextArt Studio precisa acessar sua câmera..."
```

---

## Decisões Técnicas Registradas

| Decisão | Motivo |
|---------|--------|
| `flutter_painter_v2: ^2.1.0+1` | v2.1.1 não existe no pub.dev |
| Remover `matrix_gesture_detector` | Dart 3 incompatível; Flutter nativo cobre o caso |
| Usar `image_gallery_saver` em vez de `gallery_saver` | `gallery_saver` conflita com `http ^1.x` do `google_fonts` |
| Fontes via `google_fonts` (sem bundle local) | Evita declarar assets inexistentes no pubspec; google_fonts tem cache HTTP automático |
| `Color.toARGB32()` em vez de `.value` | `.value` está deprecated no Flutter 3.41+ |
| `FontWeight.value` em vez de `.index` para serialização | `.index` está deprecated; `.value` retorna o peso real (400, 700...) |
| `Share.shareXFiles()` em vez de `SharePlus.instance.share()` | API nova só existe no share_plus 12+; temos 10.x |

---

## Checklist de Verificação por Sprint

### Sprint 1-2 (Fundação) — verificar manualmente
- [x] `flutter analyze lib/` → 0 issues
- [x] `flutter build web` → ✅ Built
- [ ] `flutter run -d chrome` abre home com fundo `#0A0A0F`
- [ ] AppBar sem elevação, texto branco
- [ ] Botão "Novo Projeto" com gradiente da marca
- [ ] Navegação home → editor funciona
- [ ] Undo/Redo funcionam no editor

### Sprint 3-4 (Fontes)
- [ ] Seletor de fontes abre
- [ ] Categorias em TabBar scrollável
- [ ] Preview mostra texto atual com a fonte
- [ ] Busca por nome funciona

### Sprint 5-6 (Stickers)
- [ ] Grid de stickers abre
- [ ] Sticker adicionado aparece no canvas
- [ ] Drag move o sticker
- [ ] Pinch redimensiona + rotaciona

### Sprint 7-8 (Export)
- [ ] Export gera imagem
- [ ] Marca d'água aparece no free
- [ ] Share abre share sheet

---

## Próximos Passos (em ordem de prioridade)

### P1 — Testar o app rodando
```bash
flutter run -d chrome       # Testar PWA no Chrome
flutter run                 # Testar no device iOS conectado
```

### P2 — Firebase (desbloqueia Auth + persistência)
1. Criar projetos no Firebase Console
2. `dart pub global activate flutterfire_cli`
3. `flutterfire configure` (prod + dev)
4. Atualizar `main.dart` com `Firebase.initializeApp()`
5. Habilitar Auth: Google + Apple + Email

### P3 — Auth Feature
```
lib/features/auth/
  ├── domain/entities/app_user.dart
  ├── domain/repositories/auth_repository.dart
  ├── data/repositories/auth_repository_impl.dart    ← firebase_auth
  ├── presentation/bloc/auth_bloc.dart
  └── presentation/pages/login_page.dart             ← Google Sign-In + Apple Sign-In
```

### P4 — Persistência de Projetos
```
lib/features/editor/
  ├── data/datasources/project_local_datasource.dart   ← Hive
  ├── data/datasources/project_remote_datasource.dart  ← Firestore
  └── data/repositories/project_repository_impl.dart   ← offline-first
```
- `save_project.dart` use case
- `load_project.dart` use case
- Atualizar `EditorBloc._onSaveProject()` e `._onLoadProject()`
- Home page: carregar projetos reais do Hive/Firestore

### P5 — RevenueCat + Paywall
```bash
flutter pub add purchases_flutter
```
```
lib/features/premium/
  ├── domain/entities/premium_status.dart
  ├── domain/usecases/check_premium_status.dart
  ├── domain/usecases/subscribe.dart
  ├── domain/usecases/restore_purchases.dart
  ├── data/repositories/premium_repository_impl.dart   ← purchases_flutter
  ├── presentation/bloc/premium_bloc.dart
  └── presentation/pages/paywall_page.dart
```
- Integrar paywall ao `PremiumLockOverlay`
- Limitar fontes premium, stickers premium, export sem watermark

### P6 — SVG Real (Twemoji)
1. Baixar subset do Twemoji: `npm install twemoji` ou via CDN
2. Copiar SVGs para `assets/stickers/twemoji/`
3. Atualizar `_buildStickerContent()` em `canvas_widget.dart` para usar `SvgPicture.asset()`
4. Atualizar `StickerRepositoryImpl` com paths reais

### P7 — Melhorias do Editor
- Duplo toque em texto → modo edição (TextField sobreposto)
- Painel de texto contextual (cor, tamanho, alinhamento, sombra, contorno)
- Seletor de cor (ColorPicker)
- Camadas / Z-index dos elementos
- Seleção de fundo via galeria (`image_picker`)

### P8 — Export Vídeo (pós-MVP)
```bash
flutter pub add ffmpeg_kit_flutter_full_gpl
```
- Capturar frames do canvas em 30fps
- Renderizar Lottie frame a frame
- Gerar MP4 com ffmpeg
- Stories 9:16 + Feed 1:1

### P9 — Publicação
- [ ] Ícone do app (gradiente diagonal #7C3AED → #EC4899 com "TA" em Poppins Bold)
- [ ] Splash screen (background #0A0A0F + logo animado)
- [ ] Android: gerar keystore + assinar APK
- [ ] iOS: certificados + provisioning profile
- [ ] Play Store: screenshots + descrição
- [ ] App Store: screenshots + review guidelines

---

## Arquivos — Estado Atual

| Arquivo | Status |
|---------|--------|
| `lib/core/constants/app_colors.dart` | ✅ Implementado |
| `lib/core/constants/app_typography.dart` | ✅ Implementado |
| `lib/core/theme/app_theme.dart` | ✅ Implementado |
| `lib/core/constants/app_sizes.dart` | ✅ Implementado |
| `lib/core/constants/app_constants.dart` | ✅ Implementado |
| `lib/core/navigation/app_router.dart` | ✅ Implementado |
| `lib/core/di/injection_container.dart` | ✅ Implementado |
| `lib/app.dart` | ✅ Implementado |
| `lib/main.dart` | ✅ Implementado (sem Firebase ainda) |
| `lib/main_dev.dart` | ✅ Implementado |
| `lib/firebase_options.dart` | ❌ Pendente — Fase 4 |
| `lib/features/editor/**` | ✅ Implementado |
| `lib/features/home/**` | ✅ Implementado |
| `lib/features/fonts/**` | ✅ Implementado |
| `lib/features/stickers/**` | ✅ Implementado |
| `lib/features/export/**` | ✅ Implementado |
| `lib/features/auth/**` | ❌ Pendente — P3 |
| `lib/features/premium/**` | ❌ Pendente — P5 |
| `lib/shared/widgets/gradient_button.dart` | ✅ Implementado |
| `lib/shared/widgets/premium_badge.dart` | ✅ Implementado |
| `lib/shared/widgets/premium_lock_overlay.dart` | ✅ Implementado |
| `android/` | ✅ Criado + permissões configuradas |
| `ios/` | ✅ Criado + permissões configuradas |
| `web/` | ✅ Criado |

---

*Baseado em: `textart-studio-planejamento.md` · `identidade-visual.md`*
*Atualizado em: 2026-02-19*
