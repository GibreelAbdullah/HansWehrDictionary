import 'dart:math';

import 'package:appodeal_flutter/appodeal_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';

import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:search/classes/definitionClass.dart';

import 'package:search/classes/searchModel.dart';
import 'package:search/widgets/definitionSpace.dart';
import 'package:search/widgets/drawer.dart';
import 'package:search/constants/appConstants.dart';

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

  // String searchType = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchModel>(
      create: (_) => SearchModel(),
      child: ChangeNotifierProvider<DefinitionClass>(
        create: (_) => DefinitionClass(
          definition: [],
          isRoot: [],
          highlight: [],
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: AppodealBanner(
            placementName: "Appodeal Banner Ad",
          ),
          drawer: CommonDrawer(SEARCH_SCREEN_TITLE),
          body: buildSearchBar(),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    final actions = [
      FloatingSearchBarAction.searchToClear(
        showIfClosed: true,
      ),
    ];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Consumer<SearchModel>(
      builder: (context, model, _) => FloatingSearchBar(
        automaticallyImplyBackButton: false,
        controller: controller,
        clearQueryOnClose: false,
        hint: 'Arabic/English العربية/الإنكليزية',
        transitionDuration: const Duration(milliseconds: 0),
        transitionCurve: Curves.easeInOutCubic,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : 0.0,
        openAxisAlignment: 0.0,
        maxWidth: 1000,
        actions: actions,
        progress: model.isLoading,
        onSubmitted: (query) {
          controller.close();
          model.addHistory(query);

          buildDefinitionOnSubmission(
            context,
            query,
          );
        },
        onFocusChanged: (isFocused) {},
        onQueryChanged: model.onQueryChanged,
        scrollPadding: EdgeInsets.zero,
        transition: CircularFloatingSearchBarTransition(),
        builder: (context, _) => buildExpandableBody(model),
        body: buildDefinitionSpace(),
      ),
    );
  }

  void buildDefinitionOnSubmission(
      BuildContext context, String searchWord) async {
    final definitionList = Provider.of<DefinitionClass>(context, listen: false);
    definitionList.searchType = 'FullTextSearch';
    DefinitionClass value =
        await databaseObject.definition(searchWord, definitionList.searchType);
    setState(() {
      definitionList.searchWord = searchWord;
      definitionList.definition = value.definition;
      definitionList.isRoot = value.isRoot;
      definitionList.highlight = value.highlight;
    });
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
            definitionList.searchType =
                ALL_ALPHABETS.contains(word.substring(0, 1))
                    ? 'RootSearch'
                    : 'FullTextSearch';
            definitionList.searchWord = word;
            model.addHistory(word);
            Future.delayed(
              const Duration(milliseconds: 50000),
              () => model.clear(),
            );
            FloatingSearchBar.of(context).close();
            databaseObject
                .definition(word, definitionList.searchType)
                .then((value) => setState(() {
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
                    child: model.getHistory().contains(word)
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
}
