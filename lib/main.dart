import 'package:flutter/material.dart';
import 'components/adManager.dart';
import 'constants/preferences.dart';
import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showAd.then((value) {
      if (value) {
        displayBanner();
      }
    });

    return new MaterialApp(
        theme: ThemeData.light(),
        // darkTheme: ThemeData.dark(),
        initialRoute: '/search',
        routes: routes);
  }
}
