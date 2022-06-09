import 'package:flutter/services.dart';
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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                  DISCLAIMER,
                  textStyle: Theme.of(context).textTheme.bodyText1!,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  ABOUT_APP,
                  textStyle: Theme.of(context).textTheme.bodyText1!,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  WHATS_NEW,
                  textStyle: Theme.of(context).textTheme.bodyText1!,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  COURTSEY,
                  textStyle: Theme.of(context).textTheme.bodyText1!,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  CONTACT_ME,
                  textStyle: Theme.of(context).textTheme.bodyText1!,
                ),
                GestureDetector(
                  child: Text(
                    EMAIL,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: EMAIL),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Email Copied"),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  SOCIAL_PROFILES,
                  textStyle: Theme.of(context).textTheme.bodyText1!,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Image(
                        image: AssetImage('assets/GitHub.png'),
                      ),
                      onTap: () {
                        launchUrl(githubUri,
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(16)),
                    GestureDetector(
                      child: Image(
                        image: AssetImage('assets/linkedin.png'),
                      ),
                      onTap: () {
                        launchUrl(linkedinUri,
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(16)),
                    GestureDetector(
                      child: Image(
                        image: AssetImage('assets/website.png'),
                      ),
                      onTap: () {
                        launchUrl(portfolioUri,
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                  ],
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
