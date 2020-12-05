import 'dart:math';

import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';

import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'search_model.dart';
import '../components/drawer.dart';
import '../constants/appConstants.dart';

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
      child: ChangeNotifierProvider<ValueNotifier<List<String>>>(
        create: (_) => ValueNotifier<List<String>>(['Type to Search']),
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
        hint: '...بحث',
        iconColor: Colors.grey,
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final model = Provider.of<SearchModel>(context, listen: false);
    final definitionList =
        Provider.of<ValueNotifier<List<String>>>(context, listen: false);

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
            databaseObject.definition(word).then((value) => setState(() {
                  definitionList.value = value;
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
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.label_important,
                            key: Key('word'),
                            color: Colors.grey,
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
                        style: textTheme.bodyText2
                            .copyWith(color: Colors.grey.shade600),
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
      body: Consumer<ValueNotifier<List<String>>>(
        builder: (_, definitionList, __) => ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: definitionList.value.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return Container(
              child: ListTile(
                title: Text(definitionList.value[index]),
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}
