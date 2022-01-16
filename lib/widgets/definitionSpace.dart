import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hans_wehr_dictionary/screens/donate.dart';
import 'package:hans_wehr_dictionary/screens/favorites.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../classes/appTheme.dart';
import '../classes/definitionClass.dart';
import '../constants/appConstants.dart';
import '../serviceLocator.dart';
import '../services/LocalStorageService.dart';

class DefinitionSpace extends StatefulWidget {
  DefinitionSpace({
    Key? key,
  }) : super(key: key);
  @override
  _DefinitionSpaceState createState() => _DefinitionSpaceState();
}

class _DefinitionSpaceState extends State<DefinitionSpace> {
  @override
  Widget build(BuildContext context) {
    return FloatingSearchAppBar(
      color: Theme.of(context).scaffoldBackgroundColor,
      colorOnScroll: Theme.of(context).scaffoldBackgroundColor,
      transitionDuration: const Duration(milliseconds: 800),
      body: Consumer<DefinitionClass>(
        builder: (_, definitionList, __) {
          if (definitionList.searchType == null) {
            return HomeScreen();
          } else if (definitionList.searchType == '/favorites') {
            return Favorites();
          } else if (definitionList.searchType == '/donate') {
            return Donate();
          }
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
            itemCount: definitionList.definition.length + 1,
            separatorBuilder: (context, index) {
              return definitionList.isRoot[index] == 1
                  ? Divider()
                  : Container();
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                if (definitionList.searchType == 'RootSearch') {
                  return ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      definitionList.searchWord!,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    subtitle: Text(
                      'Tap for full text search. Tip : To directly do a full text search press the Enter key instead of selecting from the dropdown',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onTap: () async {
                      definitionList.searchType = 'FullTextSearch';
                      DefinitionClass value = await databaseObject.definition(
                          definitionList.searchWord, definitionList.searchType);
                      setState(() {
                        definitionList.id = value.id;
                        definitionList.word = value.word;
                        definitionList.definition = value.definition;
                        definitionList.isRoot = value.isRoot;
                        definitionList.highlight = value.highlight;
                        definitionList.quranOccurrence = value.quranOccurrence;
                        definitionList.favoriteFlag = value.favoriteFlag;
                      });
                    },
                  );
                } else if (definitionList.searchType == 'FullTextSearch') {
                  if (definitionList.definition.length > 50) {
                    return Container(
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.info,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        label: Text(
                          'Too many matches, showing limited results for ${definitionList.searchWord}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onPressed: () {},
                      ),
                    );
                  }
                  return Container(
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.info,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      label: Text(
                        definitionList.searchWord ?? "Loading...",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onPressed: () {},
                    ),
                  );
                }
              }
              return Container(
                child: ListTileTheme(
                  selectedColor: hexToColor(
                      locator<LocalStorageService>().highlightTextColor),
                  child: DefinitionTile(
                      definitionList: definitionList, index: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
          padding: EdgeInsets.all(8),
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          // crossAxisCount: 2,
          children: [
            HomePageCards(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              title: "Favorites",
              route: "/favorites",
            ),
            HomePageCards(
              title: "#UnfreezeAfghanistan",
              subtitle: "Millions are facing starvation.\nDONATE NOW",
              route: "/donate",
            ),
            // HomePageCards(
            //   icon: Icon(
            //     Icons.history,
            //     color: Colors.red,
            //   ),
            //   title: "History",
            //   route: "/history",
            // ),
          ],
        );
      },
    );
  }
}

class HomePageCards extends StatelessWidget {
  const HomePageCards({
    Key? key,
    required this.title,
    this.icon,
    this.subtitle,
    required this.route,
  }) : super(key: key);
  final String title;
  final Icon? icon;
  final String? subtitle;
  final String route;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<DefinitionClass>(context, listen: false)
            .updateSerachType(route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              title,
              style: Theme.of(context).textTheme.headline6,
              maxLines: 1,
            ),
            icon ??
                AutoSizeText(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                  maxLines: 2,
                ),
          ],
        ),
        color: Theme.of(context).canvasColor.withAlpha(100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}

class DefinitionTile extends StatelessWidget {
  final DefinitionClass? definitionList;
  final int? index;
  const DefinitionTile({
    Key? key,
    this.definitionList,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Offset _tapPosition = Offset(10.0, 10.0);
    return GestureDetector(
      child: ListTile(
        isThreeLine: true,
        selected: definitionList!.highlight[index! - 1] == 1,
        selectedTileColor:
            hexToColor(locator<LocalStorageService>().highlightTileColor),
        // contentPadding: EdgeInsets.fromLTRB(16.0, 0, 24, 0),
        contentPadding: EdgeInsets.fromLTRB(
            definitionList!.isRoot[index! - 1] == 1 ? 16.0 : 50, 0, 16, 0),

        title: HtmlWidget(
          definitionList!.definition[index! - 1]!,
          textStyle: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
            fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            definitionList!.isRoot[index! - 1] == 1
                ? FavIconWidget(definitionList: definitionList, index: index)
                : Container(),
            definitionList!.quranOccurrence![index! - 1] != null
                ? ElevatedButton(
                    onPressed: () {
                      if (definitionList!.quranOccurrence![index! - 1] != null)
                        quranoccurrenceDialog(context);
                    },
                    child: Text(
                      "${definitionList!.quranOccurrence![index! - 1]} occurrences in Qur'an",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).textTheme.bodyText2!.color,
                    ),
                  )
                : Container(),
          ],
        ),
        onTap: () {},
        onLongPress: () {
          contextMenu(context, _tapPosition);
        },
      ),
      onTapDown: (details) => _tapPosition = details.globalPosition,
    );
    // }
  }

  quranoccurrenceDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              '${definitionList!.quranOccurrence![index! - 1]} Occurrences in the Qur\'an',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          titlePadding: const EdgeInsets.all(8.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: Container(
            height: MediaQuery.of(context).size.height * .7,
            width: MediaQuery.of(context).size.width * .9,
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: databaseObject
                    .quranicDetails(definitionList!.word[index! - 1]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, j) {
                          String uriScheme =
                              "quran://${snapshot.data![j]['SURAH']}/${snapshot.data![j]['AYAH']}/${snapshot.data![j]['POSITION']}";

                          return ListTile(
                            onTap: () async {
                              if (await canLaunch(uriScheme)) {
                                await launch(uriScheme);
                              } else
                                await launch(
                                    "https://www.quran.com/${snapshot.data![j]['SURAH']}/${snapshot.data![j]['AYAH']}");
                            },
                            leading: Text(
                              '${j + 1} - ',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            title: Text(
                              "Quran ${snapshot.data![j]['SURAH']}:${snapshot.data![j]['AYAH']}/${snapshot.data![j]['POSITION']}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          actions: [
            TextButton(
              child: Text(
                'DISMISS',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }

  contextMenu(BuildContext context, Offset tapPosition) async {
    int? choice = await showMenu(
      position: RelativeRect.fromRect(
          tapPosition & const Size(40, 40), // smaller rect, the touch area
          Offset.zero &
              Overlay.of(context)!
                  .context
                  .findRenderObject()!
                  .semanticBounds
                  .size),
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.copy),
              SizedBox(
                width: 8,
              ),
              Text('Copy Selected Definition'),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.copy),
              SizedBox(
                width: 8,
              ),
              Text('Copy Root and Derivatives'),
            ],
          ),
        ),
      ],
      context: context,
    );
    switch (choice) {
      case 0:
        Clipboard.setData(ClipboardData(
          text: parse(parse(definitionList!.definition[index! - 1]).body!.text)
              .documentElement!
              .text,
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Copied"),
          ),
        );
        break;
      case 1:
        String text = '';
        for (var i = index! - 1; i >= 0; i--) {
          text =
              definitionList!.definition[i]! + '\n-*-*-*-*-*-*-*-*-*-\n' + text;
          if (definitionList!.isRoot[i] == 1) break;
        }
        print(text);
        for (var i = index!; i < definitionList!.definition.length; i++) {
          if (definitionList!.isRoot[i] == 1) break;
          text =
              text + definitionList!.definition[i]! + '\n-*-*-*-*-*-*-*-*-*-\n';
        }
        Clipboard.setData(ClipboardData(
          text: parse(parse(text).body!.text).documentElement!.text,
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Copied"),
          ),
        );
        break;
      default:
    }
  }
}

class FavIconWidget extends StatefulWidget {
  const FavIconWidget({Key? key, this.definitionList, this.index})
      : super(key: key);
  final DefinitionClass? definitionList;
  final int? index;
  @override
  _FavIconWidgetState createState() => _FavIconWidgetState();
}

class _FavIconWidgetState extends State<FavIconWidget> {
  Color? favIconColor;

  @override
  void initState() {
    super.initState();
    favIconColor = widget.definitionList!.favoriteFlag[widget.index! - 1] == 1
        ? Colors.red
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        toggleFavoritesMethod(widget.definitionList!, widget.index!, context);
        setState(() {
          favIconColor = favIconColor == Colors.red ? Colors.grey : Colors.red;
        });
      },
      icon: Icon(
        Icons.favorite,
        color: favIconColor,
      ),
    );
  }
}

void toggleFavoritesMethod(
    DefinitionClass definitionList, int index, BuildContext context) {
  int toggleFavoriteFlag = definitionList.favoriteFlag[index - 1] == 1 ? 0 : 1;
  definitionList.favoriteFlag[index - 1] = toggleFavoriteFlag;
  databaseObject.toggleFavorites(
      definitionList.id[index - 1]!, toggleFavoriteFlag);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: definitionList.favoriteFlag[index - 1] == 1
          ? Text("Added ${definitionList.word[index - 1]} to favorites")
          : Text("Removed ${definitionList.word[index - 1]} from favorites"),
    ),
  );
}
