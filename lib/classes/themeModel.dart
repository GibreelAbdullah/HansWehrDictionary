import 'package:flutter/material.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';
import 'appTheme.dart';

enum ThemeType { Light, Dark }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = setCurrentTheme();

  toggleTheme() {
    currentTheme = currentTheme == darkTheme ? lightTheme : darkTheme;
    return notifyListeners();
  }
}

ThemeData setCurrentTheme() {
  if (locator<LocalStorageService>().darkTheme) {
    return darkTheme;
  } else {
    return lightTheme;
  }
}
