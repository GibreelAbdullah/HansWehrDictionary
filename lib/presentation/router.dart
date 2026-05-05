import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/entry_detail_screen.dart';
import 'screens/introduction_screen.dart';
import 'screens/verb_forms_screen.dart';
import 'screens/abbreviations_screen.dart';
import 'screens/transliteration_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/theme_settings_screen.dart';
import 'screens/about_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(view: HomeView.dashboard),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const HomeScreen(view: HomeView.favorites),
      ),
      GoRoute(
        path: '/quranic-words',
        builder: (context, state) => const HomeScreen(view: HomeView.quranicWords),
      ),
      GoRoute(
        path: '/browse',
        builder: (context, state) => const HomeScreen(view: HomeView.browse),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HomeScreen(view: HomeView.history),
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
      GoRoute(
        path: '/introduction',
        builder: (context, state) => const IntroductionScreen(),
      ),
      GoRoute(
        path: '/verb-forms',
        builder: (context, state) => const VerbFormsScreen(),
      ),
      GoRoute(
        path: '/abbreviations',
        builder: (context, state) => const AbbreviationsScreen(),
      ),
      GoRoute(
        path: '/transliteration',
        builder: (context, state) => const TransliterationScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/theme',
        builder: (context, state) => const ThemeSettingsScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
});
