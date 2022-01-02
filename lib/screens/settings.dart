import 'dart:async';

import 'package:provider/provider.dart';
import '../classes/appTheme.dart';
import '../classes/themeModel.dart';
import '../widgets/drawer.dart';
import '../constants/appConstants.dart';

import 'package:flutter/material.dart';
import '../serviceLocator.dart';
import '../services/LocalStorageService.dart';
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
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(currentScreen: SETTINGS_SCREEN_TITLE),
      body: Container(
        child: Column(
          children: [
            FontSelector(),
            FontSizeModifier(),
            ThemeIcon(),
            ExpansionTile(
              tilePadding: EdgeInsets.fromLTRB(16, 0, 28, 0),
              title: Text(
                'Advanced Theming Options',
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
                  fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                ),
              ),
              childrenPadding: EdgeInsets.symmetric(horizontal: 16),
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

class FontSelector extends StatefulWidget {
  @override
  _FontSelectorState createState() => _FontSelectorState();
}

class _FontSelectorState extends State<FontSelector> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Font',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      contentPadding: EdgeInsets.fromLTRB(16, 0, 28, 0),
      trailing: DropdownButton(
        value: locator<LocalStorageService>().font,
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 24,
        elevation: 16,
        // style: TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          // color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            locator<LocalStorageService>().font = newValue;
          });
          Provider.of<ThemeModel>(context, listen: false).refreshTheme();
        },
        items:
            ['Amiri', 'Roboto'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class FontSizeModifier extends StatefulWidget {
  @override
  _FontSizeModifierState createState() => _FontSizeModifierState();
}

class _FontSizeModifierState extends State<FontSizeModifier> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Font Size',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width * .3,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .1,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(
                      () {
                        if (locator<LocalStorageService>().fontSizeDelta > -9) {
                          locator<LocalStorageService>().fontSizeDelta--;
                          Provider.of<ThemeModel>(context, listen: false)
                              .refreshTheme();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .1,
              child: Center(
                child: Text(
                  '${locator<LocalStorageService>().fontSizeDelta + 10}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .1,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(
                      () {
                        if (locator<LocalStorageService>().fontSizeDelta < 15) {
                          locator<LocalStorageService>().fontSizeDelta++;
                          Provider.of<ThemeModel>(context, listen: false)
                              .refreshTheme();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorMod extends StatefulWidget {
  final String? title;

  const ColorMod({
    Key? key,
    this.title,
  }) : super(key: key);
  @override
  _ColorModState createState() => _ColorModState();
}

class _ColorModState extends State<ColorMod> {
  Color _tempColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    Color? property;
    switch (widget.title) {
      case 'Highlight Text Color':
        property =
            hexToColor(locator<LocalStorageService>().highlightTextColor);
        property ??= locator<LocalStorageService>().darkTheme
            ? Colors.tealAccent[200]
            : lightTheme.primaryColor;
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
      title: Text(
        widget.title!,
        style: Theme.of(context).textTheme.bodyText1,
      ),
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
                                  ? Colors.tealAccent[200]!.value.toString()
                                  : lightTheme.primaryColor.value.toString();
                          break;
                        case 'Highlight Tile Color':
                          locator<LocalStorageService>().highlightTileColor =
                              locator<LocalStorageService>().darkTheme
                                  ? Colors.grey[900]!.value.toString()
                                  : Colors.white.value.toString();
                          break;
                        case 'Background Color':
                          locator<LocalStorageService>().backgroundColor =
                              locator<LocalStorageService>().darkTheme
                                  ? Colors.grey[900]!.value.toString()
                                  : Colors.white.value.toString();

                          break;
                        case 'Search Bar Color':
                          locator<LocalStorageService>().searchBarColor =
                              locator<LocalStorageService>().darkTheme
                                  ? Colors.grey[850]!.value.toString()
                                  : Colors.grey[100]!.value.toString();
                          break;
                        default:
                      }
                      Provider.of<ThemeModel>(context, listen: false)
                          .refreshTheme();
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
                        TextButton(
                          child: Text(
                            'CANCEL',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          onPressed: Navigator.of(context).pop,
                        ),
                        TextButton(
                          child: Text(
                            'OK',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
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
                                    .refreshTheme();
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
      title: Text(
        "Theme",
        style: Theme.of(context).textTheme.bodyText1,
      ),
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
                    Colors.grey[900]!.value.toString();
                locator<LocalStorageService>().searchBarColor =
                    Colors.grey[900]!.value.toString();
                themeIcon = Icons.wb_sunny;
              }
              Provider.of<ThemeModel>(context, listen: false).refreshTheme();
            },
          );
        },
      ),
    );
  }
}
