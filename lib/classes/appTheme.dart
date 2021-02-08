import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme(primary: null, primaryVariant: null, secondary: null, secondaryVariant: null, surface: null, background: null, error: null, onPrimary: null, onSecondary: null, onSurface: null, onBackground: null, onError: null, brightness: null),
  appBarTheme: AppBarTheme(
    color: Colors.grey[100],
    brightness: Brightness.light,
  ),
  primaryTextTheme: TextTheme(
    headline6: TextStyle(color: Colors.black),
  ),
  scaffoldBackgroundColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.black),
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
);

Color hexToColor(String code) {
  return code == null ? null : Color(int.parse(code));
}
