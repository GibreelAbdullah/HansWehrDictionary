import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

Future<bool> showAd = prefs.then((value) => value.getBool('showAds') ?? true);

void setShowAds(showAds) {
  prefs.then(
      (sharedPreferences) => sharedPreferences.setBool('showAds', showAds));
}
