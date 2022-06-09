import 'package:flutter/material.dart';
import '../classes/searchModel.dart';
import '../constants/appConstants.dart';
import '../widgets/drawer.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchModel().getHistory();

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 56,
          title: Text(
            HISTORY_SCREEN_TITLE,
            style: Theme.of(context).textTheme.headline6,
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: Theme.of(context).iconTheme,
        ),
        drawer: CommonDrawer(currentScreen: HISTORY_SCREEN_TITLE),
        body: ListView.builder(
          itemCount: SearchModel().getHistory().length,
          itemBuilder: (context, index) {
            return ListTile(
              // leading: Text((index + 1).toString()),
              title: Text(
                (index + 1).toString() +
                    ' - ' +
                    SearchModel().getHistory()[
                        SearchModel().getHistory().length - index - 1],
              ),
            );
          },
        )
        // body: Container(child: Text(SearchModel().getHistory().toString())),
        );
  }
}
