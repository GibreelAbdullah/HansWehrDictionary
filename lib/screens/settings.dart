import 'dart:async';

import 'package:search/classes/appTheme.dart';
import 'package:search/widgets/drawer.dart';
import 'package:search/constants/appConstants.dart';

import 'package:flutter/material.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  Color _tempColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          SETTINGS_SCREEN_TITLE,
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(SETTINGS_SCREEN_TITLE),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text("Highlight Text Color"),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        content: SingleChildScrollView(
                          child: MaterialPicker(
                            pickerColor: hexToColor(
                                    locator<LocalStorageService>()
                                        .highlightTextColor) ??
                                Colors.blue,
                            onColorChanged: (color) =>
                                setState(() => _tempColor = color),
                            enableLabel: true,
                          ),
                        ),
                        actions: [
                          FlatButton(
                            child: Text('CANCEL'),
                            onPressed: Navigator.of(context).pop,
                          ),
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() => locator<LocalStorageService>()
                                      .highlightTextColor =
                                  _tempColor.value.toString());
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.circle,
                  size: 36,
                ),
                color: hexToColor(
                    locator<LocalStorageService>().highlightTextColor),
              ),
            ),
            ListTile(
              title: Text("Highlight Tile Color"),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        content: SingleChildScrollView(
                          child: MaterialPicker(
                            pickerColor: hexToColor(
                                    locator<LocalStorageService>()
                                        .highlightTileColor) ??
                                Colors.blue,
                            onColorChanged: (color) =>
                                setState(() => _tempColor = color),
                            enableLabel: true,
                          ),
                        ),
                        actions: [
                          FlatButton(
                            child: Text('CANCEL'),
                            onPressed: Navigator.of(context).pop,
                          ),
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() => locator<LocalStorageService>()
                                      .highlightTileColor =
                                  _tempColor.value.toString());
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.circle,
                  size: 36,
                ),
                color: hexToColor(
                    locator<LocalStorageService>().highlightTileColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
