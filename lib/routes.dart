import 'package:flutter/widgets.dart';
import 'package:search/screens/notifications.dart';
import 'package:search/screens/abbreviations.dart';
import 'package:search/screens/aboutApp.dart';
import 'package:search/screens/browse.dart';
import 'package:search/screens/search.dart';

Map<String, WidgetBuilder> routes = {
  '/search': (context) => Search(),
  '/aboutus': (context) => AboutApp(),
  '/browse': (context) => Browse(),
  '/abbreviations': (context) => Abbreviations(),
  '/notifications': (context) => Notifications(),
};
