import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './classes/themeModel.dart';
import './serviceLocator.dart';
import './services/appReview.dart';
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator().then(
    (value) => runApp(
      ChangeNotifierProvider<ThemeModel>(
        create: (BuildContext context) => ThemeModel(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    appReview();
    // checkDatabaseUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Hans Wehr Dictionary",
        theme: Provider.of<ThemeModel>(context, listen: true).currentTheme,
        initialRoute: '/search',
        routes: routes);
  }
}
