import 'package:flutter/material.dart';
import '../constants/appConstants.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // drawerItem(context, HOME_SCREEN_TITLE, '/home', Icons.home),
                drawerItem(
                  context,
                  SEARCH_SCREEN_TITLE,
                  '/search',
                  Icons.search,
                ),
              ],
            ),
            Column(
              children: [
                Divider(),
                drawerItem(
                    context, ABOUT_APP_SCREEN_TITLE, '/aboutus', Icons.people),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
