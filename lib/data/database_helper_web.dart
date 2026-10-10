import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common/sqflite.dart';

const _dbAssetUrl = 'assets/assets/hanswehr.sqlite';
const _dbPath = 'hanswehr.sqlite';

/// Stream controller for reporting download progress (0.0 to 1.0).
final dbDownloadProgress = StreamController<double>.broadcast();

Future<Database> initDatabase(int dbVersion) async {
  final prefs = await SharedPreferences.getInstance();
  final currentVersion = prefs.getInt('db_version') ?? 0;

  if (currentVersion >= dbVersion) {
    // DB already cached, open directly
    try {
      return await openDatabase(_dbPath, readOnly: true);
    } catch (_) {
      // If open fails, re-download below
    }
  }

  // Download and write the DB
  final request = http.Request('GET', Uri.parse(_dbAssetUrl));
  final response = await request.send();
  final contentLength = response.contentLength ?? 0;

  final bytes = BytesBuilder(copy: false);
  int received = 0;

  await for (final chunk in response.stream) {
    bytes.add(chunk);
    received += chunk.length;
    if (contentLength > 0) {
      dbDownloadProgress.add(received / contentLength);
    }
  }

  try {
    await deleteDatabase(_dbPath);
  } catch (_) {}

  await databaseFactory.writeDatabaseBytes(_dbPath, bytes.takeBytes());
  await prefs.setInt('db_version', dbVersion);
  dbDownloadProgress.add(1.0);
  return openDatabase(_dbPath, readOnly: true);
}

Future<void> downloadAndReplaceDb(String url, int newVersion) async {
  // No-op on web — DB is always fresh from deployed assets.
}
