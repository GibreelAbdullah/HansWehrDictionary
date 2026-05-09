import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

Future<void> migrateFavorites(SharedPreferences prefs) async {
  if ((prefs.getStringList('favorite_ids') ?? []).isNotEmpty) return;

  try {
    final docsDir = await getApplicationDocumentsDirectory();
    final appDataDir = docsDir.parent;
    final oldPath = join(appDataDir.path, 'databases', 'hanswehr.sqlite');

    if (!await File(oldPath).exists()) return;

    final db = sqlite3.sqlite3.open(oldPath, mode: sqlite3.OpenMode.readOnly);
    try {
      final results = db.select(
        'SELECT c0id FROM DICTIONARY_content WHERE c6favorite_flag != 0',
      );
      if (results.isEmpty) return;
      final ids = results.map((r) => r['c0id'].toString()).toList();
      await prefs.setStringList('favorite_ids', ids);
    } finally {
      db.close();
    }
  } catch (_) {}
}
