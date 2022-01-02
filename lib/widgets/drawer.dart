import 'package:flutter/material.dart';
import '../constants/appConstants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class CommonDrawer extends StatelessWidget {
  final String currentScreen;

  const CommonDrawer({required this.currentScreen});

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 65),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerItem(
                    currentScreen: currentScreen,
                    title: SEARCH_SCREEN_TITLE,
                    route: '/search',
                    icon: Icons.search,
                  ),
                  DrawerItem(
                    currentScreen: currentScreen,
                    title: BROWSE_SCREEN_TITLE,
                    route: '/browse',
                    icon: Icons.list,
                  ),
                  DrawerItem(
                    currentScreen: currentScreen,
                    title: ABBREVIATIONS_SCREEN_TITLE,
                    route: '/abbreviations',
                    icon: Icons.info,
                  ),
                  VerbForms(),
                ],
              ),
              Column(
                children: [
                  Divider(),
                  // DrawerItem(
                  //     currentScreen: currentScreen,
                  //     title: MORE_APPS,
                  //     route: '/moreapps',
                  //     icon: Icons.more_horiz),
                  // DrawerItem(
                  //     currentScreen: currentScreen,
                  //     title: DONATE_SCREEN_TITLE,
                  //     route: '/donate',
                  //     icon: Icons.payment),
                  DrawerItem(
                      currentScreen: currentScreen,
                      title: SETTINGS_SCREEN_TITLE,
                      route: '/settings',
                      icon: Icons.settings),
                  // DrawerItem(
                  //     currentScreen: currentScreen,
                  //     title: ABOUT_APP_SCREEN_TITLE,
                  //     route: '/aboutus',
                  //     icon: Icons.people),
                  // RateUs(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RateUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Theme.of(context).iconTheme.color,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Rate Us",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            onPressed: () {
              launch(HANS_WEHR_ANDROID_LINK);
            },
          ),
        ),
        TextButton(
          child: Icon(
            Icons.share,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Share.share('Check out this Hans Wehr Dictionary App : ' +
                HANS_WEHR_ANDROID_LINK);
          },
        ),
      ],
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String currentScreen;
  final String title;
  final String route;
  final IconData icon;
  DrawerItem({
    required this.currentScreen,
    required this.title,
    required this.route,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (currentScreen != title) {
          if (currentScreen == SEARCH_SCREEN_TITLE) {
            Navigator.pop(context);
            Navigator.pushNamed(context, route);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
          }
        } else
          Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}

class VerbForms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                'VERB FORMS',
                style: Theme.of(context).textTheme.bodyText1,
              )),
              titlePadding: const EdgeInsets.all(8.0),
              contentPadding: const EdgeInsets.all(0.0),
              content: Container(
                height: MediaQuery.of(context).size.height * .7,
                width: MediaQuery.of(context).size.width * .9,
                child: ListView.builder(
                  itemCount: VERB_FORMS.length,
                  itemBuilder: (_, i) {
                    return ExpansionTile(
                      childrenPadding: EdgeInsets.fromLTRB(30, 0, 16, 0),
                      title: Text(
                        VERB_FORMS[i],
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1!.fontFamily,
                          fontSize:
                              Theme.of(context).textTheme.bodyText1!.fontSize,
                        ),
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.topLeft,
                      children: [
                        Container(
                          child: Text(
                            'Pattern Meaning : ' + VERB_FORM_DESCRIPTIONS[i],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Container(
                          child: Text(
                            'Eg. : ' + VERB_FORM_EXAMPLES[i],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'DISMISS',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onPressed: Navigator.of(context).pop,
                ),
              ],
            );
          },
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: Theme.of(context).iconTheme.color,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Verb Forms',
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
