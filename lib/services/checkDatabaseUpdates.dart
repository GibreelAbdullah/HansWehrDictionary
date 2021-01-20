import 'dart:convert';
import 'dart:io';

import 'package:search/constants/appConstants.dart';

void checkDatabaseUpdates() async {
  Map<String, dynamic> versionDetails = await databaseObject.dbVersionDetails();
  int version = versionDetails["DB_VERSION"];
  DateTime lastChecked = DateTime.parse(versionDetails["LAST_CHECKED"]);
  if (DateTime.now().difference(lastChecked).inDays < 1) {
    return;
  }
  int i = 1;
  bool fileAvailable = true;
  while (fileAvailable) {
    try {
      var request = await HttpClient().getUrl(Uri.parse(
          'https://raw.githubusercontent.com/MuslimTechNet/HansWehrDictionary/master/${version + i++}.txt'));
      var response = await request.close();

      await for (String contents in response.transform(Utf8Decoder())) {
        if (contents == '404: Not Found') {
          databaseObject.applyUpdates(
              "UPDATE DATABASE_VERSION SET LAST_CHECKED = '${DateTime.now().toString()}';");
          fileAvailable = false;
        } else {
          contents = contents +
              "UPDATE DATABASE_VERSION SET DB_VERSION = ${version + i - 1} AND LAST_CHECKED = '${DateTime.now().toString()}';";
          databaseObject.applyUpdates(contents);
        }
      }
    } on Exception catch (_) {
      databaseObject.applyUpdates(
          "UPDATE DATABASE_VERSION SET LAST_CHECKED = '${DateTime.now().toString()}';");
      fileAvailable = false;
      return;
    }
  }
}
