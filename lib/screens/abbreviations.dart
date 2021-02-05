import 'package:flutter/material.dart';
import 'package:search/widgets/drawer.dart';
import 'package:search/constants/appConstants.dart';
import 'package:search/constants/abbreviationList.dart';

class Abbreviations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          ABBREVIATIONS_SCREEN_TITLE,
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(ABBREVIATIONS_SCREEN_TITLE),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 100),
        itemCount: 196,
        itemBuilder: (context, index) {
          if (FULL_FORM[index] == "") {
            return Container(
              height: 50,
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                ABBREVIATIONS[index],
                textScaleFactor: 2,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.grey),
              ),
            );
          } else {
            return Container(
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 100, child: Text(ABBREVIATIONS[index])),
                  SizedBox(
                    width: 10,
                  ),
                  Container(width: 200, child: Text(FULL_FORM[index])),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
