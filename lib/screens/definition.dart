import 'package:flutter/material.dart';
import 'package:search/components/searchWidget.dart';
import 'package:search/constants/appConstants.dart';
import '../components/searchWidget.dart';

class Definition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String word = ModalRoute.of(context).settings.arguments;
    print(word);
    return Scaffold(
      appBar: AppBar(
        title: Text(word),
      ),
      body: Stack(
        children: [
          definitionList(word),
          SearchWidget(),

        ],
      ),
    );
  }
}

Widget definitionList(String word) {
  return FutureBuilder(
    future: databaseObject.definition(word),
    builder: (context, definition) {
      if (definition.hasData == false) {
        return Container();
      }
      return Flexible(
        child: ListView.builder(
          itemCount: definition.data.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(definition.data[index]),
            );
          },
        ),
      );
    },
  );
}
