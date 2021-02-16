import 'package:flutter/material.dart';
import '../services/LocalStorageService.dart';
import '../widgets/drawer.dart';
import '../constants/appConstants.dart';

import '../serviceLocator.dart';

class Abbreviations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          ABBREVIATIONS_SCREEN_TITLE,
          style: TextStyle(
            color: locator<LocalStorageService>().darkTheme
                ? Colors.white
                : Colors.black,
          ),
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
                style: TextStyle(
                  color: Colors.grey,
                  fontSize:
                      Theme.of(context).primaryTextTheme.bodyText1.fontSize,
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
                    child: Text(
                      ABBREVIATIONS[index],
                      style: TextStyle(
                        fontSize: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .fontSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      FULL_FORM[index],
                      style: TextStyle(
                        fontSize: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .fontSize,
                      ),
                    ),
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
