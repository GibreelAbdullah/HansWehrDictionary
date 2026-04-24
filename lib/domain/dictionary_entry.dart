class DictionaryEntry {
  final int id;
  final String word;
  final String definition;
  final bool isRoot;
  final int parentId;
  final String? quranOccurrence;
  final bool isFavorite;

  const DictionaryEntry({
    required this.id,
    required this.word,
    required this.definition,
    required this.isRoot,
    required this.parentId,
    this.quranOccurrence,
    this.isFavorite = false,
  });

  factory DictionaryEntry.fromMap(Map<String, dynamic> map) {
    return DictionaryEntry(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()) ?? 0,
      word: map['word']?.toString() ?? '',
      definition: map['definition']?.toString() ?? '',
      isRoot: map['is_root']?.toString() == '1',
      parentId: map['parent_id'] is int
          ? map['parent_id']
          : int.tryParse(map['parent_id']?.toString() ?? '0') ?? 0,
      quranOccurrence: map['quran_occurrence']?.toString(),
      isFavorite: map['favorite_flag']?.toString() == '1',
    );
  }
}
