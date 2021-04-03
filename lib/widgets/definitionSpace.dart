import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/appTheme.dart';
import '../classes/definitionClass.dart';
import '../constants/appConstants.dart';
import '../serviceLocator.dart';
import '../services/LocalStorageService.dart';
import 'package:badges/badges.dart';
import 'package:html/parser.dart';

class DefinitionSpace extends StatefulWidget {
  DefinitionSpace({
    Key key,
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
        builder: (_, definitionList, __) => ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
          itemCount: definitionList.definition.length + 1,
          separatorBuilder: (context, index) {
            return definitionList.isRoot[index] == 1 ? Divider() : Container();
          },
          itemBuilder: (context, index) {
            if (index == 0) {
              if (definitionList.searchType == 'RootSearch') {
                return ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    definitionList.searchWord,
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
                      definitionList.word = value.word;
                      definitionList.definition = value.definition;
                      definitionList.isRoot = value.isRoot;
                      definitionList.highlight = value.highlight;
                      definitionList.quranOccurance = value.quranOccurance;
                    });
                  },
                );
              } else {
                if (definitionList.definition.length > 50) {
                  return Container(
                    child: FlatButton.icon(
                      icon: Icon(Icons.info),
                      label: Text(
                        'Showing First 50 results for ${definitionList.searchWord}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onPressed: () {},
                    ),
                  );
                }
                return Container(
                  child: FlatButton.icon(
                    icon: Icon(Icons.info),
                    label: Text(
                      definitionList.searchWord == null
                          ? "Search In Arabic or English"
                          : definitionList.searchWord,
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
        ),
      ),
    );
  }
}

class DefinitionTile extends StatelessWidget {
  final DefinitionClass definitionList;
  final int index;
  const DefinitionTile({
    Key key,
    this.definitionList,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (definitionList.quranOccurance[index - 1] == null) {
      return ListTile(
        selected: definitionList.highlight[index - 1] == 1,
        selectedTileColor:
            hexToColor(locator<LocalStorageService>().highlightTileColor),
        contentPadding: EdgeInsets.fromLTRB(
            definitionList.isRoot[index - 1] == 1 ? 16.0 : 50, 0, 16, 0),
        title: HtmlWidget(
          definitionList.definition[index - 1],
          textStyle: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
          ),
        ),
        onLongPress: () {
          copyAlert(context);
        },
        onTap: () {},
      );
    } else {
      return ListTile(
        isThreeLine: true,
        selected: definitionList.highlight[index - 1] == 1,
        selectedTileColor:
            hexToColor(locator<LocalStorageService>().highlightTileColor),
        contentPadding: EdgeInsets.fromLTRB(16.0, 0, 24, 0),
        title: HtmlWidget(
          definitionList.definition[index - 1],
          textStyle: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
          ),
        ),
        subtitle: Center(
          child: Badge(
            toAnimate: false,
            padding: EdgeInsets.all(2),
            badgeColor:
                hexToColor(locator<LocalStorageService>().highlightTextColor),
            badgeContent: Text(
              '${definitionList.quranOccurance[index - 1]}',
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
                    '${definitionList.quranOccurance[index - 1]} Occurances in the Qur\'an',
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
                          .quranicDetails(definitionList.word[index - 1]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, j) {
                                String uriScheme =
                                    "quran://${snapshot.data[j]['SURAH']}/${snapshot.data[j]['AYAH']}/${snapshot.data[j]['POSITION']}";

                                return ListTile(
                                  onTap: () async {
                                    if (await canLaunch(uriScheme)) {
                                      await launch(uriScheme);
                                    } else
                                      await launch(
                                          "https://www.quran.com/${snapshot.data[j]['SURAH']}/${snapshot.data[j]['AYAH']}");
                                  },
                                  leading: Text(
                                    '${j + 1} - ',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  title: Text(
                                    "Quran ${snapshot.data[j]['SURAH']}:${snapshot.data[j]['AYAH']}/${snapshot.data[j]['POSITION']}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          decoration: TextDecoration.underline,
                                          color: Theme.of(context).accentColor,
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
                  FlatButton(
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
          copyAlert(context);
        },
      );
    }
  }

  copyAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Options',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          titlePadding: const EdgeInsets.all(8.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: Container(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width * .9,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Copy Selected Definition'),
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                            text: parse(
                                    parse(definitionList.definition[index - 1])
                                        .body
                                        .text)
                                .documentElement
                                .text,
                          ));
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Copied"),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Copy Root and Derivatives'),
                        onTap: () {
                          String text = '';
                          for (var i = index - 1; i >= 0; i--) {
                            text = definitionList.definition[i] +
                                '\n-*-*-*-*-*-*-*-*-*-\n' +
                                text;
                            if (definitionList.isRoot[i] == 1) break;
                          }
                          print(text);
                          for (var i = index;
                              i < definitionList.definition.length;
                              i++) {
                            if (definitionList.isRoot[i] == 1) break;
                            text = text +
                                definitionList.definition[i] +
                                '\n-*-*-*-*-*-*-*-*-*-\n';
                          }
                          print(text);

                          Clipboard.setData(ClipboardData(
                            text: parse(parse(text).body.text)
                                .documentElement
                                .text,
                          ));
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Copied"),
                            ),
                          );

                          // Clipboard.setData(ClipboardData(text: '123'));
                          // Scaffold.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text("Copied"),
                          //   ),
                          // );
                        },
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          actions: [
            FlatButton(
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
}
