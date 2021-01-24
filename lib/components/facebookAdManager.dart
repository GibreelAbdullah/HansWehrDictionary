import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

class FacebookAdManager extends StatefulWidget {
  @override
  _FacebookAdManagerState createState() => _FacebookAdManagerState();
}

class _FacebookAdManagerState extends State<FacebookAdManager> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FacebookAudienceNetwork.init(
        testingId: "06b82565-32ef-47bb-a063-65b64d25dcb3");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0.5, 1),
      child: FacebookBannerAd(
        placementId: Platform.isAndroid
            ? "118200316819287_118202133485772"
            : "YOUR_IOS_PLACEMENT_ID",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          switch (result) {
            case BannerAdResult.ERROR:
              print("Error: $value");
              break;
            case BannerAdResult.LOADED:
              print("Loaded: $value");
              break;
            case BannerAdResult.CLICKED:
              print("Clicked: $value");
              break;
            case BannerAdResult.LOGGING_IMPRESSION:
              print("Logging Impression: $value");
              break;
          }
        },
      ),
    );
  }
}
