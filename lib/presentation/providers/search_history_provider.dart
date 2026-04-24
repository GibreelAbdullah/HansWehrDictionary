import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'search_history';

class SearchHistoryNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> add(String query) async {
    if (query.isEmpty) return;
    final current = List<String>.from(state.value ?? []);
    current.remove(query);
    current.insert(0, query);
    final updated = current.take(1000).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, updated);
    state = AsyncData<List<String>>(updated);
  }

  Future<void> remove(String query) async {
    final updated = (state.value ?? []).where((e) => e != query).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, updated);
    state = AsyncData(updated);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = const AsyncData([]);
  }
}

final searchHistoryProvider =
    AsyncNotifierProvider<SearchHistoryNotifier, List<String>>(SearchHistoryNotifier.new);
