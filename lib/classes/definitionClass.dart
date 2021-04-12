import 'package:flutter/foundation.dart';

class DefinitionClass with ChangeNotifier {
  DefinitionClass({
    required this.word,
    required this.definition,
    required this.isRoot,
    required this.highlight,
    this.searchWord,
    this.searchType,
    this.quranOccurance,
  });
  String? searchType;
  String? searchWord;
  List<String?> word;
  List<String?> definition;
  List<int?> isRoot;
  List<int?> highlight;
  List<int?>? quranOccurance;
}
