import 'package:flutter/material.dart';
import '../serviceLocator.dart';
import '../services/LocalStorageService.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: locator<LocalStorageService>().font,
      ),
  primaryTextTheme: ThemeData.light().textTheme.copyWith(
        headline6: TextStyle(
          fontSize: 20 + locator<LocalStorageService>().fontSizeDelta,
        ),
        bodyText1: TextStyle(
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
        ),
      ),
  primaryColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
  accentColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
  canvasColor: hexToColor(locator<LocalStorageService>().backgroundColor),
  scaffoldBackgroundColor:
      hexToColor(locator<LocalStorageService>().backgroundColor) ??
          Colors.white,
  appBarTheme: AppBarTheme(
    color: hexToColor(locator<LocalStorageService>().searchBarColor) ??
        Colors.grey[100],
    brightness: Brightness.light,
  ),
  cardColor: hexToColor(locator<LocalStorageService>().searchBarColor),
  iconTheme: IconThemeData(color: Colors.black),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: locator<LocalStorageService>().font,
      ),
  primaryTextTheme: ThemeData.dark().textTheme.copyWith(
        headline6: TextStyle(
          fontSize: 20 + locator<LocalStorageService>().fontSizeDelta,
        ),
        bodyText1: TextStyle(
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
        ),
      ),
  primaryColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
  accentColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
  canvasColor: hexToColor(locator<LocalStorageService>().backgroundColor),
  scaffoldBackgroundColor:
      hexToColor(locator<LocalStorageService>().backgroundColor) ??
          Colors.grey[900],
  appBarTheme: AppBarTheme(
    color: hexToColor(locator<LocalStorageService>().searchBarColor) ??
        Colors.grey[850],
    brightness: Brightness.dark,
  ),
  cardColor: hexToColor(locator<LocalStorageService>().searchBarColor),
  brightness: Brightness.dark,
  iconTheme: IconThemeData(color: Colors.white),
);

Color hexToColor(String code) {
  return code == null ? null : Color(int.parse(code));
}
