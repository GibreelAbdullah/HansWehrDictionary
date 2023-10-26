import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../constants/app_constants.dart';

class Abbreviations extends StatelessWidget {
  const Abbreviations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          abbreviationsScreenTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: const CommonDrawer(currentScreen: abbreviationsScreenTitle),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        itemCount: abbreviations.length,
        itemBuilder: (context, index) {
          if (fullForm[index] == "") {
            return Text(
              abbreviations[index],
              textScaleFactor: 2,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.grey,
                  ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25,
                  child: Text(abbreviations[index],
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: Text(fullForm[index],
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
