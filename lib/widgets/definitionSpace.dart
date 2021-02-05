import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:search/classes/appTheme.dart';
import 'package:search/classes/definitionClass.dart';
import 'package:search/constants/appConstants.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';

class DefinitionSpace extends StatefulWidget {
  DefinitionSpace({
    Key key,
  }) : super(key: key);
  @override
  _DefinitionSpaceState createState() => _DefinitionSpaceState();
}

class _DefinitionSpaceState extends State<DefinitionSpace> {
  @override
  Widget build(BuildContext context) {
    return FloatingSearchAppBar(
      color: Theme.of(context).scaffoldBackgroundColor,
      colorOnScroll: Theme.of(context).scaffoldBackgroundColor,
      transitionDuration: const Duration(milliseconds: 800),
      body: Consumer<DefinitionClass>(
        builder: (_, definitionList, __) => ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
          itemCount: definitionList.definition.length + 1,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            if (index == 0) {
              if (definitionList.searchType == 'RootSearch') {
                return Container(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text(definitionList.searchWord),
                    subtitle: Text(
                        'Click Here for full text search. Tip : To directly do a full text search press the Enter key instead of selecting from the dropdown'),
                    onTap: () async {
                      definitionList.searchType = 'FullTextSearch';
                      DefinitionClass value = await databaseObject.definition(
                          definitionList.searchWord, definitionList.searchType);
                      setState(() {
                        definitionList.definition = value.definition;
                        definitionList.isRoot = value.isRoot;
                        definitionList.highlight = value.highlight;
                      });
                    },
                  ),
                );
              } else {
                if (definitionList.definition.length > 50) {
                  return Container(
                    child: FlatButton.icon(
                      icon: Icon(Icons.info),
                      label: Text(
                          'Showing First 50 results for ${definitionList.searchWord}'),
                      onPressed: () {},
                    ),
                  );
                }
                return Container(
                  child: FlatButton.icon(
                    icon: Icon(Icons.info),
                    label: Text(definitionList.searchWord == null
                        ? "Search In Arabic or English"
                        : definitionList.searchWord),
                    onPressed: () {},
                  ),
                );
              }
            }
            return Container(
              child: ListTileTheme(
                selectedColor: hexToColor(
                    locator<LocalStorageService>().highlightTextColor),
                child: ListTile(
                  selected: definitionList.highlight[index - 1] == 1,
                  selectedTileColor: hexToColor(
                      locator<LocalStorageService>().highlightTileColor),
                  contentPadding: EdgeInsets.fromLTRB(
                      definitionList.isRoot[index - 1] == 1 ? 16.0 : 50.0,
                      0,
                      16,
                      0),
                  title: HtmlWidget(
                    definitionList.definition[index - 1],
                  ),
                  onTap: () {},
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
