import 'package:flutter/material.dart';
import '../classes/search_suggestions_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/drawer.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchSuggestionsProvider().getHistory();

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 56,
          title: Text(
            historyScreenTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: Theme.of(context).iconTheme,
        ),
        drawer: const CommonDrawer(currentScreen: historyScreenTitle),
        body: ListView.builder(
          itemCount: SearchSuggestionsProvider().getHistory().length,
          itemBuilder: (context, index) {
            return ListTile(
              // leading: Text((index + 1).toString()),
              title: Text(
                '${index + 1} - ${SearchSuggestionsProvider().getHistory()[SearchSuggestionsProvider().getHistory().length - index - 1]}',
              ),
            );
          },
        )
        // body: Container(child: Text(SearchModel().getHistory().toString())),
        );
  }
}
