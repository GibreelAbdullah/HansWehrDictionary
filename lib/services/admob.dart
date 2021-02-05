import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:search/properties.dart';

class AdManager {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return ADMOB_BANNER_ID;
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4339318960";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

void displayBanner() async {
  BannerAd(
    adUnitId: AdManager.bannerAdUnitId,
    size: AdSize.fullBanner,
  )
    ..load()
    ..show(anchorType: AnchorType.bottom);
}
