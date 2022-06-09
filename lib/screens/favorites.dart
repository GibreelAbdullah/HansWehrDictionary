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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FAVORITES',
              textAlign: TextAlign.center,
              textScaleFactor: 2,
              style: Theme.of(context).textTheme.bodyText1,
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
                            Icons.heart_broken,
                            size: 72,
                            color: Colors.grey,
                          ),
                          Text(
                            'Favorite some words by selecting ❤️ icon',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: favData.length,
                        itemBuilder: (context, j) {
                          return Container(
                            decoration: BoxDecoration(
                              color: j % 2 == 0
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withAlpha(20),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: ListTile(
                              onTap: () async {
                                buildDefinitionAlert(
                                    context, favData[j]['word']);
                              },
                              leading: Text(
                                '${j + 1} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color!
                                            .withAlpha(100)),
                              ),
                              title: Text(
                                favData[j]['word'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () {
                                  databaseObject.toggleFavorites(
                                      favData[j]['id'], 0);
                                  setState(() {
                                    favData.removeAt(j);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
