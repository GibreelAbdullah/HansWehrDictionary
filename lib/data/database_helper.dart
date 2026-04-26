import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_helper_native.dart' if (dart.library.html) 'database_helper_web.dart' as platform;

class DatabaseHelper {
  static Database? _database;
  static const _dbVersion = 4;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await platform.initDatabase(_dbVersion);
    return _database!;
  }
}
