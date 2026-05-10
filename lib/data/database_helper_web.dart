import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common/sqflite.dart';
import 'database_helper.dart';

const _dbAssetUrl = 'assets/assets/hanswehr.sqlite';

Future<Database> initDatabase(int dbVersion) async {
  const path = 'hanswehr.sqlite';

  // On web, always fetch the latest DB from the deployed assets.
  try {
    await deleteDatabase(path);
  } catch (_) {}

  final response = await http.get(Uri.parse(_dbAssetUrl));
  final Uint8List bytes = response.bodyBytes;

  await databaseFactory.writeDatabaseBytes(path, bytes);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('db_version', DatabaseHelper.dbVersion);
  return openDatabase(path, readOnly: true);
}

Future<void> downloadAndReplaceDb(String url, int newVersion) async {
  // No-op on web — DB is always fresh from deployed assets.
}
