import 'dart:async';

import 'package:provider/provider.dart';
import 'package:search/classes/appTheme.dart';
import 'package:search/classes/themeModel.dart';
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
      drawer: CommonDrawer(currentScreen: SETTINGS_SCREEN_TITLE),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            ThemeIcon(),
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
                              setState(
                                () {
                                  locator<LocalStorageService>()
                                          .highlightTextColor =
                                      _tempColor.value.toString();
                                },
                              );
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
    return ListTile(
      title: Text("Theme"),
      trailing: IconButton(
        icon: Icon(
          themeIcon,
          color: Colors.yellow[800],
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
      ),
    );
  }
}
