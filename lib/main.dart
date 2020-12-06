import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData.light(),
        
        // darkTheme: ThemeData.dark(),
        initialRoute: '/search',
        routes: routes);
  }
}
