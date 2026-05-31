import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
