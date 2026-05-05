# The Hans Wehr Dictionary Of Modern Written Arabic

A cross-platform Flutter application for the *Dictionary of Modern Written Arabic* by Hans Wehr, edited by J Milton Cowan. Browse, search, and bookmark entries from this comprehensive Arabic-English dictionary.

## Features

- **Keyword & Full-text Search** — search by Arabic word, transliteration, or English meaning
- **Quranic Words** — browse words that appear in the Quran with references
- **Favorites** — bookmark entries for quick access
- **Search History** — revisit previous searches
- **Browse by Root** — navigate entries alphabetically by Arabic root letter
- **Dark Mode** — system, light, and dark theme support
- **Offline** — entire dictionary bundled locally via SQLite

## Download

| Platform | Link |
|----------|------|
| Android | [GitHub Releases](https://github.com/GibreelAbdullah/HansWehrDictionary/releases/latest) |
| iOS | [GitHub Releases](https://github.com/GibreelAbdullah/HansWehrDictionary/releases/latest) |
| Web | [HansWehrDictionary](https://gibreelabdullah.github.io/HansWehrDictionary/) |
| Windows | [GitHub Releases](https://github.com/GibreelAbdullah/HansWehrDictionary/releases/latest) |
| macOS | [GitHub Releases](https://github.com/GibreelAbdullah/HansWehrDictionary/releases/latest) |
| Linux | [GitHub Releases](https://github.com/GibreelAbdullah/HansWehrDictionary/releases/latest) |

## Building from Source

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- For Android: Java 21+
- For iOS/macOS: Xcode
- For Linux: `clang cmake ninja-build pkg-config libgtk-3-dev`

### Steps

```bash
git clone https://github.com/GibreelAbdullah/HansWehrDictionary.git
cd HansWehrDictionary
flutter pub get
flutter run
```

To build a release for a specific platform:

```bash
flutter build apk --release        # Android
flutter build ios --release         # iOS
flutter build web --release         # Web
flutter build windows --release     # Windows
flutter build macos --release       # macOS
flutter build linux --release       # Linux
```

## Disclaimer

Text was extracted from scanned pages and may contain errors which are not feasible to fix manually. For a corrected version, see [Arabic Students Dictionary](https://arabicstudentsdictionary.com/).

## Courtesy

- [Jamal Osman and Muhammad Abdurrahman](https://github.com/jamalosman/hanswehr-app) — for the digitisation of the dictionary
- [Quran.com](https://corpus.quran.com/) — for word-by-word breakdown of Quranic text

## Contact

gibreel.khan@gmail.com
