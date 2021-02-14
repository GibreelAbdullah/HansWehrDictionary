import 'package:flutter/material.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';
import 'appTheme.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme =
      locator<LocalStorageService>().darkTheme ? darkTheme : lightTheme;

  // toggleTheme() {
  //   currentTheme = currentTheme == darkTheme ? lightTheme : darkTheme;
  //   return notifyListeners();
  // }

  refreshColors() {
    currentTheme = locator<LocalStorageService>().darkTheme
        ? darkTheme.copyWith(
            canvasColor:
                hexToColor(locator<LocalStorageService>().backgroundColor),
            scaffoldBackgroundColor:
                hexToColor(locator<LocalStorageService>().backgroundColor) ??
                    Colors.grey[900],
            cardColor:
                hexToColor(locator<LocalStorageService>().searchBarColor),
            appBarTheme: AppBarTheme(
              color:
                  hexToColor(locator<LocalStorageService>().searchBarColor) ??
                      Colors.grey[850],
            ),
          )
        : lightTheme.copyWith(
            canvasColor:
                hexToColor(locator<LocalStorageService>().backgroundColor),
            scaffoldBackgroundColor:
                hexToColor(locator<LocalStorageService>().backgroundColor) ??
                    Colors.white,
            cardColor:
                hexToColor(locator<LocalStorageService>().searchBarColor),
            appBarTheme: AppBarTheme(
              color:
                  hexToColor(locator<LocalStorageService>().searchBarColor) ??
                      Colors.grey[100],
            ),
          );
    return notifyListeners();
  }
}
