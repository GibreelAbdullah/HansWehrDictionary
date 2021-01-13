import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:search/services/LocalStorageService.dart';
import '../constants/appConstants.dart';
import '../serviceLocator.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _suggestions = getHistory();
  List<String> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _suggestions = getHistory();
    } else {
      _suggestions = await databaseObject.topFiveWords(query);
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _suggestions = getHistory();
    notifyListeners();
  }
}

//Even I don't know what I am doing here
Queue<String> _history = locator<LocalStorageService>().history != ""
    ? Queue.from(locator<LocalStorageService>()
        .history
        .substring(1, locator<LocalStorageService>().history.length - 1)
        .split(','))
    : Queue();

List<String> getHistory() {
  String history = locator<LocalStorageService>().history;
  return history != ""
      ? List.from(history.substring(1, history.length - 1).split(',').reversed)
      : ["Your 5 most recent searches will come here"];
}

void addHistory(String item) {
  _history.remove(item);
  _history.add(item);
  if (_history.length > 5) {
    _history.removeFirst();
  }
  locator<LocalStorageService>().history = _history.toString();
}
