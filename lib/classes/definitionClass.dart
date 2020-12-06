import 'package:flutter/foundation.dart';

class DefinitionClass with ChangeNotifier {
  DefinitionClass({this.definition, this.isRoot, this.highlight});
  List<String> definition;
  List<int> isRoot;
  List<int> highlight;
}
