import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database_helper.dart';
import '../domain/dictionary_entry.dart';
import '../domain/quran_reference.dart';

class DictionaryRepository {
  Future<Database> get _db => DatabaseHelper.database;

  Future<List<DictionaryEntry>> getRootEntries({int limit = 50, int offset = 0}) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE is_root = 1 ORDER BY id LIMIT ? OFFSET ?',
      [limit, offset],
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<List<DictionaryEntry>> getAllEntries({int limit = 25000}) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY ORDER BY id LIMIT ?',
      [limit],
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<List<DictionaryEntry>> getChildEntries(int parentId) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE parent_id = ? AND is_root = 0 ORDER BY id',
      [parentId],
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<DictionaryEntry?> getEntry(int id) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE id = ?',
      [id],
    );
    if (results.isEmpty) return null;
    return DictionaryEntry.fromMap(results.first);
  }

  /// Returns the nth root entry matching [word] (1-based index).
  Future<DictionaryEntry?> getRootByWord(String word, {int occurrence = 1}) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE is_root = 1 AND word = ? ORDER BY id LIMIT 1 OFFSET ?',
      [word, occurrence - 1],
    );
    if (results.isEmpty) return null;
    return DictionaryEntry.fromMap(results.first);
  }

  /// Returns the 1-based occurrence index of a root entry among roots with the same word.
  Future<int> getRootOccurrence(int id, String word) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id FROM DICTIONARY WHERE is_root = 1 AND word = ? ORDER BY id',
      [word],
    );
    for (int i = 0; i < results.length; i++) {
      if (results[i]['id'] == id) return i + 1;
    }
    return 1;
  }

  /// Returns the parent root entry + all siblings for a given entry
  Future<List<DictionaryEntry>> getFamily(int parentId) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE id = ? OR parent_id = ? ORDER BY is_root DESC, id',
      [parentId, parentId],
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<List<DictionaryEntry>> searchByWord(String query) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE word LIKE ? ORDER BY is_root DESC, id LIMIT 100',
      ['%$query%'],
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<List<DictionaryEntry>> fullTextSearch(String query) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE DICTIONARY MATCH ? ORDER BY is_root DESC LIMIT 100',
      [query],
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<List<DictionaryEntry>> getEntriesByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final db = await _db;
    final placeholders = ids.map((_) => '?').join(',');
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE id IN ($placeholders)',
      ids,
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<List<DictionaryEntry>> getQuranicWords() async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      "FROM DICTIONARY WHERE quran_occurrence IS NOT NULL AND quran_occurrence != '' "
      'ORDER BY CAST(quran_occurrence AS INTEGER) DESC',
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<List<String>> getRootFirstLetters() async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT DISTINCT SUBSTR(word, 1, 1) as letter '
      'FROM DICTIONARY WHERE is_root = 1 ORDER BY letter',
    );
    return results.map((r) => r['letter'] as String).toList();
  }

  Future<List<String>> getRootPrefixes(String firstLetter) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT DISTINCT SUBSTR(word, 1, 2) as prefix '
      'FROM DICTIONARY WHERE is_root = 1 AND LENGTH(word) > 1 '
      'AND SUBSTR(word, 1, 1) = ? ORDER BY prefix',
      [firstLetter],
    );
    return results.map((r) => r['prefix'] as String).toList();
  }

  Future<List<DictionaryEntry>> getRootsByPrefix(String prefix) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE is_root = 1 AND word LIKE ? ORDER BY word',
      ['$prefix%'],
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<List<DictionaryEntry>> getSingleCharRoots(String letter) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT id, word, definition, is_root, parent_id, quran_occurrence, favorite_flag '
      'FROM DICTIONARY WHERE is_root = 1 AND word = ?',
      [letter],
    );
    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<List<QuranReference>> getQuranReferences(String rootWord) async {
    final db = await _db;
    final results = await db.rawQuery(
      'SELECT SURAH, AYAH, WORD FROM QURAN WHERE ROOT_WORD = ? ORDER BY SURAH, AYAH, WORD',
      [rootWord],
    );
    return results
        .map((r) => QuranReference(
              surah: r['SURAH'] as int,
              ayah: r['AYAH'] as int,
              word: r['WORD'] as int,
            ))
        .toList();
  }
}
