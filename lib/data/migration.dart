import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'migration_native.dart' if (dart.library.html) 'migration_stub.dart'
    as native_migration;

const _migrationDoneKey = 'migration_from_old_done';

/// Migrates favorites and history from the old app version.
Future<void> migrateFromOldApp() async {
  if (kIsWeb) return;
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_migrationDoneKey) ?? false) return;

  await _migrateHistory(prefs);
  await native_migration.migrateFavorites(prefs);

  await prefs.setBool(_migrationDoneKey, true);
}

Future<void> _migrateHistory(SharedPreferences prefs) async {
  if ((prefs.getStringList('search_history') ?? []).isNotEmpty) return;

  final oldHistory = prefs.getString('history') ?? '';
  if (oldHistory.isEmpty) return;

  final items = oldHistory.split(',').where((s) => s.isNotEmpty).toList();
  await prefs.setStringList('search_history', items.reversed.toList());
}
