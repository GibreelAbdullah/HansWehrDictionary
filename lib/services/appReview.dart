// import 'package:search/serviceLocator.dart';
// import 'package:search/services/LocalStorageService.dart';
// import 'package:in_app_review/in_app_review.dart';

// void appReview() async {
//   if (locator<LocalStorageService>().appUsage > 5) {
//     final InAppReview inAppReview = InAppReview.instance;
//     if (await inAppReview.isAvailable()) {
//       inAppReview.requestReview();
//     }
//   } else
//     locator<LocalStorageService>().appUsage++;
// }
