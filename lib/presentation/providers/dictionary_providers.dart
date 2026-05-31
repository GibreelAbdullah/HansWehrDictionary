import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/dictionary_repository.dart';
import '../../domain/dictionary_entry.dart';
import '../../domain/quran_reference.dart';

// Re-export split providers so existing imports continue to work.
export 'search_providers.dart';
export 'ui_providers.dart';

final repositoryProvider = Provider((_) => DictionaryRepository());

final entryByWordProvider =
    FutureProvider.family<DictionaryEntry?, ({String word, int occurrence})>((ref, params) {
  return ref.read(repositoryProvider).getRootByWord(params.word, occurrence: params.occurrence);
});

final allRootsByWordProvider =
    FutureProvider.family<List<DictionaryEntry>, String>((ref, word) {
  return ref.read(repositoryProvider).getAllRootsByWord(word);
});

final childEntriesProvider =
    FutureProvider.family<List<DictionaryEntry>, int>((ref, parentId) {
  return ref.read(repositoryProvider).getChildEntries(parentId);
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

final remoteMessageProvider = FutureProvider.autoDispose<String>((ref) async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/GibreelAbdullah/HansWehrDictionary/refs/heads/master/msg.md'));
  if (response.statusCode == 200 && response.body.trim().isNotEmpty) {
    return response.body;
  }
  return '';
});
