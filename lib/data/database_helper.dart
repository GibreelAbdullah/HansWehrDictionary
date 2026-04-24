import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const _dbVersion = 3; // bump when asset DB changes

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'hanswehr.sqlite');
    final prefs = await SharedPreferences.getInstance();
    final currentVersion = prefs.getInt('db_version') ?? 0;

    if (!await File(path).exists() || currentVersion < _dbVersion) {
      final data = await rootBundle.load('assets/hanswehr.sqlite');
      final bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
      await prefs.setInt('db_version', _dbVersion);
    }

    return openDatabase(path, readOnly: true);
  }
}
