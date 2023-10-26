import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../classes/definition_provider.dart';
import '../widgets/drawer.dart';
import '../constants/app_constants.dart';
import '../widgets/quran_occurrence_alert.dart';

class Browse extends StatefulWidget {
  const Browse({Key? key}) : super(key: key);

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          browseScreenTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: const CommonDrawer(currentScreen: browseScreenTitle),
      body: buildFirstLevelAlphabets(),
    );
  }

  ListView buildFirstLevelAlphabets() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
      itemCount: allAlphabets.length,
      itemBuilder: (context, i) {
        return ExpansionTile(
          collapsedIconColor: Theme.of(context).textTheme.bodyLarge!.color,
          collapsedTextColor: Theme.of(context).textTheme.bodyLarge!.color,
          iconColor: Theme.of(context).textTheme.bodyMedium!.color,
          textColor: Theme.of(context).textTheme.bodyMedium!.color,
          title: Text(
            allAlphabets[i],
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
            ),
          ),
          children: [buildSecondLevelAlphabets(i)],
        );
      },
    );
  }

  FutureBuilder<List<String?>> buildSecondLevelAlphabets(int i) {
    return FutureBuilder<List<String?>>(
      future: databaseObject.allXLevelWords(allAlphabets[i], 2),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'Loading...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        } else {
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, j) {
                return ExpansionTile(
                  iconColor: Theme.of(context).textTheme.bodyMedium!.color,
                  textColor: Theme.of(context).textTheme.bodyMedium!.color,
                  tilePadding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  title: Text(
                    snapshot.data![j]!,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.bodyLarge!.fontFamily,
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
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
                physics: const NeverScrollableScrollPhysics(),
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
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {
                        buildDefinitionAlert(context, snapshot.data![j]);
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

// buildDefinitionDialog(BuildContext context, String? word) {
//   FutureBuilder<DefinitionClass>(
//       future: databaseObject.definition(word, "BrowseScreen"),
//       builder: (context, snapshot) {});
// }

Future buildDefinitionAlert(BuildContext context, String? word) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<DefinitionProvider>(
        future: databaseObject.definition(word, "BrowseScreen"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              insetPadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(15),
              title: Center(
                child: Text(
                  word!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * .7,
                width: MediaQuery.of(context).size.width * .9,
                child: ListView.builder(
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
                        textStyle: Theme.of(context).textTheme.bodyLarge!,
                      ),
                    );
                  },
                ),
              ),
              actions: [
                snapshot.data!.quranOccurrence![0] != null
                    ? TextButton(
                        child: Text(
                          'Q - ${snapshot.data!.quranOccurrence![0]}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onPressed: () {
                          quranOccurrenceDialog(context,
                              snapshot.data!.quranOccurrence![0]!, word);
                        },
                      )
                    : Container(),
                TextButton(
                  child: Text(
                    'DISMISS',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      );
    },
  );
}
