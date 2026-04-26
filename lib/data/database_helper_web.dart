import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> initDatabase(int dbVersion) async {
  const path = 'hanswehr.sqlite';
  final prefs = await SharedPreferences.getInstance();
  final currentVersion = prefs.getInt('db_version') ?? 0;

  if (currentVersion < dbVersion) {
    // On web, sqflite_ffi_web handles the virtual filesystem.
    // We need to delete and recreate if version changed.
    try {
      await deleteDatabase(path);
    } catch (_) {}
    await prefs.setInt('db_version', dbVersion);
  }

  final data = await rootBundle.load('assets/hanswehr.sqlite');
  final bytes = data.buffer.asUint8List();

  final db = await openDatabase(path, readOnly: false);
  // Check if tables exist; if not, restore from asset
  final tables = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='entries'",
  );
  if (tables.isEmpty) {
    await db.close();
    // Write the asset bytes to the database path
    await databaseFactory.writeDatabaseBytes(path, bytes);
    return openDatabase(path, readOnly: true);
  }
  return db;
}
