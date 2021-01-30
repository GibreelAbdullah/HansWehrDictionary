import 'package:flutter/material.dart';
import 'package:search/services/LocalStorageService.dart';
import '../constants/appConstants.dart';
import '../serviceLocator.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _suggestions = locator<LocalStorageService>().history != ""
      ? List.from(locator<LocalStorageService>().history.split(',').reversed)
      : [];
  List<String> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _suggestions = cachedHistory != ""
          ? List.from(cachedHistory.split(',').reversed)
          : [];
    } else {
      _suggestions = await databaseObject.topFiveWords(query);
    }

    _isLoading = false;
    notifyListeners();
  }

  void onSubmitted(String query) async {}

  void clear() {
    _suggestions =
        cachedHistory != "" ? List.from(cachedHistory.split(',').reversed) : [];
    notifyListeners();
  }

  String cachedHistory = locator<LocalStorageService>().history;

  List<String> getHistory() {
    // String history = locator<LocalStorageService>().history;
    List<String> historyList =
        cachedHistory != "" ? cachedHistory.split(',') : [];
    return historyList;
  }

  void addHistory(String item) {
    List<String> history = getHistory();
    history.remove(item);
    history.add(item);

    if (history.length > 5) {
      history.removeAt(0);
    }
    cachedHistory = history
        .toString()
        .substring(1, history.toString().length - 1)
        .replaceAll(' ', '');
    locator<LocalStorageService>().history = cachedHistory;
    notifyListeners();
  }
}
