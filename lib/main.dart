import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search/classes/themeModel.dart';
import 'package:search/properties.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/checkDatabaseUpdates.dart';
import 'routes.dart';
import 'package:appodeal_flutter/appodeal_flutter.dart';

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
  bool isAppodealInitialized = false;
  @override
  void initState() {
    super.initState();

    checkDatabaseUpdates();

    Appodeal.setAppKeys(
        androidAppKey: APPODEAL_ANDROID_API,
        iosAppKey: '3a2ef99639e29dfe3333e4b3b496964dae6097cc510cbb2f'); //DUMMY

    Appodeal.requestIOSTrackingAuthorization().then((_) async {
      // Initialize Appodeal after the authorization was granted or not
      await Appodeal.initialize(
        hasConsent: true,
        adTypes: [
          AdType.BANNER,
        ],
      );

      setState(() => this.isAppodealInitialized = true);
    });
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
