// import '../service_locator.dart';
// import 'local_storage_service.dart';
// import 'package:in_app_review/in_app_review.dart';

// void appReview() async {
//   if (locator<LocalStorageService>().appUsage > 15) {
//     final InAppReview inAppReview = InAppReview.instance;
//     if (await inAppReview.isAvailable()) {
//       inAppReview.requestReview();
//     }
//   } else {
//     locator<LocalStorageService>().appUsage++;
//   }
// }
