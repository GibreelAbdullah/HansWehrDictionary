import 'package:flutter/material.dart';
import '../constants/appConstants.dart';
import '../widgets/drawer.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          FAVORITES_SCREEN_TITLE,
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(currentScreen: FAVORITES_SCREEN_TITLE),
      // body: fut,
    );
  }
}
