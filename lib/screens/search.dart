import 'dart:math';

import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:provider/provider.dart';

import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import '../classes/definition_provider.dart';

import '../classes/search_suggestions_provider.dart';
import '../widgets/definition_space.dart';
import '../widgets/drawer.dart';
import '../constants/app_constants.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
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
    return Consumer<DefinitionProvider>(
      builder: (_, definitionListConsumer, __) {
        return WillPopScope(
          onWillPop: () {
            if (definitionListConsumer.searchType == null) {
              return Future.value(true);
            }
            definitionListConsumer.searchType = null;
            return Future.value(false);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: const CommonDrawer(currentScreen: searchScreenTitle),
            body: buildSearchBar(definitionListConsumer),
          ),
        );
      },
    );
  }

  Widget buildSearchBar(DefinitionProvider definitionListConsumer) {
    final actions = [
      FloatingSearchBarAction.searchToClear(
        showIfClosed: true,
      ),
    ];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Consumer<SearchSuggestionsProvider>(
      builder: (context, model, _) => FloatingSearchBar(
        controller: controller,
        clearQueryOnClose: false,
        hint: 'Arabic/English العربية/الإنكليزية',
        transitionDuration: const Duration(milliseconds: 0),
        transitionCurve: Curves.easeInOutCubic,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : 0.0,
        openAxisAlignment: 0.0,
        // maxWidth: 1000,
        actions: actions,
        progress: model.isLoading,
        onSubmitted: (query) {
          controller.close();
          model.addHistory(query);

          buildDefinitionOnSubmission(
            context,
            query,
            definitionListConsumer,
          );
        },
        onFocusChanged: (isFocused) {},
        onQueryChanged: model.onQueryChanged,
        scrollPadding: EdgeInsets.zero,
        transition: CircularFloatingSearchBarTransition(),
        builder: (context, _) =>
            buildExpandableBody(model, definitionListConsumer),
        body: buildDefinitionSpace(),
      ),
    );
  }

  void buildDefinitionOnSubmission(BuildContext context, String searchWord,
      DefinitionProvider definitionListConsumer) async {
    DefinitionProvider value =
        await databaseObject.definition(searchWord, 'FullTextSearch');
    definitionListConsumer.updateDefinition(
      value.id,
      value.word,
      value.definition,
      value.isRoot,
      value.highlight,
      searchWord,
      value.quranOccurrence,
      value.favoriteFlag,
    );
  }

  Widget buildExpandableBody(SearchSuggestionsProvider model,
      DefinitionProvider definitionListConsumer) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      child: ImplicitlyAnimatedList<String>(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        items: model.suggestions.take(6).toList(),
        areItemsTheSame: (a, b) => a == b,
        itemBuilder: (context, animation, searchWord, i) {
          return SizeFadeTransition(
            animation: animation,
            child: buildItem(context, searchWord, definitionListConsumer),
          );
        },
        updateItemBuilder: (context, animation, searchWord) {
          return FadeTransition(
            opacity: animation,
            child: buildItem(context, searchWord, definitionListConsumer),
          );
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, String searchWord,
      DefinitionProvider definitionList) {
    final model =
        Provider.of<SearchSuggestionsProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () async {
            definitionList.searchType =
                allAlphabets.contains(searchWord.substring(0, 1))
                    ? 'RootSearch'
                    : 'FullTextSearch';
            definitionList.searchWord = searchWord;
            model.addHistory(searchWord);
            Future.delayed(
              const Duration(milliseconds: 50000),
              () => model.clear(),
            );
            FloatingSearchBar.of(context)!.close();
            DefinitionProvider value = await databaseObject.definition(
                searchWord, definitionList.searchType);
            definitionList.updateDefinition(
              value.id,
              value.word,
              value.definition,
              value.isRoot,
              value.highlight,
              searchWord,
              value.quranOccurrence,
              value.favoriteFlag,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    child: model.getHistory().contains(searchWord)
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
                        searchWord,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (model.suggestions.isNotEmpty &&
            searchWord != model.suggestions.last)
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
            children: const [
              DefinitionSpace(),
            ],
          ),
        ),
      ],
    );
  }
}
