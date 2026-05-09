import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common/sqflite.dart';

const _dbUrl = 'assets/hanswehr.sqlite';

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

  // Check if DB already exists in virtual filesystem
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

  // Fetch DB over HTTP (relative to the deployed web app)
  final response = await http.get(Uri.parse(_dbUrl));
  final Uint8List bytes = response.bodyBytes;

  await databaseFactory.writeDatabaseBytes(path, bytes);
  await prefs.setInt('db_version', dbVersion);
  return openDatabase(path, readOnly: true);
}
