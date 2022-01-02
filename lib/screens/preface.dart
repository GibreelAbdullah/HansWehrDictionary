import 'package:flutter/material.dart';
import 'package:hans_wehr_dictionary/constants/appConstants.dart';
import 'package:hans_wehr_dictionary/widgets/drawer.dart';

class Preface extends StatelessWidget {
  const Preface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          PREFACE_SCREEN_TITLE,
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(currentScreen: PREFACE_SCREEN_TITLE),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'PREFACE',
                textScaleFactor: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(PREFACE_TEXT, style: Theme.of(context).textTheme.bodyText1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ithaca, New York\nNovember 1960',
                      style: Theme.of(context).textTheme.bodyText1),
                  Text('J MILTON COWAN',
                      style: Theme.of(context).textTheme.bodyText1)
                ],
              ),
              Padding(padding: EdgeInsets.all(16)),
              Text(
                'PREFACE\n TO THE POCKET-BOOK EDITION',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(PREFACE_POCKET_TEXT,
                  style: Theme.of(context).textTheme.bodyText1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Münster\nIthaca, New York\nFebruary 1976',
                      style: Theme.of(context).textTheme.bodyText1),
                  Text('HANS WEHR\nJ MILTON COWAN',
                      style: Theme.of(context).textTheme.bodyText1)
                ],
              ),
              Padding(padding: EdgeInsets.all(16)),
              Text(
                'INTRODUCTION',
                textScaleFactor: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(INTRODUCTION_TEXT,
                  style: Theme.of(context).textTheme.bodyText1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Münster\nNovember 1960',
                      style: Theme.of(context).textTheme.bodyText1),
                  Text('HANS WEHR',
                      style: Theme.of(context).textTheme.bodyText1)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
