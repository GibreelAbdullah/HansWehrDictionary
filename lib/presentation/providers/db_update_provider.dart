import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/db_update_service.dart';

final dbUpdateProvider = FutureProvider<DbUpdateInfo?>((ref) => checkForDbUpdate());

final dbVersionProvider = FutureProvider<int>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('db_version') ?? 0;
});
