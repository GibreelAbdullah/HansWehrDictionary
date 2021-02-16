import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String UserPreferencesKey = 'userPreferences';
  static const String DarkThemeKey = 'darkTheme';
  static const String HistoryKey = 'history';
  static const String AppUsageKey = 'appUsage';
  static const String HighLightTextKey = 'highlightText';
  static const String HighLightTileKey = 'highlightTile';
  static const String BackgroundKey = 'background';
  static const String SearchBarKey = 'searchBar';
  static const String FontSizeKey = 'fontSize';

  static LocalStorageService _instance;
  static SharedPreferences _preferences;
  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  UserPreferences get userPreferences {
    var userPreferencesJson = _getFromDisk(UserPreferencesKey);
    if (userPreferencesJson == null) {
      return UserPreferences.fromJson(json.decode(
          '{"darkTheme":false,"history":"","appUsage":1,"highlightText":null,"highlightTile":null,"background":null,"searchBar":null,"fontSize":0.0}'));
    }
    return UserPreferences.fromJson(json.decode(userPreferencesJson));
  }

  set userPreferences(UserPreferences userPreferencesToSave) {
    saveStringToDisk(
        UserPreferencesKey, json.encode(userPreferencesToSave.toJson()));
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void saveStringToDisk(String key, String content) {
    print(
        '(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
    _preferences.setString(UserPreferencesKey, content);
  }

  bool get darkTheme => _getFromDisk(DarkThemeKey) ?? false;
  set darkTheme(bool value) => _saveToDisk(DarkThemeKey, value);

  String get history => _getFromDisk(HistoryKey) ?? "";
  set history(String value) => _saveToDisk(HistoryKey, value);

  int get appUsage => _getFromDisk(AppUsageKey) ?? 1;
  set appUsage(int value) => _saveToDisk(AppUsageKey, value);

  String get highlightTextColor => _getFromDisk(HighLightTextKey) ?? null;
  set highlightTextColor(String value) => _saveToDisk(HighLightTextKey, value);

  String get highlightTileColor => _getFromDisk(HighLightTileKey) ?? null;
  set highlightTileColor(String value) => _saveToDisk(HighLightTileKey, value);

  String get backgroundColor => _getFromDisk(BackgroundKey) ?? null;
  set backgroundColor(String value) => _saveToDisk(BackgroundKey, value);

  String get searchBarColor => _getFromDisk(SearchBarKey) ?? null;
  set searchBarColor(String value) => _saveToDisk(SearchBarKey, value);

  double get fontSizeDelta => _getFromDisk(FontSizeKey) ?? 0.0;
  set fontSizeDelta(double value) => _saveToDisk(FontSizeKey, value);

  void _saveToDisk<T>(String key, T content) {
    print(
        '(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }
}

class UserPreferences {
  final bool darkTheme;
  final String highlightText;
  final String highlightTile;
  final String history;
  final String background;
  final String searchBar;
  final int fontSize;

  UserPreferences({
    this.darkTheme,
    this.highlightText,
    this.highlightTile,
    this.history,
    this.background,
    this.searchBar,
    this.fontSize,
  });

  UserPreferences.fromJson(Map<String, dynamic> json)
      : darkTheme = json['darkTheme'],
        highlightText = json['highlightText'],
        highlightTile = json['highlightTile'],
        history = json['history'],
        background = json['background'],
        searchBar = json['searchBar'],
        fontSize = json['fontSize'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['darkTheme'] = this.darkTheme;
    data['highlightText'] = this.highlightText;
    data['highlightTile'] = this.highlightTile;
    data['history'] = this.history;
    data['background'] = this.background;
    data['searchBar'] = this.searchBar;
    data['fontSize'] = this.fontSize;
    return data;
  }
}
