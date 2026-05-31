import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/transliteration.dart';
import '../../domain/dictionary_entry.dart';
import 'dictionary_providers.dart';

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
    return repo.searchByTransliteration(normalizeTransliteration(query));
  }
  return repo.searchByWord(query);
});

/// Live keyword suggestions for the search dropdown.
class SuggestionQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String query) => state = query;
}

final suggestionQueryProvider =
    NotifierProvider<SuggestionQueryNotifier, String>(SuggestionQueryNotifier.new);

final searchSuggestionsProvider = FutureProvider<List<DictionaryEntry>>((ref) async {
  final query = ref.watch(suggestionQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.read(repositoryProvider);
  List<DictionaryEntry> results;
  if (isLatin(query)) {
    results = await repo.searchByTransliteration(normalizeTransliteration(query));
  } else {
    results = await repo.searchByWord(query);
  }
  // Deduplicate by word — show only one entry per unique word
  final seen = <String>{};
  return results.where((e) => seen.add(e.word)).toList();
});
