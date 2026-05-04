import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/dictionary_repository.dart';
import '../../data/transliteration.dart';
import '../../domain/dictionary_entry.dart';
import '../../domain/quran_reference.dart';

final repositoryProvider = Provider((_) => DictionaryRepository());

// Theme
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;
  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

// Search bar position
class SearchBarBottomNotifier extends AsyncNotifier<bool> {
  static const _key = 'search_bar_bottom';

  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    final current = state.value ?? false;
    final next = !current;
    await prefs.setBool(_key, next);
    state = AsyncData(next);
  }
}

final searchBarBottomProvider =
    AsyncNotifierProvider<SearchBarBottomNotifier, bool>(SearchBarBottomNotifier.new);

// Search
enum SearchMode { keyword, fullText }

class SearchModeNotifier extends Notifier<SearchMode> {
  @override
  SearchMode build() => SearchMode.keyword;
  void set(SearchMode mode) => state = mode;
}

final searchModeProvider = NotifierProvider<SearchModeNotifier, SearchMode>(SearchModeNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String query) => state = query;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

final searchResultsProvider = FutureProvider<List<DictionaryEntry>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final mode = ref.watch(searchModeProvider);
  if (query.isEmpty) return [];
  final repo = ref.read(repositoryProvider);
  if (mode == SearchMode.fullText) return repo.fullTextSearch(query);
  if (isLatin(query)) {
    final normalized = query.toLowerCase().replaceAll('v', 'w');
    return repo.searchByTransliteration(normalized);
  }
  return repo.searchByWord(query);
});

final allEntriesProvider = FutureProvider<List<DictionaryEntry>>((ref) {
  return ref.read(repositoryProvider).getAllEntries();
});

final entryByWordProvider =
    FutureProvider.family<DictionaryEntry?, ({String word, int occurrence})>((ref, params) {
  return ref.read(repositoryProvider).getRootByWord(params.word, occurrence: params.occurrence);
});

final childEntriesProvider =
    FutureProvider.family<List<DictionaryEntry>, int>((ref, parentId) {
  return ref.read(repositoryProvider).getChildEntries(parentId);
});

final familyProvider =
    FutureProvider.family<List<DictionaryEntry>, int>((ref, parentId) {
  return ref.read(repositoryProvider).getFamily(parentId);
});

final quranReferencesProvider =
    FutureProvider.family<List<QuranReference>, String>((ref, rootWord) {
  return ref.read(repositoryProvider).getQuranReferences(rootWord);
});

final quranicWordsProvider = FutureProvider<List<DictionaryEntry>>((ref) {
  return ref.read(repositoryProvider).getQuranicWords();
});

final rootFirstLettersProvider = FutureProvider<List<String>>((ref) {
  return ref.read(repositoryProvider).getRootFirstLetters();
});

final rootPrefixesProvider =
    FutureProvider.family<List<String>, String>((ref, letter) {
  return ref.read(repositoryProvider).getRootPrefixes(letter);
});

final rootsByPrefixProvider =
    FutureProvider.family<List<DictionaryEntry>, String>((ref, prefix) {
  return ref.read(repositoryProvider).getRootsByPrefix(prefix);
});

final singleCharRootsProvider =
    FutureProvider.family<List<DictionaryEntry>, String>((ref, letter) {
  return ref.read(repositoryProvider).getSingleCharRoots(letter);
});

final remoteMessageProvider = FutureProvider<String>((ref) async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/GibreelAbdullah/HansWehrDictionary/refs/heads/master/msg.md'));
  if (response.statusCode == 200 && response.body.trim().isNotEmpty) {
    return response.body;
  }
  return '';
});
