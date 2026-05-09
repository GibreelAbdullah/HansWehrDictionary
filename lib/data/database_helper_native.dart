import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> initDatabase(int dbVersion) async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, 'hanswehr.sqlite');
  final prefs = await SharedPreferences.getInstance();
  final currentVersion = prefs.getInt('db_version') ?? 0;

  if (!await File(path).exists() || currentVersion < dbVersion) {
    final data = await rootBundle.load('assets/hanswehr.sqlite');
    final bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes, flush: true);
    await prefs.setInt('db_version', dbVersion);
  }

  return openDatabase(path, readOnly: true);
}

Future<void> downloadAndReplaceDb(String url, int newVersion) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) throw Exception('Download failed');
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, 'hanswehr.sqlite');
  await File(path).writeAsBytes(response.bodyBytes, flush: true);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('db_version', newVersion);
}
