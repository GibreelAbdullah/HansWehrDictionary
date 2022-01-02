import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../serviceLocator.dart';
import '../services/LocalStorageService.dart';
import 'appTheme.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme =
      locator<LocalStorageService>().darkTheme ? darkTheme : lightTheme;

  refreshTheme() {
    currentTheme = locator<LocalStorageService>().darkTheme
        ? darkTheme.copyWith(
            textTheme: ThemeData.dark().textTheme.copyWith(
                  bodyText1: TextStyle(
                    fontFamily: locator<LocalStorageService>().font,
                    fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
                    color: Colors.white,
                  ),
                  bodyText2: TextStyle(
                    fontFamily: locator<LocalStorageService>().font,
                    fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
                    color: hexToColor(
                        locator<LocalStorageService>().highlightTextColor),
                  ),
                  subtitle1: TextStyle(
                    fontFamily: locator<LocalStorageService>().font,
                    fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
                    color: Colors.white,
                  ),
                  headline6: TextStyle(
                    fontFamily: locator<LocalStorageService>().font,
                    fontSize: 20 + locator<LocalStorageService>().fontSizeDelta,
                    color: Colors.white,
                  ),
                ),
            primaryColor:
                hexToColor(locator<LocalStorageService>().highlightTextColor),
            // accentColor:
            //     hexToColor(locator<LocalStorageService>().highlightTextColor),
            canvasColor:
                hexToColor(locator<LocalStorageService>().backgroundColor),
            scaffoldBackgroundColor:
                hexToColor(locator<LocalStorageService>().backgroundColor) ??
                    Colors.grey[900],
            appBarTheme: AppBarTheme(
              color:
                  hexToColor(locator<LocalStorageService>().searchBarColor) ??
                      Colors.grey[850],

              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            dialogBackgroundColor:
                hexToColor(locator<LocalStorageService>().backgroundColor),
          )
        : lightTheme.copyWith(
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                    fontFamily: locator<LocalStorageService>().font,
                    fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
                    color: Colors.black,
                  ),
                  bodyText2: TextStyle(
                    fontFamily: locator<LocalStorageService>().font,
                    fontSize: 16 + locator<LocalStorageService>().fontSizeDelta,
                    color: hexToColor(
                        locator<LocalStorageService>().highlightTextColor),
                  ),
                  subtitle1: TextStyle(
                    color: Colors.black,
                  ),
                  headline6: TextStyle(
                    fontFamily: locator<LocalStorageService>().font,
                    fontSize: 20 + locator<LocalStorageService>().fontSizeDelta,
                    color: Colors.black,
                  ),
                ),
            primaryColor:
                hexToColor(locator<LocalStorageService>().highlightTextColor),
            // accentColor:
            //     hexToColor(locator<LocalStorageService>().highlightTextColor),
            canvasColor:
                hexToColor(locator<LocalStorageService>().backgroundColor),
            scaffoldBackgroundColor:
                hexToColor(locator<LocalStorageService>().backgroundColor) ??
                    Colors.white,
            appBarTheme: AppBarTheme(
              color:
                  hexToColor(locator<LocalStorageService>().searchBarColor) ??
                      Colors.grey[100],
                            systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            brightness: Brightness.light,
            dialogBackgroundColor:
                hexToColor(locator<LocalStorageService>().backgroundColor),
          );
    return notifyListeners();
  }
}
