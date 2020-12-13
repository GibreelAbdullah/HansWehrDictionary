import 'package:flutter/widgets.dart';
import 'package:search/screens/settings.dart';
import 'screens/search.dart';
import 'screens/aboutApp.dart';

Map<String, WidgetBuilder> routes = {
  '/search': (context) => Search(),
  '/aboutus': (context) => AboutApp(),
  '/settings': (context) => Settings(),
};
