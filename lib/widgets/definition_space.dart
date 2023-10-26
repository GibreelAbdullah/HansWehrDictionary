import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../screens/donate.dart';
import '../screens/favorites.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import '../classes/app_theme.dart';
import '../classes/definition_provider.dart';
import '../constants/app_constants.dart';
import '../screens/quranic_words.dart';
import '../service_locator.dart';
import '../services/local_storage_service.dart';
import 'quran_occurrence_alert.dart';

class DefinitionSpace extends StatefulWidget {
  const DefinitionSpace({
    Key? key,
  }) : super(key: key);
  @override
  State<DefinitionSpace> createState() => _DefinitionSpaceState();
}

class _DefinitionSpaceState extends State<DefinitionSpace> {
  @override
  Widget build(BuildContext context) {
    //The entire screen, not just the AppBar, body contains the rest.
    return FloatingSearchAppBar(
      color: Theme.of(context).scaffoldBackgroundColor,
      colorOnScroll: Theme.of(context).scaffoldBackgroundColor,
      transitionDuration: const Duration(milliseconds: 800),
      //The area below the app bar
      body: Consumer<DefinitionProvider>(
        builder: (_, definitionList, __) {
          if (definitionList.searchType == null) {
            return const HomeScreen();
          } else if (definitionList.searchType == '/favorites') {
            return const Favorites();
          } else if (definitionList.searchType == '/donate') {
            return const Donate();
          } else if (definitionList.searchType == '/quranicWords') {
            return const QuranicWords();
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
            itemCount: definitionList.definition.length + 1,
            separatorBuilder: (context, index) {
              return definitionList.isRoot[index] == 1
                  ? const Divider()
                  : Container();
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                if (definitionList.searchType == 'RootSearch') {
                  return ListTile(
                    title: Text(
                      definitionList.searchWord!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: definitionList.definition.isEmpty
                        ? const Text(
                            'No results found.\nTap here for full text search.',
                            textAlign: TextAlign.center,
                          )
                        : const Text(
                            'Tap here for full text search.\nTo directly do a full text search press the Enter key instead of selecting from the dropdown.',
                            textAlign: TextAlign.center,
                          ),
                    onTap: () async {
                      definitionList.searchType = 'FullTextSearch';
                      DefinitionProvider value =
                          await databaseObject.definition(
                              definitionList.searchWord,
                              definitionList.searchType);
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
                  if (definitionList.definition.length > 50 ||
                      definitionList.definition.isEmpty) {
                    return ListTile(
                      title: Text(
                        definitionList.searchWord!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: definitionList.definition.isEmpty
                          ? const Text(
                              'No results found',
                              textAlign: TextAlign.center,
                            )
                          : const Text(
                              'Too many matches, results might be truncated.',
                              textAlign: TextAlign.center,
                            ),
                      onTap: () {},
                    );
                  }
                  return ListTile(
                    title: Text(
                      definitionList.searchWord!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              }
              return ListTileTheme(
                selectedColor: hexToColor(
                    locator<LocalStorageService>().highlightTextColor),
                child: DefinitionTile(
                    definitionList: definitionList, index: index),
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
          padding: const EdgeInsets.all(8),
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          // crossAxisCount: 2,
          children: [
            const HomePageCards(
              imagePath: favImage,
              route: "/favorites",
            ),
            const HomePageCards(
              imagePath: quranImage,
              route: "/quranicWords",
            ),
            const HomePageCards(
              imagePath: donateImage,
              route: "/donate",
            ),
            HomePageCards(
              imagePath: quranleImage,
              uri: quranleUri,
            ),
            HomePageCards(
              imagePath: forHireImage,
              uri: portfolioUri,
            ),
            HomePageCards(
              imagePath: hadithhubImage,
              uri: hadithHubUri,
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
            ? Provider.of<DefinitionProvider>(context, listen: false)
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
            shadowColor: Theme.of(context).primaryColor,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}

class DefinitionTile extends StatelessWidget {
  final DefinitionProvider? definitionList;
  final int? index;
  const DefinitionTile({
    Key? key,
    this.definitionList,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Offset tapPosition = const Offset(10.0, 10.0);
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
            fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
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
                      if (definitionList!.quranOccurrence![index! - 1] !=
                          null) {
                        quranOccurrenceDialog(
                            context,
                            definitionList!.quranOccurrence![index! - 1]!,
                            definitionList!.word[index! - 1]!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      "Q - ${definitionList!.quranOccurrence![index! - 1]}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  )
                : Container(),
          ],
        ),
        onTap: () {},
        onLongPress: () {
          contextMenu(context, tapPosition);
        },
      ),
      onTapDown: (details) => tapPosition = details.globalPosition,
    );
    // }
  }

  contextMenu(BuildContext context, Offset tapPosition) async {
    int? choice = await showMenu(
      position: RelativeRect.fromRect(
          tapPosition & const Size(40, 40), // smaller rect, the touch area
          Offset.zero &
              Overlay.of(context)
                  .context
                  .findRenderObject()!
                  .semanticBounds
                  .size),
      items: [
        const PopupMenuItem<int>(
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
        const PopupMenuItem<int>(
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
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Copied"),
          ),
        );
        break;
      case 1:
        String text = '';
        for (var i = index! - 1; i >= 0; i--) {
          text =
              '${definitionList!.definition[i]!}\n-*-*-*-*-*-*-*-*-*-\n$text';
          if (definitionList!.isRoot[i] == 1) break;
        }
        for (var i = index!; i < definitionList!.definition.length; i++) {
          if (definitionList!.isRoot[i] == 1) break;
          text =
              '$text${definitionList!.definition[i]!}\n-*-*-*-*-*-*-*-*-*-\n';
        }
        Clipboard.setData(ClipboardData(
          text: parse(parse(text).body!.text).documentElement!.text,
        ));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
  final DefinitionProvider? definitionList;
  final int? index;
  @override
  State<FavIconWidget> createState() => _FavIconWidgetState();
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
    DefinitionProvider definitionList, int index, BuildContext context) {
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
