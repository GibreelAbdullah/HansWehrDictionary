import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:search/screens/Notifications.dart';
import 'package:search/screens/abbreviations.dart';
import 'package:search/screens/aboutApp.dart';
import 'package:search/screens/browse.dart';
import 'package:search/screens/search.dart';
import 'package:search/screens/settings.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';

Map<String, WidgetBuilder> routes = {
  '/search': (context) => Search(),
  '/aboutus': (context) => AboutApp(),
  '/settings': (context) => Settings(),
  '/browse': (context) => Browse(),
  '/abbreviations': (context) => Abbreviations(),
  '/notifications': (context) => ChangeNotifierProvider<ValueNotifier<String>>(
      create: (context) =>
          ValueNotifier<String>(locator<LocalStorageService>().highlightColor),
      child: Notifications()),
};
