import 'package:flutter/widgets.dart';
import 'screens/search.dart';
import 'screens/aboutApp.dart';

Map<String, WidgetBuilder> routes = {
  '/search': (context) => Search(),
  '/aboutus': (context) => AboutApp(),
};
