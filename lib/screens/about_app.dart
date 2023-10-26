import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/drawer.dart';
import '../constants/app_constants.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          aboutAppScreenTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: const CommonDrawer(currentScreen: aboutAppScreenTitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  disclaimer,
                  textStyle: Theme.of(context).textTheme.bodyLarge!,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  aboutApp,
                  textStyle: Theme.of(context).textTheme.bodyLarge!,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  whatsNew,
                  textStyle: Theme.of(context).textTheme.bodyLarge!,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  courtsey,
                  textStyle: Theme.of(context).textTheme.bodyLarge!,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  contactMe,
                  textStyle: Theme.of(context).textTheme.bodyLarge!,
                ),
                GestureDetector(
                  child: Text(
                    email,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onTap: () {
                    Clipboard.setData(
                      const ClipboardData(text: email),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Email Copied"),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                HtmlWidget(
                  socialProfiles,
                  textStyle: Theme.of(context).textTheme.bodyLarge!,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: const Image(
                        image: AssetImage('assets/GitHub.png'),
                      ),
                      onTap: () {
                        launchUrl(githubUri,
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(16)),
                    GestureDetector(
                      child: const Image(
                        image: AssetImage('assets/linkedin.png'),
                      ),
                      onTap: () {
                        launchUrl(linkedinUri,
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(16)),
                    GestureDetector(
                      child: const Image(
                        image: AssetImage('assets/website.png'),
                      ),
                      onTap: () {
                        launchUrl(portfolioUri,
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
              ]),
        ),
      ),
    );
  }
}
