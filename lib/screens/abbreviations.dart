import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../constants/appConstants.dart';

class Abbreviations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          ABBREVIATIONS_SCREEN_TITLE,
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(currentScreen: ABBREVIATIONS_SCREEN_TITLE),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 100),
        itemCount: 196,
        itemBuilder: (context, index) {
          if (FULL_FORM[index] == "") {
            return Container(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                ABBREVIATIONS[index],
                textScaleFactor: 2,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.grey,
                    ),
              ),
            );
          } else {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: Text(ABBREVIATIONS[index],
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 200,
                    child: Text(FULL_FORM[index],
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
