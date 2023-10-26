import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../widgets/drawer.dart';

class Preface extends StatelessWidget {
  const Preface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          prefaceScreenTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: const CommonDrawer(currentScreen: prefaceScreenTitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'PREFACE',
                textScaleFactor: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(prefaceText, style: Theme.of(context).textTheme.bodyLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ithaca, New York\nNovember 1960',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('J MILTON COWAN',
                      style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
              const Padding(padding: EdgeInsets.all(16)),
              Text(
                'PREFACE\n TO THE POCKET-BOOK EDITION',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(prefacePocketText,
                  style: Theme.of(context).textTheme.bodyLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Münster\nIthaca, New York\nFebruary 1976',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('HANS WEHR\nJ MILTON COWAN',
                      style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
              const Padding(padding: EdgeInsets.all(16)),
              Text(
                'INTRODUCTION',
                textScaleFactor: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(introText, style: Theme.of(context).textTheme.bodyLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Münster\nNovember 1960',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('HANS WEHR',
                      style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
