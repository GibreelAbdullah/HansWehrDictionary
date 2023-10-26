import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'classes/definition_provider.dart';
import 'classes/search_suggestions_provider.dart';
import 'classes/theme_model.dart';
import 'service_locator.dart';
import 'services/app_review.dart';
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator().then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeModel>(
            create: (BuildContext context) => ThemeModel(),
          ),
          ChangeNotifierProvider<SearchSuggestionsProvider>(
            create: (_) => SearchSuggestionsProvider(),
          ),
          ChangeNotifierProvider<DefinitionProvider>(
            create: (_) => DefinitionProvider(
              id: [],
              word: [],
              definition: [],
              isRoot: [],
              highlight: [],
              quranOccurrence: [],
              favoriteFlag: [],
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
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
    return MaterialApp(
        title: "Hans Wehr Dictionary",
        theme: Provider.of<ThemeModel>(context, listen: true).currentTheme,
        initialRoute: '/search',
        routes: routes);
  }
}
