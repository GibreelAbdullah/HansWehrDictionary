import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/entry_detail_screen.dart';
import 'screens/theme_settings_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/quranic_words_screen.dart';
import 'screens/browse_screen.dart';
import 'screens/history_screen.dart';
import 'screens/about_screen.dart';
import 'screens/donate_screen.dart';
import 'screens/introduction_screen.dart';
import 'screens/verb_forms_screen.dart';
import 'screens/abbreviations_screen.dart';
import 'screens/transliteration_screen.dart';
import 'screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const DashboardScreen()),
          GoRoute(path: '/favorites', builder: (_, _) => const FavoritesScreen()),
          GoRoute(path: '/quranic-words', builder: (_, _) => const QuranicWordsScreen()),
          GoRoute(path: '/browse', builder: (_, _) => const BrowseScreen()),
          GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
          GoRoute(path: '/about', builder: (_, _) => const AboutBody()),
          GoRoute(path: '/donate', builder: (_, _) => const DonateBody()),
          GoRoute(path: '/introduction', builder: (_, _) => const IntroductionBody()),
          GoRoute(path: '/verb-forms', builder: (_, _) => const VerbFormsBody()),
          GoRoute(path: '/abbreviations', builder: (_, _) => const AbbreviationsBody()),
          GoRoute(path: '/transliteration', builder: (_, _) => const TransliterationBody()),
          GoRoute(path: '/settings', builder: (_, _) => const SettingsBody()),
        ],
      ),
      GoRoute(
        path: '/settings/theme',
        builder: (context, state) => const ThemeSettingsScreen(),
      ),
      GoRoute(
        path: '/entry/:word',
        builder: (context, state) {
          final word = state.pathParameters['word']!;
          final highlight = state.uri.queryParameters['highlight'];
          return EntryDetailScreen(
            word: word,
            highlightEntryId: highlight != null ? int.tryParse(highlight) : null,
          );
        },
      ),
      GoRoute(
        path: '/entry/:word/:occurrence',
        builder: (context, state) {
          final word = state.pathParameters['word']!;
          final occurrence = int.tryParse(state.pathParameters['occurrence']!) ?? 1;
          final highlight = state.uri.queryParameters['highlight'];
          return EntryDetailScreen(
            word: word,
            occurrence: occurrence,
            highlightEntryId: highlight != null ? int.tryParse(highlight) : null,
          );
        },
      ),
    ],
  );
});
