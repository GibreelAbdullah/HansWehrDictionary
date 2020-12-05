// import 'dart:convert';
// import '../services/getData.dart';
import 'package:flutter/material.dart';
import '../constants/appConstants.dart';
// import 'package:http/http.dart' as http;

// import 'place.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _suggestions = history;
  List<String> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _suggestions = history;
    } else {
      _suggestions = await databaseObject.words(query);
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _suggestions = history;
    notifyListeners();
  }
}

const List<String> history = [];
