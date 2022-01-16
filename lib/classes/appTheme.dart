import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../serviceLocator.dart';
import '../services/LocalStorageService.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyText1: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
          color: Colors.black,
        ),
        bodyText2: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
          color:
              hexToColor(locator<LocalStorageService>().highlightTextColor) ??
                  Colors.black,
        ),
        subtitle1: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
          color: Colors.black,
        ),
        subtitle2: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
          color: Colors.white,
        ),
        headline6: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 20 + locator<LocalStorageService>().fontSizeDelta,
          color: Colors.black,
        ),
      ),
  primaryColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
  // accentColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
  canvasColor: hexToColor(locator<LocalStorageService>().backgroundColor),
  scaffoldBackgroundColor:
      hexToColor(locator<LocalStorageService>().backgroundColor) ??
          Colors.white,
  dialogBackgroundColor:
      hexToColor(locator<LocalStorageService>().backgroundColor) ??
          Colors.white,
  appBarTheme: AppBarTheme(
    color: hexToColor(locator<LocalStorageService>().searchBarColor) ??
        Colors.grey[100],
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  brightness: Brightness.light,
  cardColor: hexToColor(locator<LocalStorageService>().searchBarColor),
  iconTheme: IconThemeData(color: Colors.black),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: ThemeData.dark().textTheme.copyWith(
        bodyText1: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
          color: Colors.white,
        ),
        bodyText2: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
          color:
              hexToColor(locator<LocalStorageService>().highlightTextColor) ??
                  Colors.white,
        ),
        subtitle1: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
          color: Colors.white,
        ),
        subtitle2: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
          color: Colors.black,
        ),
        headline6: TextStyle(
          fontFamily: locator<LocalStorageService>().font,
          fontSize: 20 + locator<LocalStorageService>().fontSizeDelta,
          color: Colors.white,
        ),
      ),
  primaryColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
  // accentColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
  canvasColor: hexToColor(locator<LocalStorageService>().backgroundColor),
  dialogBackgroundColor:
      hexToColor(locator<LocalStorageService>().backgroundColor) ??
          Colors.grey[900],
  scaffoldBackgroundColor:
      hexToColor(locator<LocalStorageService>().backgroundColor) ??
          Colors.grey[900],
  appBarTheme: AppBarTheme(
    color: hexToColor(locator<LocalStorageService>().searchBarColor) ??
        Colors.grey[850],
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  cardColor: hexToColor(locator<LocalStorageService>().searchBarColor),
  brightness: Brightness.dark,
  iconTheme: IconThemeData(color: Colors.white),
);

Color? hexToColor(String? code) {
  return code == null ? null : Color(int.parse(code));
}
