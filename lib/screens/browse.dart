import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../classes/definitionClass.dart';
import '../widgets/drawer.dart';
import '../constants/appConstants.dart';

class Browse extends StatefulWidget {
  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          BROWSE_SCREEN_TITLE,
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(currentScreen: BROWSE_SCREEN_TITLE),
      body: buildFirstLevelAlphabets(),
    );
  }

  ListView buildFirstLevelAlphabets() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
      itemCount: ALL_ALPHABETS.length,
      itemBuilder: (context, i) {
        return ExpansionTile(
          collapsedIconColor: Theme.of(context).textTheme.bodyText1!.color,
          collapsedTextColor: Theme.of(context).textTheme.bodyText1!.color,
          iconColor: Theme.of(context).textTheme.bodyText2!.color,
          textColor: Theme.of(context).textTheme.bodyText2!.color,
          title: Text(
            ALL_ALPHABETS[i],
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
              fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
            ),
          ),
          children: [buildSecondLevelAlphabets(i)],
        );
      },
    );
  }

  FutureBuilder<List<String?>> buildSecondLevelAlphabets(int i) {
    return FutureBuilder<List<String?>>(
      future: databaseObject.allXLevelWords(ALL_ALPHABETS[i], 2),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'Loading...',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        } else {
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, j) {
                return ExpansionTile(
                  iconColor: Theme.of(context).textTheme.bodyText2!.color,
                  textColor: Theme.of(context).textTheme.bodyText2!.color,
                  tilePadding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  title: Text(
                    snapshot.data![j]!,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.bodyText1!.fontFamily,
                      fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                    ),
                  ),
                  children: [buildRootWords(snapshot, j)],
                );
              });
        }
      },
    );
  }

  FutureBuilder<List<String?>> buildRootWords(
      AsyncSnapshot<List<String?>> snapshot, int j) {
    return FutureBuilder<List<String?>>(
        future: databaseObject.allXLevelWords(snapshot.data![j], 3),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, j) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
                    child: ListTile(
                      leading: Icon(
                        Icons.label_important,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(
                        snapshot.data![j]!,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onTap: () {
                        buildDefinitionAlert(context, snapshot.data![j]);
                      },
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Future buildDefinitionAlert(BuildContext context, String? word) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.all(0),
        title: Center(
          child: Text(
            word!,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * .7,
          width: MediaQuery.of(context).size.width * .9,
          child: FutureBuilder<DefinitionClass>(
            future: databaseObject.definition(word, "BrowseScreen"),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Text(
                  "Error",
                  style: Theme.of(context).textTheme.bodyText1,
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.definition.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.fromLTRB(
                          snapshot.data!.isRoot[index] == 1 ? 16.0 : 50.0,
                          0,
                          16,
                          0),
                      title: HtmlWidget(
                        snapshot.data!.definition[index]!,
                        textStyle: Theme.of(context).textTheme.bodyText1!,
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'DISMISS',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
