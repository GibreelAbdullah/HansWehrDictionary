import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database_helper.dart';
import '../../data/db_update_service.dart';

final dbReadyProvider = FutureProvider<void>((ref) async {
  await DatabaseHelper.database;
});

final dbUpdateProvider = FutureProvider<DbUpdateInfo?>((ref) => checkForDbUpdate());

final dbVersionProvider = FutureProvider<int>((ref) async {
  await DatabaseHelper.database;
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('db_version') ?? DatabaseHelper.dbVersion;
});
