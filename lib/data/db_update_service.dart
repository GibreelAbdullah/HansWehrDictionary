import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import 'database_helper_native.dart' if (dart.library.html) 'database_helper_web.dart' as platform;

const _manifestUrl =
    'https://raw.githubusercontent.com/GibreelAbdullah/HansWehrDictionary/refs/heads/master/db_version.json';

class DbUpdateInfo {
  final int remoteVersion;
  final String downloadUrl;
  const DbUpdateInfo({required this.remoteVersion, required this.downloadUrl});
}

/// Returns update info if a newer DB is available, null otherwise.
Future<DbUpdateInfo?> checkForDbUpdate() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final localVersion = prefs.getInt('db_version') ?? 0;
    final response = await http.get(Uri.parse(_manifestUrl));
    if (response.statusCode != 200) return null;
    final manifest = jsonDecode(response.body) as Map<String, dynamic>;
    final remoteVersion = manifest['version'] as int;
    final url = manifest['url'] as String;
    if (remoteVersion > localVersion) {
      return DbUpdateInfo(remoteVersion: remoteVersion, downloadUrl: url);
    }
    return null;
  } catch (_) {
    return null;
  }
}

/// Downloads the new DB and replaces the local cache.
Future<void> applyDbUpdate(DbUpdateInfo info) async {
  await platform.downloadAndReplaceDb(info.downloadUrl, info.remoteVersion);
  DatabaseHelper.invalidate();
}
