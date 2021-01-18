import 'package:flutter/material.dart';
import 'package:mopub_flutter/mopub.dart';
import 'package:mopub_flutter/mopub_banner.dart';

class MopubBannerAd extends StatefulWidget {
  @override
  _MopubBannerAdState createState() => _MopubBannerAdState();
}

class _MopubBannerAdState extends State<MopubBannerAd> {
  @override
  void initState() {
    super.initState();
    MoPub.init('f7caf52f9a6142618f43bc34e5a3f031', testMode: true);
  }

  @override
  Widget build(BuildContext context) {
    return MoPubBannerAd(
      adUnitId: 'f7caf52f9a6142618f43bc34e5a3f031',
      bannerSize: BannerSize.STANDARD,
      keepAlive: true,
      listener: (result, dynamic) {
        print('BANNER _ $result');
      },
    );
  }
}

// void displayMopubBanner() {
//   try {
//     MoPub.init('f7caf52f9a6142618f43bc34e5a3f031', testMode: true).then((_) => {
//           _loadBannerAd(),
//         });
//   } catch (e) {
//     print('exception: ${e.toString()}');
//   }
// }

// void _loadBannerAd() {
//   MoPubBannerAd(
//     adUnitId: 'ad_unit_id',
//     bannerSize: BannerSize.STANDARD,
//     keepAlive: true,
//     listener: (result, dynamic) {
//       print('$result');
//     },
//   );
// }
