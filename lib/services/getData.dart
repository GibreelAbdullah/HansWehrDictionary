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
    var path = join(await getDatabasesPath(), "hanswehr.db");
    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "hanswehr.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    Database db = await openDatabase(path, readOnly: true);
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

  Future<DefinitionClass> definition(String word) async {
    Database db = await databaseConnection;

    String query =
        "SELECT CASE word when '$word' then 1 else 0 end as highlight, DEFINITION, IS_ROOT FROM DICTIONARY WHERE PARENT_ID IN (SELECT PARENT_ID FROM DICTIONARY WHERE WORD = '$word') ORDER BY ID";
    List<Map<String, dynamic>> definition = await db.rawQuery(query);
    DefinitionClass allDefinitions =
        DefinitionClass(definition: [], isRoot: [], highlight: []);

    definition.forEach((element) {
      element.forEach((key, value) {
        // print(value);
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

  Future<List<String>> words(String word) async {
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
}
