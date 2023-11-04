import '../classes/definition_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class DatabaseAccess {
  static const String _newDBName = "hanswehr.sqlite";
  static const String _oldDBName = "hanswehrV12.db";

  Future<Database> openDatabaseConnection() async {
    var path = "";
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      path = normalize(absolute(
          join('.dart_tool', 'sqflite_common_ffi', 'databases', _newDBName)));
    }
    path = join(await getDatabasesPath(), _newDBName);
    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", _newDBName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      var oldPath = join(await getDatabasesPath(), _oldDBName);
      exists = await databaseExists(oldPath);
      if (exists) {
        databaseFactory.deleteDatabase(oldPath);
      }
    }
    Database db = await openDatabase(path);
    return db;
  }

  Future<List<String?>> allWords() async {
    Database db = await databaseConnection;
    List<String?> allDictionaryWords = [];
    List<Map> mapOfWords =
        await db.rawQuery('SELECT WORD FROM DICTIONARY WHERE IS_ROOT = 1');

    for (var wordMap in mapOfWords) {
      wordMap.forEach(
        (key, word) {
          allDictionaryWords.add(
            word,
          );
        },
      );
    }
    return allDictionaryWords;
  }

  Future<DefinitionProvider> definition(String? word, String? type) async {
    Database db = await databaseConnection;
    late String query;
    switch (type) {
      case "BrowseScreen":
        query =
            "SELECT word, 0 highlight, definition, is_root, quran_occurrence FROM DICTIONARY WHERE PARENT_ID IN (SELECT ID FROM DICTIONARY WHERE WORD = '$word' and IS_ROOT=1) ORDER BY ID";
        break;
      case "RootSearch":
        query =
            "SELECT id, word, CASE word when '$word' then 1 else 0 end as highlight, definition, is_root, quran_occurrence, favorite_flag FROM DICTIONARY WHERE PARENT_ID IN (SELECT PARENT_ID FROM DICTIONARY WHERE WORD = '$word') ORDER BY ID";
        break;
      case "FullTextSearch":
        query =
            "SELECT id, word, MAX(highlight) highlight, definition, is_root, quran_occurrence, favorite_flag from (SELECT dict.word, dict.id, CASE dict.id WHEN dict2.id then 1 else 0 end as highlight, REPLACE(dict.definition,'$word','<mark>$word</mark>') AS definition,  dict.is_root , dict.quran_occurrence, dict.favorite_flag FROM DICTIONARY dict inner join (SELECT ID, PARENT_ID, is_root FROM DICTIONARY WHERE definition match '$word' LIMIT 50) dict2 ON dict.parent_id = dict2.parent_id) group by word, definition, is_root, quran_occurrence order by id ";
        break;
      default:
        break;
    }

    List<Map<String, dynamic>> definition = await db.rawQuery(query);
    DefinitionProvider allDefinitions = DefinitionProvider(
      id: [],
      word: [],
      definition: [],
      isRoot: [],
      highlight: [],
      quranOccurrence: [],
      favoriteFlag: [],
    );

    for (var element in definition) {
      element.forEach((key, value) {
        if (key == 'id') {
          allDefinitions.id.add(value);
        } else if (key == 'word') {
          allDefinitions.word.add(value);
        } else if (key == 'definition') {
          allDefinitions.definition.add(value);
        } else if (key == 'is_root') {
          allDefinitions.isRoot.add(value);
        } else if (key == 'highlight') {
          allDefinitions.highlight.add(value);
        } else if (key == 'quran_occurrence') {
          allDefinitions.quranOccurrence!.add(value);
        } else if (key == 'favorite_flag') {
          allDefinitions.favoriteFlag.add(value);
        }
      });
    }
    return allDefinitions;
  }

  Future<List<String>> topFiveWords(String word) async {
    Database db = await databaseConnection;

    String query =
        "SELECT DISTINCT WORD FROM DICTIONARY WHERE WORD like '$word%' ORDER BY LENGTH(WORD), WORD LIMIT 6";
    List<Map<String, dynamic>> definition = await db.rawQuery(query);
    List<String> allWords = [];

    for (var element in definition) {
      element.forEach((key, value) {
        allWords.add(value);
      });
    }
    return allWords;
  }

  Future<List<Map<String, dynamic>>> getQuranicWords() async {
    Database db = await databaseConnection;

    String query =
        "SELECT DISTINCT WORD, QURAN_OCCURRENCE FROM DICTIONARY WHERE QURAN_OCCURRENCE is not null ORDER BY QURAN_OCCURRENCE desc";
    List<Map<String, dynamic>> quranicWords = await db.rawQuery(query);
    return quranicWords;
  }

  Future<List<String>> allXLevelWords(String? word, int length) async {
    Database db = await databaseConnection;

    String query = length == 2
        ? "select distinct substr(word,1,2) from dictionary where WORD like '$word%' and is_root = 1 order by word"
        : (word!.length == 1
            ? "SELECT DISTINCT WORD FROM DICTIONARY WHERE WORD = '$word' AND IS_ROOT = 1"
            : "SELECT DISTINCT WORD FROM DICTIONARY WHERE WORD like '$word%' AND IS_ROOT = 1");
    List<Map<String, dynamic>> definition = await db.rawQuery(query);
    List<String> allWords = [];

    for (var element in definition) {
      element.forEach((key, value) {
        allWords.add(value);
      });
    }
    return allWords;
  }

  Future<List<Map<String, dynamic>>> quranicDetails(String? word) async {
    Database db = await databaseConnection;

    String query =
        "SELECT SURAH, AYAH, WORD as POSITION FROM quran WHERE root_word = '$word'";
    List<Map<String, dynamic>> quranLocation = await db.rawQuery(query);
    return quranLocation;
  }

  void toggleFavorites(int id, int addFlag) async {
    Database db = await databaseConnection;

    String query =
        "UPDATE DICTIONARY SET FAVORITE_FLAG = $addFlag WHERE id = $id";
    db.rawQuery(query);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    Database db = await databaseConnection;
    String query = 'SELECT ID, WORD FROM DICTIONARY WHERE FAVORITE_FLAG = 1';
    List<Map<String, dynamic>> favorites = await db.rawQuery(query);
    return favorites;
  }

  Future<Map<String, dynamic>> dbVersionDetails() async {
    Database db = await databaseConnection;
    String query = 'SELECT DB_VERSION, LAST_CHECKED FROM DATABASE_VERSION';
    List<Map<String, dynamic>> version = await db.rawQuery(query);
    return version.first;
  }

  Future<List<Map<String, dynamic>>> notifications() async {
    Database db = await databaseConnection;
    String query =
        "SELECT NOTIFICATION, strftime('%Y-%m-%d %H:%M',CREATED_DATE) AS CREATED_DATE, VISIBLE_FLAG FROM NOTIFICATIONS WHERE VISIBLE_FLAG = 1";
    List<Map<String, dynamic>> version = await db.rawQuery(query);
    return version;
  }

  applyUpdates(String updateDBScript) async {
    Database db = await databaseConnection;

    List<String> updateDBCommand = updateDBScript.split('\n');

    await db.transaction((txn) async {
      for (var command in updateDBCommand) {
        txn.execute(command);
      }
      // return await txn.rawUpdate(updateDBScript);
    });
  }

  markNotificationsRead() async {
    Database db = await databaseConnection;
    db.rawUpdate(
        'UPDATE NOTIFICATIONS SET VISIBLE_FLAG = 0 WHERE VISIBLE_FLAG = 1');
  }
}
