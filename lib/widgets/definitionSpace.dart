import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/appTheme.dart';
import '../classes/definitionClass.dart';
import '../constants/appConstants.dart';
import '../serviceLocator.dart';
import '../services/LocalStorageService.dart';

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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(300)),
                  ),
                  leading: Icon(Icons.info),
                  title: Text(
                    definitionList.searchWord,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).primaryTextTheme.bodyText1.fontSize,
                    ),
                  ),
                  subtitle: Text(
                    'Tap for full text search. Tip : To directly do a full text search press the Enter key instead of selecting from the dropdown',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).primaryTextTheme.bodyText1.fontSize,
                    ),
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
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .fontSize,
                        ),
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
                      style: TextStyle(
                        fontSize: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .fontSize,
                      ),
                    ),
                    onPressed: () {},
                  ),
                );
              }
            }
            return Container(
              child: ListTileTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(300)),
                ),
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
            fontSize: Theme.of(context).primaryTextTheme.bodyText1.fontSize,
          ),
        ),
        onTap: () {},
      );
    } else {
      return ListTile(
        isThreeLine: true,
        selected: definitionList.highlight[index - 1] == 1,
        selectedTileColor:
            hexToColor(locator<LocalStorageService>().highlightTileColor),
        contentPadding: EdgeInsets.fromLTRB(16.0, 0, 16, 0),
        title: HtmlWidget(
          definitionList.definition[index - 1],
          textStyle: TextStyle(
            fontSize: Theme.of(context).primaryTextTheme.bodyText1.fontSize,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.arrow_forward),
            Text(
              'In Qur\'an - ${definitionList.quranOccurance[index - 1]} times.',
              style: TextStyle(
                fontSize: Theme.of(context).primaryTextTheme.bodyText1.fontSize,
              ),
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    '${definitionList.quranOccurance[index - 1]} Occurances in the Qur\'an',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).primaryTextTheme.bodyText1.fontSize,
                    ),
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

                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(48, 0, 48, 0),
                                  child: ListTile(
                                    onTap: () async {
                                      if (await canLaunch(uriScheme)) {
                                        await launch(uriScheme);
                                      } else
                                        launch(
                                            "https://www.quran.com/${snapshot.data[j]['SURAH']}/${snapshot.data[j]['AYAH']}");
                                    },
                                    leading: Text(
                                      '${j + 1} - ',
                                      style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText1
                                            .fontSize,
                                      ),
                                    ),
                                    title: Text(
                                      "Quran ${snapshot.data[j]['SURAH']}:${snapshot.data[j]['AYAH']}/${snapshot.data[j]['POSITION']}",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyText1
                                              .fontSize,
                                          decoration: TextDecoration.underline,
                                          color: Theme.of(context).accentColor),
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
                      style: TextStyle(
                        fontSize: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .fontSize,
                      ),
                    ),
                    onPressed: Navigator.of(context).pop,
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }
}
