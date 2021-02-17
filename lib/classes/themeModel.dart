import 'package:flutter/material.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';
import 'appTheme.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme =
      locator<LocalStorageService>().darkTheme ? darkTheme : lightTheme;

  refreshTheme() {
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
            textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: locator<LocalStorageService>().font,
                ),
            primaryColor:
                hexToColor(locator<LocalStorageService>().highlightTextColor),
            accentColor:
                hexToColor(locator<LocalStorageService>().highlightTextColor),
            primaryTextTheme: TextTheme(
              bodyText1: TextStyle(
                fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
              ),
              headline6: TextStyle(
                fontSize: 20 + locator<LocalStorageService>().fontSizeDelta,
              ),
            ),
          )
        : lightTheme.copyWith(
            textTheme: ThemeData.light().textTheme.apply(
                  fontFamily: locator<LocalStorageService>().font,
                ),
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
            primaryColor:
                hexToColor(locator<LocalStorageService>().highlightTextColor),
            accentColor:
                hexToColor(locator<LocalStorageService>().highlightTextColor),
            primaryTextTheme: TextTheme(
              bodyText1: TextStyle(
                fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
              ),
              headline6: TextStyle(
                fontSize: 20 + locator<LocalStorageService>().fontSizeDelta,
              ),
            ),
          );
    return notifyListeners();
  }
}
