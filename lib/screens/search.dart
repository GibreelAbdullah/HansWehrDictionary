import 'dart:math';

import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';

import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:search/classes/appTheme.dart';
import 'package:search/classes/definitionClass.dart';
import 'package:search/services/LocalStorageService.dart';

import '../classes/search_model.dart';
import '../components/drawer.dart';
import '../constants/appConstants.dart';
import '../serviceLocator.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final controller = FloatingSearchBarController();

  int _index = 0;
  int get index => _index;
  set index(int value) {
    _index = min(value, 2);
    _index == 2 ? controller.hide() : controller.show();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchModel>(
      create: (_) => SearchModel(),
      child: ChangeNotifierProvider<DefinitionClass>(
        create: (_) => DefinitionClass(
          definition: [
            'Type in Arabic to search',
          ],
          isRoot: [
            1,
          ],
          highlight: [
            1,
          ],
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: CommonDrawer(SEARCH_SCREEN_TITLE),
          body: buildSearchBar(),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    final actions = [
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Consumer<SearchModel>(
      builder: (context, model, _) => FloatingSearchBar(
        automaticallyImplyBackButton: false,
        controller: controller,
        clearQueryOnClose: false,
        hint: '...ابحث',
        transitionDuration: const Duration(milliseconds: 0),
        transitionCurve: Curves.easeInOutCubic,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : 0.0,
        openAxisAlignment: 0.0,
        maxWidth: 1000,
        actions: actions,
        progress: model.isLoading,
        debounceDelay: const Duration(milliseconds: 0),
        onQueryChanged: model.onQueryChanged,
        scrollPadding: EdgeInsets.zero,
        transition: ExpandingFloatingSearchBarTransition(),
        builder: (context, _) => buildExpandableBody(model),
        body: buildDefinitionSpace(),
      ),
    );
  }

  Widget buildDefinitionSpace() {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: min(index, 2),
            children: [
              DefinitionSpace(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildExpandableBody(SearchModel model) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      child: ImplicitlyAnimatedList<String>(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        items: model.suggestions.take(6).toList(),
        areItemsTheSame: (a, b) => a == b,
        itemBuilder: (context, animation, word, i) {
          return SizeFadeTransition(
            animation: animation,
            child: buildItem(context, word),
          );
        },
        updateItemBuilder: (context, animation, word) {
          return FadeTransition(
            opacity: animation,
            child: buildItem(context, word),
          );
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, String word) {
    final model = Provider.of<SearchModel>(context, listen: false);
    final definitionList = Provider.of<DefinitionClass>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            Future.delayed(
              const Duration(milliseconds: 50000),
              () => model.clear(),
            );
            FloatingSearchBar.of(context).close();
            databaseObject.definition(word, false).then((value) => setState(() {
                  definitionList.definition = value.definition;
                  definitionList.isRoot = value.isRoot;
                  definitionList.highlight = value.highlight;
                }));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    child: model.suggestions == history
                        ? const Icon(
                            Icons.history,
                            key: Key('history'),
                          )
                        : const Icon(
                            Icons.label_important,
                            key: Key('word'),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (model.suggestions.isNotEmpty && word != model.suggestions.last)
          const Divider(height: 0),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class DefinitionSpace extends StatefulWidget {
  const DefinitionSpace({
    Key key,
  }) : super(key: key);
  @override
  _DefinitionSpaceState createState() => _DefinitionSpaceState();
}

class _DefinitionSpaceState extends State<DefinitionSpace> {
  @override
  _DefinitionSpaceState();
  Widget build(BuildContext context) {
    return FloatingSearchAppBar(
      title: const Text('Title'),
      transitionDuration: const Duration(milliseconds: 800),
      body: Consumer<DefinitionClass>(
        builder: (_, definitionList, __) => ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
          itemCount: definitionList.definition.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return Container(
              child: ListTile(
                tileColor: definitionList.highlight[index] == 1
                    ? hexToColor(locator<LocalStorageService>().highlightColor)
                    : Theme.of(context).scaffoldBackgroundColor,
                contentPadding: EdgeInsets.fromLTRB(
                    definitionList.isRoot[index] == 1 ? 16.0 : 50.0, 0, 16, 0),
                title: SelectableText(
                  definitionList.definition[index],
                ),
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}
