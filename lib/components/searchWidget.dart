import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import '../constants/appConstants.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchBar(
      
      debounceDuration: Duration(milliseconds: 100),
      textStyle: TextStyle(color: Colors.white),
      hintText: "Search",
      minimumChars: 1,
      onSearch: search,
      loader: Container(),
      onItemFound: (String word, int index) {
        return Container(
          child: ListTile(
            title: Text(word),
            onTap: () {
              Navigator.pushNamed(context, '/definition', arguments: word);
            },
          ),
        );
      },
    );
  }
}

Future<List<String>> search(String searchWord) async {
  return databaseObject.words(searchWord);
}
