import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search/classes/themeModel.dart';
import 'package:search/constants/appConstants.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';

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
        if (_currentScreen != title)
          Navigator.pushReplacementNamed(context, route);
        else
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
          padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
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
                  drawerItem(context, ABOUT_APP_SCREEN_TITLE, '/aboutus',
                      Icons.people),
                  ThemeIcon()
                ],
              ),
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // drawerItem(context, SETTINGS_SCREEN_TITLE, '/settings',
                      //     Icons.settings),
                      // Text("Theme"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
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
