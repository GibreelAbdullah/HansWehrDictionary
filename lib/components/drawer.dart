import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search/classes/themeModel.dart';
import 'package:search/constants/appConstants.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

// ignore: must_be_immutable
class CommonDrawer extends StatelessWidget {
  String _currentScreen;

  CommonDrawer(String title) {
    _currentScreen = title;
  }

  FlatButton drawerItem(
      BuildContext context, String title, String route, IconData icon) {
    return FlatButton(
      onPressed: () {
        if (_currentScreen != title) {
          if (_currentScreen == SEARCH_SCREEN_TITLE) {
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
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(title)
        ],
      ),
    );
  }

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
                  drawerItem(
                    context,
                    SEARCH_SCREEN_TITLE,
                    '/search',
                    Icons.search,
                  ),
                  drawerItem(
                    context,
                    BROWSE_SCREEN_TITLE,
                    '/browse',
                    Icons.list,
                  ),
                  drawerItem(
                    context,
                    ABBREVIATIONS_SCREEN_TITLE,
                    '/abbreviations',
                    Icons.info,
                  ),
                  drawerItem(context, ABOUT_APP_SCREEN_TITLE, '/aboutus',
                      Icons.people),
                  ThemeIcon(),
                  rateUs(),
                ],
              ),
              Column(
                children: [
                  Divider(),
                  drawerItem(context, SETTINGS_SCREEN_TITLE, '/settings',
                      Icons.settings),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Row rateUs() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: FlatButton(
          child: Row(
            children: [
              Icon(
                Icons.star,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Rate Us"),
            ],
          ),
          onPressed: () {
            launch(PLAY_STORE_LINK);
          },
        ),
      ),
      FlatButton(
        child: Icon(Icons.share),
        onPressed: () {
          Share.share(
              'Check out this Hans Wehr Dictionary App : ' + PLAY_STORE_LINK);
        },
      ),
    ],
  );
}

class ThemeIcon extends StatefulWidget {
  @override
  _ThemeIconState createState() => _ThemeIconState();
}

class _ThemeIconState extends State<ThemeIcon> {
  IconData themeIcon = locator<LocalStorageService>().darkTheme
      ? Icons.wb_sunny
      : Icons.nights_stay_outlined;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        children: [
          Icon(
            themeIcon,
            color: Colors.yellow[800],
          ),
          SizedBox(
            width: 10,
          ),
          Text("Theme"),
        ],
      ),
      onPressed: () {
        setState(() {
          if (locator<LocalStorageService>().darkTheme) {
            locator<LocalStorageService>().darkTheme = false;
            themeIcon = Icons.nights_stay_outlined;
          } else {
            locator<LocalStorageService>().darkTheme = true;
            themeIcon = Icons.wb_sunny;
          }
          Provider.of<ThemeModel>(context, listen: false).toggleTheme();
        });
      },
    );
  }
}
