import 'dart:async';

import 'package:search/components/drawer.dart';
import 'package:search/constants/appConstants.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          SETTINGS_SCREEN_TITLE,
          // style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      drawer: CommonDrawer(SETTINGS_SCREEN_TITLE),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
