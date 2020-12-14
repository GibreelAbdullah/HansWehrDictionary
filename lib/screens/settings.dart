import 'dart:async';

import 'package:search/components/drawer.dart';
import 'package:search/components/adManager.dart';

import 'package:search/constants/appConstants.dart';
import 'package:search/constants/preferences.dart';

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
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      drawer: CommonDrawer(SETTINGS_SCREEN_TITLE),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            FutureBuilder(
              future: showAd,
              builder: (context, snapshot) {
                return SwitchListTile(
                  title: const Text('Ads'),
                  subtitle: const Text('Disable for Free'),
                  activeColor: Colors.green[200],
                  value: snapshot.data ?? true, //Expected behaviour of future builder, returns data twice
                  onChanged: (val) {
                    setState(
                      () {
                        if (val) {
                          displayBanner();
                        } else {
                          hideBanner();
                        }
                        setShowAds(val);
                        showAd = Future<bool>.value(val);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
