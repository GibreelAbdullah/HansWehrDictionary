import 'package:flutter/material.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  appBarTheme: AppBarTheme(
    color: Colors.grey[100],
    brightness: Brightness.light,
  ),
  primaryTextTheme: TextTheme(
    headline6: TextStyle(color: Colors.black),
  ),
  scaffoldBackgroundColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.black),
  highlightColor: hexToColor(locator<LocalStorageService>().highlightColor),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  appBarTheme: AppBarTheme(
    color: Colors.grey[850],
    brightness: Brightness.dark,
  ),
  primaryTextTheme: TextTheme(
    headline6: TextStyle(color: Colors.white),
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  iconTheme: IconThemeData(color: Colors.white),
  highlightColor: hexToColor(locator<LocalStorageService>().highlightColor),
);

Color hexToColor(String code) {
  return new Color(int.parse(code));
}
