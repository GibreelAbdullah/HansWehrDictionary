import 'package:flutter/foundation.dart';

class DefinitionClass with ChangeNotifier {
  DefinitionClass({
    required this.id,
    required this.word,
    required this.definition,
    required this.isRoot,
    required this.highlight,
    this.searchWord,
    this.quranOccurrence,
    required this.favoriteFlag,
  });

  static String? searchType;
  String? searchWord;
  List<int?> id;
  List<String?> word;
  List<String?> definition;
  List<int?> isRoot;
  List<int?> highlight;
  List<int?>? quranOccurrence;
  List<int?> favoriteFlag;

  void updateSearchType(String newSearchType) {
    DefinitionClass.searchType = newSearchType;
    notifyListeners();
  }
}
