import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dictionary_providers.dart';
import '../providers/search_history_provider.dart';
import '../widgets/entry_card.dart';

/// Full-text search results page. The query is driven by the `?q=` URL
/// parameter so searches are shareable via their URL.
class SearchScreen extends ConsumerStatefulWidget {
  final String query;
  const SearchScreen({super.key, required this.query});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  void initState() {
    super.initState();
    _syncFromUrl();
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _syncFromUrl();
    }
  }

  void _syncFromUrl() {
    final q = widget.query.trim();
    // Drive the shared search state from the URL so a shared link reproduces
    // the same results.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(searchModeProvider.notifier).set(SearchMode.fullText);
      ref.read(searchQueryProvider.notifier).set(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final query = widget.query.trim();

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Text('Type a query to search', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }

    return results.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: 12),
                Text('No results found', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 4, bottom: 16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final entry = list[i];
            return EntryCard(
              entry: entry,
              indentDerivative: true,
              highlightQuery: query,
              onTap: () {
                ref.read(searchHistoryProvider.notifier).add(entry.word);
                final router = GoRouter.of(context);
                if (entry.isRoot) {
                  router.go('/entry/${entry.word}');
                } else {
                  ref.read(repositoryProvider).getEntry(entry.parentId).then((parent) {
                    if (parent != null) {
                      router.go('/entry/${parent.word}?highlight=${entry.id}');
                    }
                  });
                }
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Search error: $e')),
    );
  }
}
