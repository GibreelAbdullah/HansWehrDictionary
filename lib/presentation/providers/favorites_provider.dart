import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/dictionary_entry.dart';
import 'dictionary_providers.dart';

const _key = 'favorite_ids';

class FavoritesNotifier extends AsyncNotifier<Set<int>> {
  @override
  Future<Set<int>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    return ids.map(int.parse).toSet();
  }

  Future<void> toggle(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = {...state.value ?? {}};
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    await prefs.setStringList(_key, current.map((e) => e.toString()).toList());
    state = AsyncData(current);
  }

  bool isFavorite(int id) => state.value?.contains(id) ?? false;
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, Set<int>>(FavoritesNotifier.new);

final favoriteEntriesProvider = FutureProvider<List<DictionaryEntry>>((ref) async {
  final ids = await ref.watch(favoritesProvider.future);
  if (ids.isEmpty) return [];
  final repo = ref.read(repositoryProvider);
  return repo.getEntriesByIds(ids.toList());
});
