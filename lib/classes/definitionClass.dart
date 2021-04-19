import 'package:flutter/foundation.dart';

class DefinitionClass with ChangeNotifier {
  DefinitionClass({
    required this.id,
    required this.word,
    required this.definition,
    required this.isRoot,
    required this.highlight,
    this.searchWord,
    this.searchType,
    this.quranOccurance,
    required this.favoriteFlag,
  });

  String? searchType;
  String? searchWord;
  List<int?> id;
  List<String?> word;
  List<String?> definition;
  List<int?> isRoot;
  List<int?> highlight;
  List<int?>? quranOccurance;
  List<int?> favoriteFlag;
}
