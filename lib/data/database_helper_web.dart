import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common/sqflite.dart';

const _dbAssetUrl = 'assets/hanswehr.sqlite';

Future<Database> initDatabase(int dbVersion) async {
  const path = 'hanswehr.sqlite';
  final prefs = await SharedPreferences.getInstance();
  final currentVersion = prefs.getInt('db_version') ?? 0;
  final needsRefresh = currentVersion < dbVersion;

  if (needsRefresh) {
    try {
      await deleteDatabase(path);
    } catch (_) {}
  }

  if (!needsRefresh) {
    try {
      final db = await openDatabase(path, readOnly: true);
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='DICTIONARY'",
      );
      if (tables.isNotEmpty) return db;
      await db.close();
    } catch (_) {}
  }

  final response = await http.get(Uri.parse(_dbAssetUrl));
  final Uint8List bytes = response.bodyBytes;

  await databaseFactory.writeDatabaseBytes(path, bytes);
  await prefs.setInt('db_version', dbVersion);
  return openDatabase(path, readOnly: true);
}

Future<void> downloadAndReplaceDb(String url, int newVersion) async {
  const path = 'hanswehr.sqlite';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) throw Exception('Download failed');
  try {
    await deleteDatabase(path);
  } catch (_) {}
  await databaseFactory.writeDatabaseBytes(path, response.bodyBytes);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('db_version', newVersion);
}
