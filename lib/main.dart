import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search/classes/themeModel.dart';
import 'package:search/serviceLocator.dart';
import 'components/adManager.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator().then((value) => runApp(
        ChangeNotifierProvider<ThemeModel>(
          create: (BuildContext context) => ThemeModel(),
          child: MyApp(),
        ),
      ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    displayBanner();

    return new MaterialApp(
        theme: Provider.of<ThemeModel>(context, listen: true).currentTheme,
        initialRoute: '/search',
        routes: routes);
  }
}
