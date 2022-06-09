import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hans_wehr_dictionary/screens/quranicWords.dart';
import '../screens/donate.dart';
import '../screens/favorites.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import '../classes/appTheme.dart';
import '../classes/definitionClass.dart';
import '../constants/appConstants.dart';
import '../serviceLocator.dart';
import '../services/LocalStorageService.dart';
import 'quranOccurrenceAlert.dart';

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
          if (DefinitionClass.searchType == null) {
            return HomeScreen();
          } else if (DefinitionClass.searchType == '/favorites') {
            return Favorites();
          } else if (DefinitionClass.searchType == '/donate') {
            return Donate();
          } else if (DefinitionClass.searchType == '/quranicWords') {
            return QuranicWords();
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
                if (DefinitionClass.searchType == 'RootSearch') {
                  return ListTile(
                    title: Text(
                      definitionList.searchWord!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    subtitle: definitionList.definition.length == 0
                        ? Text(
                            'No results found.\nTap here for full text search.',
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Tap here for full text search.\nTo directly do a full text search press the Enter key instead of selecting from the dropdown.',
                            textAlign: TextAlign.center,
                          ),
                    onTap: () async {
                      DefinitionClass.searchType = 'FullTextSearch';
                      DefinitionClass value = await databaseObject.definition(
                          definitionList.searchWord,
                          DefinitionClass.searchType);
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
                } else if (DefinitionClass.searchType == 'FullTextSearch') {
                  if (definitionList.definition.length > 50 ||
                      definitionList.definition.length == 0) {
                    return ListTile(
                      title: Text(
                        definitionList.searchWord!,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: definitionList.definition.length == 0
                          ? Text(
                              'No results found',
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              'Too many matches, results might be truncated.',
                              textAlign: TextAlign.center,
                            ),
                      onTap: () {},
                    );
                  }
                  return ListTile(
                    title: Text(
                      definitionList.searchWord!,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
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
              imagePath: FAV_IMAGE,
              route: "/favorites",
            ),
            HomePageCards(
              imagePath: QURAN_IMAGE,
              route: "/quranicWords",
            ),
            HomePageCards(
              imagePath: DONATE_IMAGE,
              route: "/donate",
            ),
            HomePageCards(
              imagePath: QURANLE_IMAGE,
              uri: quranleUri,
            ),
            HomePageCards(
              imagePath: FOR_HIRE_IMAGE,
              uri: portfolioUri,
            ),
          ],
        );
      },
    );
  }
}

class HomePageCards extends StatelessWidget {
  const HomePageCards({
    Key? key,
    required this.imagePath,
    this.route,
    this.uri,
  }) : super(key: key);
  final String imagePath;
  final String? route;
  final Uri? uri;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        route != null
            ? Provider.of<DefinitionClass>(context, listen: false)
                .updateSearchType(route!)
            : launchUrl(uri!, mode: LaunchMode.externalApplication);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image: AssetImage(imagePath), fit: BoxFit.cover),
          ),
          child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
            shadowColor: Theme.of(context).primaryColor,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
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
                        quranOccurrenceDialog(
                            context,
                            definitionList!.quranOccurrence![index! - 1]!,
                            definitionList!.word[index! - 1]!);
                    },
                    child: Text(
                      "Q - ${definitionList!.quranOccurrence![index! - 1]}",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
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
  }

  @override
  Widget build(BuildContext context) {
    favIconColor = widget.definitionList!.favoriteFlag[widget.index! - 1] == 1
        ? Colors.red
        : Colors.grey;
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
