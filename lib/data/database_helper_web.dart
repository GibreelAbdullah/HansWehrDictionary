import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common/sqflite.dart';

const _dbAssetUrl = 'assets/assets/hanswehr.sqlite';

Future<Database> initDatabase(int dbVersion) async {
  const path = 'hanswehr.sqlite';
  final prefs = await SharedPreferences.getInstance();
  final currentVersion = prefs.getInt('db_version') ?? 0;

  if (currentVersion >= dbVersion) {
    // DB already exists in IndexedDB with correct version, just open it.
    try {
      return await openDatabase(path, readOnly: true);
    } catch (_) {
      // If open fails, fall through to re-download.
    }
  }

  try {
    await deleteDatabase(path);
  } catch (_) {}

  final response = await http.get(Uri.parse(_dbAssetUrl));
  final Uint8List bytes = response.bodyBytes;

  await databaseFactory.writeDatabaseBytes(path, bytes);
  await prefs.setInt('db_version', dbVersion);
  return openDatabase(path, readOnly: true);
}

Future<void> downloadAndReplaceDb(String url, int newVersion) async {
  // No-op on web — DB is always fresh from deployed assets.
}
