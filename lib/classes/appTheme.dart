import 'package:flutter/material.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Scheherazade',
      ),
  primaryTextTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Scheherazade',
      ),
  accentTextTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Scheherazade',
      ),
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
        fontFamily: 'Scheherazade',
      ),
  primaryTextTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'Scheherazade',
      ),
  accentTextTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'Scheherazade',
      ),
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

// ThemeData customTheme = ThemeData(
//   fontFamily: 'Scheherazade',
//   primaryTextTheme: TextTheme(
//       // subtitle1: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//       // headline6: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//       // bodyText1: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//       // bodyText2: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//       ),
//   canvasColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
//   // primarySwatch: Colors.brown,
//   // scaffoldBackgroundColor: primarySwatch[400],
//   // canvasColor: Color(0xFFF5F5DC),
//   // accentColor: hexToColor(locator<LocalStorageService>().highlightTextColor),
//   // scaffoldBackgroundColor: ,
// );

Color hexToColor(String code) {
  return code == null ? null : Color(int.parse(code));
}
