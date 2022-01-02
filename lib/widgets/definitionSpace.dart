import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:badges/badges.dart';
import 'package:html/parser.dart';
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
                        definitionList.quranOccurance = value.quranOccurance;
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
                          'Showing First 50 results for ${definitionList.searchWord}',
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
                        definitionList.searchWord ?? "assdsdsdsd",
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
        Navigator.pushNamed(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            Center(
              child: icon ??
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
            ),
          ],
        ),
        color: Theme.of(context).canvasColor.withAlpha(200),
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
    if (definitionList!.quranOccurance![index! - 1] == null) {
      return GestureDetector(
        child: ListTile(
          selected: definitionList!.highlight[index! - 1] == 1,
          selectedTileColor:
              hexToColor(locator<LocalStorageService>().highlightTileColor),
          contentPadding: EdgeInsets.fromLTRB(
              definitionList!.isRoot[index! - 1] == 1 ? 16.0 : 50, 0, 16, 0),
          title: HtmlWidget(
            definitionList!.definition[index! - 1]!,
            textStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
              fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
            ),
          ),
          onLongPress: () {
            contextMenu(context, _tapPosition);
          },
          onTap: () {},
        ),
        onTapDown: (details) => _tapPosition = details.globalPosition,
      );
    } else {
      return GestureDetector(
        child: ListTile(
          isThreeLine: true,
          selected: definitionList!.highlight[index! - 1] == 1,
          selectedTileColor:
              hexToColor(locator<LocalStorageService>().highlightTileColor),
          contentPadding: EdgeInsets.fromLTRB(16.0, 0, 24, 0),
          title: HtmlWidget(
            definitionList!.definition[index! - 1]!,
            textStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
              fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
            ),
          ),
          subtitle: Center(
            child: Badge(
              toAnimate: false,
              padding: EdgeInsets.all(2),
              badgeColor: hexToColor(
                      locator<LocalStorageService>().highlightTextColor) ??
                  Colors.red,
              badgeContent: Text(
                '${definitionList!.quranOccurance![index! - 1]}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              child: Icon(Icons.menu_book),
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                    child: Text(
                      '${definitionList!.quranOccurance![index! - 1]} Occurances in the Qur\'an',
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    title: Text(
                                      "Quran ${snapshot.data![j]['SURAH']}:${snapshot.data![j]['AYAH']}/${snapshot.data![j]['POSITION']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            color:
                                                Theme.of(context).primaryColor,
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
          },
          onLongPress: () {
            contextMenu(context, _tapPosition);
          },
        ),
        onTapDown: (details) => _tapPosition = details.globalPosition,
      );
    }
  }

  contextMenu(BuildContext context, Offset tapPosition) async {
    List<PopupMenuEntry<int>> contextMenuItems = [
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
    ];

    if (definitionList!.isRoot[index! - 1] == 1)
      contextMenuItems.add(
        PopupMenuItem<int>(
          value: 2,
          child: definitionList!.favoriteFlag[index! - 1] == 1
              ? Row(
                  children: [
                    Icon(Icons.favorite_border),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Remove from Favorites')
                  ],
                )
              : Row(
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Add to Favorites'),
                  ],
                ),
        ),
      );
    int? choice = await showMenu(
      position: RelativeRect.fromRect(
          tapPosition & const Size(40, 40), // smaller rect, the touch area
          Offset.zero &
              Overlay.of(context)!
                  .context
                  .findRenderObject()!
                  .semanticBounds
                  .size),
      items: contextMenuItems,
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
      case 2:
        int toggleFavoriteFlag =
            definitionList!.favoriteFlag[index! - 1] == 1 ? 0 : 1;
        definitionList!.favoriteFlag[index! - 1] = toggleFavoriteFlag;
        databaseObject.toggleFavorites(
            definitionList!.id[index! - 1]!, toggleFavoriteFlag);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: definitionList!.favoriteFlag[index! - 1] == 1
                ? Text("Added")
                : Text("Removed"),
          ),
        );
        break;
      default:
    }
  }
}
