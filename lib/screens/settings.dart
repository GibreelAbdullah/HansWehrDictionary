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
            ExpansionTile(
              title: Text('Advanced Theming Options'),
              children: [
                ColorMod(
                  title: "Highlight Text Color",
                ),
                ColorMod(
                  title: "Highlight Tile Color",
                ),
                ColorMod(
                  title: "Background Color",
                ),
                ColorMod(
                  title: "Search Bar Color",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColorMod extends StatefulWidget {
  final String title;

  const ColorMod({
    Key key,
    this.title,
  }) : super(key: key);
  @override
  _ColorModState createState() => _ColorModState();
}

class _ColorModState extends State<ColorMod> {
  Color _tempColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    Color property;
    switch (widget.title) {
      case 'Highlight Text Color':
        property =
            hexToColor(locator<LocalStorageService>().highlightTextColor);
        property ??= locator<LocalStorageService>().darkTheme
            ? Colors.tealAccent[200]
            : lightTheme.accentColor;
        break;
      case 'Highlight Tile Color':
        property =
            hexToColor(locator<LocalStorageService>().highlightTileColor);
        property ??= locator<LocalStorageService>().darkTheme
            ? Colors.grey[900]
            : Colors.white;
        break;
      case 'Background Color':
        property = hexToColor(locator<LocalStorageService>().backgroundColor);
        property ??= locator<LocalStorageService>().darkTheme
            ? Colors.grey[900]
            : Colors.white;
        break;
      case 'Search Bar Color':
        property = hexToColor(locator<LocalStorageService>().searchBarColor);
        property ??= locator<LocalStorageService>().darkTheme
            ? Colors.grey[900]
            : Colors.white;
        break;
      default:
    }

    return ListTile(
      title: Text(widget.title),
      trailing: Container(
        width: 84,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            property == null
                ? Container()
                : IconButton(
                    icon: Icon(Icons.restore),
                    onPressed: () {
                      switch (widget.title) {
                        case 'Highlight Text Color':
                          locator<LocalStorageService>().highlightTextColor =
                              locator<LocalStorageService>().darkTheme
                                  ? Colors.tealAccent[200].value.toString()
                                  : lightTheme.accentColor.value.toString();
                          break;
                        case 'Highlight Tile Color':
                          locator<LocalStorageService>().highlightTileColor =
                              locator<LocalStorageService>().darkTheme
                                  ? Colors.grey[900].value.toString()
                                  : Colors.white.value.toString();
                          break;
                        case 'Background Color':
                          locator<LocalStorageService>().backgroundColor =
                              locator<LocalStorageService>().darkTheme
                                  ? Colors.grey[900].value.toString()
                                  : Colors.white.value.toString();

                          break;
                        case 'Search Bar Color':
                          locator<LocalStorageService>().searchBarColor =
                              locator<LocalStorageService>().darkTheme
                                  ? Colors.grey[850].value.toString()
                                  : Colors.grey[100].value.toString();
                          break;
                        default:
                      }
                      Provider.of<ThemeModel>(context, listen: false)
                          .refreshColors();
                      setState(
                        () {
                          property = null;
                        },
                      );
                    },
                  ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: property ?? Colors.blue,
                          onColorChanged: (color) {
                            setState(() => _tempColor = color);
                          },
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
                            switch (widget.title) {
                              case 'Highlight Text Color':
                                locator<LocalStorageService>()
                                        .highlightTextColor =
                                    _tempColor.value.toString();
                                break;
                              case 'Highlight Tile Color':
                                locator<LocalStorageService>()
                                        .highlightTileColor =
                                    _tempColor.value.toString();
                                break;
                              case 'Background Color':
                                locator<LocalStorageService>().backgroundColor =
                                    _tempColor.value.toString();
                                break;
                              case 'Search Bar Color':
                                locator<LocalStorageService>().searchBarColor =
                                    _tempColor.value.toString();
                                break;
                              default:
                            }
                            setState(
                              () {
                                property = _tempColor;
                                Provider.of<ThemeModel>(context, listen: false)
                                    .refreshColors();
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: property != null
                  ? Container(
                      width: 36,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: property,
                          border: Border.all(color: Colors.grey)),
                    )
                  : Icon(
                      Icons.error,
                      size: 36,
                    ),
            ),
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
          setState(
            () {
              if (locator<LocalStorageService>().darkTheme) {
                locator<LocalStorageService>().darkTheme = false;
                locator<LocalStorageService>().backgroundColor =
                    Colors.white.value.toString();
                locator<LocalStorageService>().searchBarColor =
                    Colors.white.value.toString();
                themeIcon = Icons.nights_stay_outlined;
              } else {
                locator<LocalStorageService>().darkTheme = true;
                locator<LocalStorageService>().backgroundColor =
                    Colors.grey[900].value.toString();
                locator<LocalStorageService>().searchBarColor =
                    Colors.grey[900].value.toString();
                themeIcon = Icons.wb_sunny;
              }
              Provider.of<ThemeModel>(context, listen: false).refreshColors();
            },
          );
        },
      ),
    );
  }
}
