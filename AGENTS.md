# AGENTS.md — Hans Wehr Dictionary

Guidance for AI coding agents working in this repository.

## What this is

A Flutter app: an offline **Hans Wehr Arabic–English dictionary**. Runs on
Android, iOS, web, Linux, macOS, and Windows. Dictionary data ships as a bundled
SQLite database queried on-device.

> Sibling project: **Lane's Lexicon** (`../LaneLexicon`) is a near-identical app
> for a different dictionary. The two are intentionally kept as **separate repos,
> not a shared codebase**. When a file's core functionality is the same in both,
> prefer copying the same file across — adapting only naming/content/routing
> differences. See "Known divergences" below before assuming the two are identical.

## Tech stack

- **Flutter** (stable), Dart SDK `^3.10.4`
- **State management:** `flutter_riverpod`
- **Routing:** `go_router`
- **Database:** `sqflite` / `sqflite_common_ffi` (native) and
  `sqflite_common_ffi_web` + `sqlite3.wasm` (web)
- **Other:** `url_launcher`, `shared_preferences`, `http`,
  `flutter_markdown_plus`, `google_fonts`

## Commands

Run these from the repo root. Flutter must be on `PATH`.

```bash
flutter pub get          # install dependencies
flutter analyze          # static analysis / lints (MUST pass before done)
flutter test             # run tests (see test/)
flutter run              # run on a connected device/emulator
flutter run -d chrome    # run on web
flutter build apk        # Android release build
flutter build web        # web build
```

Always run `flutter analyze` after changes and fix any new issues before
finishing. Clean up temp files created during verification.

## Project layout

```
lib/
  main.dart                     # app entry; web DB-loading gate
  data/                         # repositories, DB helpers, migrations, static data
    dictionary_repository.dart  # all SQL queries
    database_helper*.dart       # native vs web DB init (conditional imports)
    db_update_service.dart      # remote DB version check/update
    transliteration.dart        # Arabic/Latin detection + normalization
  domain/                       # plain models (DictionaryEntry, QuranReference)
  presentation/
    router.dart                 # go_router config (ShellRoute + routes)
    theme.dart
    screens/                    # one file per screen
    providers/                  # Riverpod providers
    widgets/                    # reusable widgets (search_bar, entry_card, ...)
assets/hanswehr.sqlite          # bundled dictionary DB (committed directly)
scripts/                        # one-off Python data-prep scripts
```

## Architecture notes

- **Layers:** `data` (persistence/queries) → `domain` (models) → `presentation`
  (UI/state). Keep SQL inside `dictionary_repository.dart`; don't scatter queries.
- **Providers:** search state lives in `dictionary_providers.dart` /
  `search_providers.dart` (`searchQueryProvider`, `searchModeProvider`,
  `suggestionQueryProvider`, `searchSuggestionsProvider`, etc.).
- **Navigation:** uses `context.push(...)` for internal routes. The home area is a
  `ShellRoute` with sub-views as separate screens
  (`dashboard_screen.dart`, `browse_screen.dart`, `favorites_screen.dart`,
  `history_screen.dart`, `quranic_words_screen.dart`).
- **Entry routing:** `/entry/:word` and `/entry/:word/:occurrence`; derivatives
  navigate to their parent root with `?highlight=<id>`.
- **Search methodology:** keyword mode shows a live floating **suggestion dropdown**
  (overlay) in `widgets/search_bar.dart`; full-text mode renders results in the
  body list. Definitions may contain simple tags (`<b>`, `<i>`, etc.) parsed by
  `widgets/definition_text.dart`.
- **Web DB:** the SQLite file is cached in IndexedDB; it is re-downloaded only when
  the version changes (`database_helper_web.dart`).

## Conventions

- Match existing style; this repo uses the default `flutter_lints` ruleset
  (`analysis_options.yaml`). Prefer `const`, single quotes, and small widgets.
- Reuse existing providers/widgets rather than introducing new state patterns.
- Don't add dependencies without reason; pin versions as the existing entries do.

## Known divergences from Lane's Lexicon

Keep these in mind when porting changes between the two apps:

- **Screens:** Hans Wehr splits the home into separate screens + `ShellRoute`;
  Lane's uses a single `home_screen.dart` with a `HomeView` enum.
- **Database:** Hans Wehr commits `assets/hanswehr.sqlite` directly; Lane's stores
  its DB via **Git LFS** (needs `git lfs pull`).
- **Lane's-only features:** Authorities screen, Preface link. Hans Wehr has an
  Introduction screen that Lane's lacks.
- **Dashboard order (shared target):** Browse, Quranic Words, Favorites, History,
  Read Hadith @ HadithHub (external), Other Apps by Me (external), Donate, About.

## Safety

- Don't commit unless explicitly asked.
- `assets/hanswehr.sqlite` is large; avoid rewriting it casually.
- Treat `android/key.properties` and any signing/secrets as sensitive — never commit.
