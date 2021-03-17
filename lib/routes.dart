import 'package:flutter/widgets.dart';
// import './screens/notifications.dart';
import './screens/abbreviations.dart';
import './screens/aboutApp.dart';
import './screens/browse.dart';
import './screens/search.dart';
import './screens/settings.dart';
import './screens/donate.dart';

Map<String, WidgetBuilder> routes = {
  '/search': (context) => Search(),
  '/aboutus': (context) => AboutApp(),
  '/browse': (context) => Browse(),
  '/abbreviations': (context) => Abbreviations(),
  '/donate': (context) => Donate(),
  '/settings': (context) => Settings(),
};
