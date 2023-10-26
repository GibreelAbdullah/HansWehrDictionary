import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String userPreferencesKey = 'userPreferences';
  static const String darkThemeKey = 'darkTheme';
  static const String historyKey = 'history';
  static const String appUsageKey = 'appUsage';
  static const String highLightTextKey = 'highlightText';
  static const String highLightTileKey = 'highlightTile';
  static const String backgroundKey = 'background';
  static const String searchBarKey = 'searchBar';
  static const String fontSizeKey = 'fontSize';
  static const String fontKey = 'font';

  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;
  static Future<LocalStorageService?> getInstance() async {
    _instance ??= LocalStorageService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  UserPreferences get userPreferences {
    var userPreferencesJson = _getFromDisk(userPreferencesKey);
    if (userPreferencesJson == null) {
      return UserPreferences.fromJson(json.decode(
          '{"darkTheme":false,"history":"","appUsage":1,"highlightText":null,"highlightTile":null,"background":null,"searchBar":null,"fontSize":0.0,"font":"Amiri"}'));
    }
    return UserPreferences.fromJson(json.decode(userPreferencesJson));
  }

  set userPreferences(UserPreferences userPreferencesToSave) {
    saveStringToDisk(
        userPreferencesKey, json.encode(userPreferencesToSave.toJson()));
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences!.get(key);
    return value;
  }

  void saveStringToDisk(String key, String content) {
    _preferences!.setString(userPreferencesKey, content);
  }

  bool get darkTheme => _getFromDisk(darkThemeKey) ?? false;
  set darkTheme(bool value) => _saveToDisk(darkThemeKey, value);

  String get history => _getFromDisk(historyKey) ?? "";
  set history(String value) => _saveToDisk(historyKey, value);

  int get appUsage => _getFromDisk(appUsageKey) ?? 1;
  set appUsage(int value) => _saveToDisk(appUsageKey, value);

  String? get highlightTextColor => _getFromDisk(highLightTextKey);
  set highlightTextColor(String? value) => _saveToDisk(highLightTextKey, value);

  String? get highlightTileColor => _getFromDisk(highLightTileKey);
  set highlightTileColor(String? value) => _saveToDisk(highLightTileKey, value);

  String? get backgroundColor => _getFromDisk(backgroundKey);
  set backgroundColor(String? value) => _saveToDisk(backgroundKey, value);

  String? get searchBarColor => _getFromDisk(searchBarKey);
  set searchBarColor(String? value) => _saveToDisk(searchBarKey, value);

  double get fontSizeDelta => _getFromDisk(fontSizeKey) ?? 0.0;
  set fontSizeDelta(double value) => _saveToDisk(fontSizeKey, value);

  String get font => _getFromDisk(fontKey) ?? 'Amiri';
  set font(String? value) => _saveToDisk(fontKey, value);

  void _saveToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences!.setString(key, content);
    }
    if (content is bool) {
      _preferences!.setBool(key, content);
    }
    if (content is int) {
      _preferences!.setInt(key, content);
    }
    if (content is double) {
      _preferences!.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences!.setStringList(key, content);
    }
  }
}

class UserPreferences {
  final bool? darkTheme;
  final String? highlightText;
  final String? highlightTile;
  final String? history;
  final String? background;
  final String? searchBar;
  final int? fontSize;
  final String? font;

  UserPreferences({
    this.darkTheme,
    this.highlightText,
    this.highlightTile,
    this.history,
    this.background,
    this.searchBar,
    this.fontSize,
    this.font,
  });

  UserPreferences.fromJson(Map<String, dynamic> json)
      : darkTheme = json['darkTheme'],
        highlightText = json['highlightText'],
        highlightTile = json['highlightTile'],
        history = json['history'],
        background = json['background'],
        searchBar = json['searchBar'],
        fontSize = json['fontSize'],
        font = json['font'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['darkTheme'] = darkTheme;
    data['highlightText'] = highlightText;
    data['highlightTile'] = highlightTile;
    data['history'] = history;
    data['background'] = background;
    data['searchBar'] = searchBar;
    data['fontSize'] = fontSize;
    data['font'] = font;
    return data;
  }
}
