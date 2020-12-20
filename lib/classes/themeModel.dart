import 'package:flutter/material.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';
import 'appTheme.dart';

enum ThemeType { Light, Dark }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = setCurrentTheme();

  toggleTheme() {
    currentTheme = currentTheme == DarkAppTheme.theme
        ? LightAppTheme.theme
        : DarkAppTheme.theme;
    return notifyListeners();
  }
}

ThemeData setCurrentTheme() {
  if (locator<LocalStorageService>().darkTheme) {
    return DarkAppTheme.theme;
  } else {
    return LightAppTheme.theme;
  }
}
