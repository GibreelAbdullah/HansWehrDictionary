import 'package:flutter/material.dart';
import '../constants/appConstants.dart';
import '../widgets/drawer.dart';
import 'browse.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          FAVORITES_SCREEN_TITLE,
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(currentScreen: FAVORITES_SCREEN_TITLE),
      body: FavoritesList(),
    );
  }
}

class FavoritesList extends StatefulWidget {
  const FavoritesList({Key? key}) : super(key: key);
  @override
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: databaseObject.getFavorites(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> favData = [];
          favData.addAll(snapshot.data!);
          return ListView.builder(
            shrinkWrap: true,
            itemCount: favData.length,
            itemBuilder: (context, j) {
              return ListTile(
                onTap: () async {
                  buildDefinitionAlert(context, favData[j]['word']);
                },
                leading: Text(
                  '${j + 1} - ',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                title: Text(
                  favData[j]['word'],
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    databaseObject.toggleFavorites(favData[j]['id'], 0);
                    setState(() {
                      favData.removeAt(j);
                    });
                  },
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
