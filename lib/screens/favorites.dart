import 'package:flutter/material.dart';
import '../constants/appConstants.dart';
import 'browse.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            // alignment: Alignment.centerLeft,
            children: [
              Text(
                'Favorites',
                textScaleFactor: 2,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Icon(
                Icons.favorite,
                color: Colors.red,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: databaseObject.getFavorites(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> favData = [];
              favData.addAll(snapshot.data!);
              if (favData.length == 0) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.report_gmailerrorred,
                        size: 72,
                        color: Colors.grey,
                      ),
                      Text(
                        'Nothing to see here',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                );
              }
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
        ),
      ],
    );
  }
}
