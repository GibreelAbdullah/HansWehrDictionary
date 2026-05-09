import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

const _migrationDoneKey = 'migration_from_old_done';

/// Migrates favorites and history from the old app version.
/// Old favorites: stored as FAVORITE_FLAG=1 in the SQLite DB at the standard databases path.
/// Old history: stored in SharedPreferences under key 'history' as comma-separated string.
Future<void> migrateFromOldApp() async {
  if (kIsWeb) return;
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_migrationDoneKey) ?? false) return;

  await _migrateHistory(prefs);
  await _migrateFavorites(prefs);

  await prefs.setBool(_migrationDoneKey, true);
}

Future<void> _migrateHistory(SharedPreferences prefs) async {
  if ((prefs.getStringList('search_history') ?? []).isNotEmpty) return;

  final oldHistory = prefs.getString('history') ?? '';
  if (oldHistory.isEmpty) return;

  final items = oldHistory.split(',').where((s) => s.isNotEmpty).toList();
  // Old format stored oldest-first; new format stores newest-first
  await prefs.setStringList('search_history', items.reversed.toList());
}

Future<void> _migrateFavorites(SharedPreferences prefs) async {
  if ((prefs.getStringList('favorite_ids') ?? []).isNotEmpty) return;

  try {
    // On Android, the old app used sqflite's default getDatabasesPath()
    // which is <app_data>/databases/. We derive this from the documents dir.
    final docsDir = await getApplicationDocumentsDirectory();
    // docsDir on Android = /data/data/<pkg>/app_flutter
    // old DB path on Android = /data/data/<pkg>/databases/hanswehr.sqlite
    final appDataDir = docsDir.parent;
    final oldPath = join(appDataDir.path, 'databases', 'hanswehr.sqlite');

    if (!await File(oldPath).exists()) return;

    final db = sqlite3.sqlite3.open(oldPath, mode: sqlite3.OpenMode.readOnly);
    try {
      // Old DB is FTS4 — all values stored as text in DICTIONARY_content
      final results = db.select(
        "SELECT c0id FROM DICTIONARY_content WHERE c6favorite_flag = '1'",
      );
      if (results.isEmpty) return;
      final ids = results.map((r) => r['c0id'].toString()).toList();
      await prefs.setStringList('favorite_ids', ids);
    } finally {
      db.dispose();
    }
  } catch (_) {
    // Silently fail — don't block app startup
  }
}
