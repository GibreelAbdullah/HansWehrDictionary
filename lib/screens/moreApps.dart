import 'package:flutter/material.dart';
import '../constants/appConstants.dart';
import '../widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          ALL_MY_APPS,
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(currentScreen: ALL_MY_APPS),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(8)),
          ListTile(
            title: Text(
              'Hans Wehr Dictionary',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            leading: Image.asset("assets/hans.png", fit: BoxFit.cover),
            subtitle: Text(
              'A concise Arabic English dictionary',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              launchUrl(hansWehrAndroidUri,
                  mode: LaunchMode.externalApplication);
            },
          ),
          Padding(padding: EdgeInsets.all(8)),
          ListTile(
            title: Text(
              'Lane\'s Lexicon',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            leading: Image.asset("assets/lane.png", fit: BoxFit.cover),
            subtitle: Text(
              'A comprehensive Arabic English dictionary',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              launchUrl(lanesLexiconAndroidUri,
                  mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }
}
