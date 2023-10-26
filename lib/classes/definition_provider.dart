import 'package:flutter/foundation.dart';

class DefinitionProvider with ChangeNotifier {
  DefinitionProvider({
    required this.id,
    required this.word,
    required this.definition,
    required this.isRoot,
    required this.highlight,
    this.searchWord,
    this.quranOccurrence,
    required this.favoriteFlag,
  });

  String? searchType;
  String? searchWord;
  List<int?> id;
  List<String?> word;
  List<String?> definition;
  List<int?> isRoot;
  List<int?> highlight;
  List<int?>? quranOccurrence;
  List<int?> favoriteFlag;

  void updateSearchType(String newSearchType) {
    searchType = newSearchType;
    notifyListeners();
  }

  void updateDefinition(
      List<int?> newId,
      List<String?> newWord,
      List<String?> newDefinition,
      List<int?> newIsRoot,
      List<int?> newHighlight,
      String newSearchWord,
      List<int?>? newQuranOccurrence,
      List<int?> newFavoriteFlag) {
    id = newId;
    word = newWord;
    definition = newDefinition;
    isRoot = newIsRoot;
    highlight = newHighlight;
    quranOccurrence = newQuranOccurrence;
    favoriteFlag = newFavoriteFlag;
    notifyListeners();
  }
}
