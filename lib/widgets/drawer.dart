import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class CommonDrawer extends StatelessWidget {
  final String currentScreen;

  const CommonDrawer({Key? key, required this.currentScreen}) : super(key: key);

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 65),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerItem(
                    currentScreen: currentScreen,
                    title: searchScreenTitle,
                    route: '/search',
                    icon: Icons.search,
                  ),
                  DrawerItem(
                    currentScreen: currentScreen,
                    title: browseScreenTitle,
                    route: '/browse',
                    icon: Icons.list,
                  ),
                  DrawerItem(
                      currentScreen: currentScreen,
                      title: prefaceScreenTitle,
                      route: '/preface',
                      icon: Icons.article),
                  DrawerItem(
                    currentScreen: currentScreen,
                    title: abbreviationsScreenTitle,
                    route: '/abbreviations',
                    icon: Icons.info,
                  ),
                  const VerbForms(),
                ],
              ),
              Column(
                children: [
                  const Divider(),
                  DrawerItem(
                      currentScreen: currentScreen,
                      title: moreApps,
                      route: '/moreapps',
                      icon: Icons.more_horiz),
                  DrawerItem(
                      currentScreen: currentScreen,
                      title: settingsScreenTitle,
                      route: '/settings',
                      icon: Icons.settings),
                  DrawerItem(
                      currentScreen: currentScreen,
                      title: aboutAppScreenTitle,
                      route: '/aboutus',
                      icon: Icons.people),
                  const RateUs(),
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
  const RateUs({Key? key}) : super(key: key);

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
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Rate Us",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            onPressed: () {
              launchUrl(hansWehrAndroidUri,
                  mode: LaunchMode.externalApplication);
            },
          ),
        ),
        TextButton(
          child: Icon(
            Icons.share,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Share.share(
                'Check out this Hans Wehr Dictionary App : $hansWehrAndroidUri');
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
  const DrawerItem({
    Key? key,
    required this.currentScreen,
    required this.title,
    required this.route,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (currentScreen != title) {
          if (currentScreen == searchScreenTitle) {
            Navigator.pop(context);
            Navigator.pushNamed(context, route);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
          }
        } else {
          Navigator.pop(context);
        }
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}

class VerbForms extends StatelessWidget {
  const VerbForms({Key? key}) : super(key: key);

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
                style: Theme.of(context).textTheme.bodyLarge,
              )),
              titlePadding: const EdgeInsets.all(8.0),
              contentPadding: const EdgeInsets.all(0.0),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * .7,
                width: MediaQuery.of(context).size.width * .9,
                child: ListView.builder(
                  itemCount: verbForms.length,
                  itemBuilder: (_, i) {
                    return ExpansionTile(
                      iconColor: Theme.of(context).textTheme.bodyMedium!.color,
                      textColor: Theme.of(context).textTheme.bodyMedium!.color,
                      childrenPadding: const EdgeInsets.fromLTRB(30, 0, 16, 0),
                      title: Text(
                        verbForms[i],
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodyLarge!.fontFamily,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.topLeft,
                      children: [
                        Text(
                          'Pattern Meaning : ${verbFormDesc[i]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Eg. : ${verbFormExample[i]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(
                    'DISMISS',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
          const SizedBox(
            width: 10,
          ),
          Text(
            'Verb Forms',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}
