import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const _migrationDoneKey = 'migration_from_old_done';

/// Migrates favorites and history from the old app version.
/// Old favorites: stored as FAVORITE_FLAG=1 in the SQLite DB at getDatabasesPath().
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
  // Only migrate if new key doesn't already have data
  if ((prefs.getStringList('search_history') ?? []).isNotEmpty) return;

  final oldHistory = prefs.getString('history') ?? '';
  if (oldHistory.isEmpty) return;

  final items = oldHistory.split(',').where((s) => s.isNotEmpty).toList();
  // Old format stored oldest-first; new format stores newest-first
  await prefs.setStringList('search_history', items.reversed.toList());
}

Future<void> _migrateFavorites(SharedPreferences prefs) async {
  // Only migrate if new key doesn't already have data
  if ((prefs.getStringList('favorite_ids') ?? []).isNotEmpty) return;

  try {
    final dbDir = await getDatabasesPath();
    final oldPath = join(dbDir, 'hanswehr.sqlite');
    if (!await File(oldPath).exists()) return;

    final db = await openDatabase(oldPath, readOnly: true);
    final results = await db.rawQuery(
      'SELECT ID FROM DICTIONARY WHERE FAVORITE_FLAG = 1',
    );
    await db.close();

    if (results.isEmpty) return;
    final ids = results.map((r) => r['ID'].toString()).toList();
    await prefs.setStringList('favorite_ids', ids);
  } catch (_) {
    // Silently fail — don't block app startup
  }
}
