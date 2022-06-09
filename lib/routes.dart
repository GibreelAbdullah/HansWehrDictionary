import 'package:flutter/widgets.dart';
import 'screens/history.dart';
import 'screens/favorites.dart';
import 'screens/moreApps.dart';
import 'screens/abbreviations.dart';
import 'screens/aboutApp.dart';
import 'screens/browse.dart';
import 'screens/search.dart';
import 'screens/settings.dart';
import 'screens/donate.dart';
import 'screens/preface.dart';
import 'screens/quranicWords.dart';

Map<String, WidgetBuilder> routes = {
  '/search': (context) => Search(),
  '/aboutus': (context) => AboutApp(),
  '/preface': (context) => Preface(),
  '/browse': (context) => Browse(),
  '/abbreviations': (context) => Abbreviations(),
  '/moreapps': (context) => MoreApps(),
  '/donate': (context) => Donate(),
  '/settings': (context) => Settings(),
  '/favorites': (context) => Favorites(),
  '/history': (context) => History(),
  '/quranicWords': (context) => QuranicWords(),
};
