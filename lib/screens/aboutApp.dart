import 'dart:math';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/drawer.dart';
import '../constants/appConstants.dart';


class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          ABOUT_APP_SCREEN_TITLE,
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(currentScreen: ABOUT_APP_SCREEN_TITLE),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  ABOUT_APP,
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  WHATS_NEW,
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(
                      COMMUNITY_INVITE,
                      textStyle: Theme.of(context).textTheme.bodyText1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Image.asset("assets/discord.png",
                              width: min(
                                  MediaQuery.of(context).size.width * 0.35,
                                  220),
                              height: min(
                                  MediaQuery.of(context).size.width * 0.105,
                                  70),
                              fit: BoxFit.cover),
                          onTap: () => _launchURL(DISCORD_INVITE_LINK),
                        ),
                        InkWell(
                          child: Image.asset("assets/reddit.png",
                              width: min(
                                  MediaQuery.of(context).size.width * 0.35,
                                  220),
                              height: min(
                                  MediaQuery.of(context).size.width * 0.105,
                                  70),
                              fit: BoxFit.cover),
                          onTap: () => _launchURL(REDDIT_INVITE_LINK),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  DISCLAIMER,
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
              ]),
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
