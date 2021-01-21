// import 'package:flutter/material.dart';
import 'package:search/classes/definitionClass.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../constants/appConstants.dart';

class DatabaseAccess {
  Future<Database> openDatabaseConnection() async {
    // Sqflite.devSetDebugModeOn(true);
    var path = join(await getDatabasesPath(), "hanswehrV4.db");
    var exists = await databaseExists(path);

    if (!exists) {
      print("HansWehr DB V3 doesn't exist");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "hanswehrV4.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      var oldPath = join(await getDatabasesPath(), "hanswehrV3.db");
      exists = await databaseExists(oldPath);
      if (exists) {
        print("HansWehr DB V3 exist");
        databaseFactory.deleteDatabase(oldPath);
      }
    }
    Database db = await openDatabase(path);
    return db;
  }

  Future<List<String>> allWords() async {
    Database db = await databaseConnection;
    List<String> allDictionaryWords = [];
    List<Map> mapOfWords =
        await db.rawQuery('SELECT WORD FROM DICTIONARY WHERE IS_ROOT = 1');

    mapOfWords.forEach(
      (wordMap) {
        wordMap.forEach(
          (key, word) {
            allDictionaryWords.add(
              word,
            );
          },
        );
      },
    );
    return allDictionaryWords;
  }

  Future<DefinitionClass> definition(String word, bool rootOnly) async {
    Database db = await databaseConnection;

    String query = rootOnly
        ? "SELECT 0 highlight, DEFINITION, IS_ROOT FROM DICTIONARY WHERE PARENT_ID IN (SELECT ID FROM DICTIONARY WHERE WORD = '$word' and IS_ROOT=1) ORDER BY ID"
        : "SELECT CASE word when '$word' then 1 else 0 end as highlight, DEFINITION, IS_ROOT FROM DICTIONARY WHERE PARENT_ID IN (SELECT PARENT_ID FROM DICTIONARY WHERE WORD = '$word') ORDER BY ID";
    List<Map<String, dynamic>> definition = await db.rawQuery(query);
    DefinitionClass allDefinitions =
        DefinitionClass(definition: [], isRoot: [], highlight: []);

    definition.forEach((element) {
      element.forEach((key, value) {
        if (key == 'definition') {
          allDefinitions.definition.add(value);
        } else if (key == 'is_root') {
          allDefinitions.isRoot.add(value);
        } else if (key == 'highlight') {
          allDefinitions.highlight.add(value);
        }
      });
    });
    return allDefinitions;
  }

  Future<List<String>> topFiveWords(String word) async {
    Database db = await databaseConnection;

    String query =
        "SELECT DISTINCT WORD FROM DICTIONARY WHERE WORD like '$word%' ORDER BY LENGTH(WORD), WORD LIMIT 5";
    List<Map<String, dynamic>> definition = await db.rawQuery(query);
    List<String> allWords = [];

    definition.forEach((element) {
      element.forEach((key, value) {
        allWords.add(value);
      });
    });
    return allWords;
  }

  Future<List<String>> allXLevelWords(String word, int length) async {
    Database db = await databaseConnection;

    String query = length == 2
        ? "select distinct substr(word,1,2) from dictionary where WORD like '$word%' and is_root = 1 order by word"
        : (word.length == 1
            ? "SELECT DISTINCT WORD FROM DICTIONARY WHERE WORD = '$word' AND IS_ROOT = 1"
            : "SELECT DISTINCT WORD FROM DICTIONARY WHERE WORD like '$word%' AND IS_ROOT = 1");
    List<Map<String, dynamic>> definition = await db.rawQuery(query);
    List<String> allWords = [];

    definition.forEach((element) {
      element.forEach((key, value) {
        allWords.add(value);
      });
    });
    return allWords;
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
