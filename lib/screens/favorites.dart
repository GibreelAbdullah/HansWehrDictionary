import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'browse.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);
  @override
  State<Favorites> createState() => _FavoritesState();
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
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: databaseObject.getFavorites(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> favData = [];
                  favData.addAll(snapshot.data!);
                  if (favData.isEmpty) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.heart_broken,
                            size: 72,
                            color: Colors.grey,
                          ),
                          Text(
                            'Favorite some words by selecting ❤️ icon',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                              borderRadius: const BorderRadius.all(
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
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withAlpha(100)),
                              ),
                              title: Text(
                                favData[j]['word'],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_forever),
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
                  return const Center(
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
