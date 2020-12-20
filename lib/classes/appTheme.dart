import 'package:flutter/material.dart';

class LightAppTheme {
  LightAppTheme._();

  // Light Theme
  static final ThemeData theme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      color: Colors.grey[100],
      brightness: Brightness.light,
    ),
    primaryTextTheme: TextTheme(
      headline6: TextStyle(color: Colors.black),
    ),
    scaffoldBackgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    highlightColor: Colors.green[50],
  );
}

class DarkAppTheme {
  DarkAppTheme._();
  // Dark Theme
  static final ThemeData theme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      color: Colors.grey[850],
      brightness: Brightness.dark,
    ),
    primaryTextTheme: TextTheme(
      headline6: TextStyle(color: Colors.white),
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    iconTheme: IconThemeData(color: Colors.white),
    highlightColor: Color(0xFF065015),
  );
}
