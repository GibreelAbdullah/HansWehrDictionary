import 'package:sqflite_common/sqflite.dart';

import 'database_helper_native.dart' if (dart.library.html) 'database_helper_web.dart' as platform;

class DatabaseHelper {
  static Database? _database;
  static const dbVersion = 5;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await platform.initDatabase(dbVersion);
    return _database!;
  }

  /// Call after a remote DB update to force re-open on next access.
  static void invalidate() {
    _database?.close();
    _database = null;
  }
}
