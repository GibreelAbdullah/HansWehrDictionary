import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
final Future<bool> adsFlag =
    prefs.then((value) => value.getBool('adsFlag') ?? true);
Future<bool> showAd = adsFlag;
void setShowAds(adsFlag) {
  prefs.then(
      (sharedPreferences) => sharedPreferences.setBool('adsFlag', adsFlag));
}
