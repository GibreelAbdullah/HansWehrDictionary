import 'package:flutter/widgets.dart';
import 'screens/history.dart';
import 'screens/favorites.dart';
import 'screens/more_apps.dart';
import 'screens/abbreviations.dart';
import 'screens/about_app.dart';
import 'screens/browse.dart';
import 'screens/search.dart';
import 'screens/settings.dart';
import 'screens/donate.dart';
import 'screens/preface.dart';
import 'screens/quranic_words.dart';

Map<String, WidgetBuilder> routes = {
  '/search': (context) => const Search(),
  '/aboutus': (context) => const AboutApp(),
  '/preface': (context) => const Preface(),
  '/browse': (context) => const Browse(),
  '/abbreviations': (context) => const Abbreviations(),
  '/moreapps': (context) => const MoreApps(),
  '/donate': (context) => const Donate(),
  '/settings': (context) => const Settings(),
  '/favorites': (context) => const Favorites(),
  '/history': (context) => const History(),
  '/quranicWords': (context) => const QuranicWords(),
};
