import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5691554351241481~7554963330";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~2594085930";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5691554351241481/3891050491";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4339318960";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

BannerAd _bannerAd = BannerAd(
  adUnitId: AdManager.bannerAdUnitId,
  size: AdSize.fullBanner,
);


bool showAds = true;

BannerAd _createBanner() {
  return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) if (!showAds)
          _bannerAd.dispose();
        else
          _bannerAd.show(anchorType: AnchorType.bottom);
      });
}

void displayBanner() async {
  showAds = true;
  if (_bannerAd == null) _bannerAd = _createBanner();
  _bannerAd
    ..load()
    ..show(anchorType: AnchorType.bottom);
}

void hideBanner() async {
  await _bannerAd?.dispose();
  showAds = false;
  _bannerAd = null;
}
