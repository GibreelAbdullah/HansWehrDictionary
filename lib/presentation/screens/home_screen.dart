import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/dictionary_entry.dart';
import '../providers/dictionary_providers.dart';
import '../providers/favorites_provider.dart';
import '../providers/search_history_provider.dart';
import '../widgets/entry_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/constrained_body.dart';

String _entryUri(String word, int occ) {
  return occ > 1 ? '/entry/$word/$occ' : '/entry/$word';
}

/// Navigate to a root entry.
Future<void> _pushRootEntry(BuildContext context, WidgetRef ref, DictionaryEntry entry) async {
  final repo = ref.read(repositoryProvider);
  final occ = await repo.getRootOccurrence(entry.id, entry.word);
  final uri = _entryUri(entry.word, occ);
  if (context.mounted) context.go(uri);
}

/// Navigate to any entry (root or derived). Derived entries go to their parent with highlight.
Future<void> _pushEntry(BuildContext context, WidgetRef ref, DictionaryEntry entry) async {
  if (entry.isRoot) {
    return _pushRootEntry(context, ref, entry);
  }
  final repo = ref.read(repositoryProvider);
  final parent = await repo.getEntry(entry.parentId);
  if (parent != null && context.mounted) {
    final occ = await repo.getRootOccurrence(parent.id, parent.word);
    final uri = '${_entryUri(parent.word, occ)}?highlight=${entry.id}';
    if (context.mounted) context.go(uri);
  }
}

enum HomeView { dashboard, favorites, quranicWords, browse, history }

class HomeScreen extends ConsumerWidget {
  final HomeView view;
  const HomeScreen({super.key, required this.view});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final isSearching = query.isNotEmpty;
    final isBottom = ref.watch(searchBarBottomProvider).value ?? false;

    final searchBar = const DictionarySearchBar();
    final content = Expanded(
      child: isSearching ? const _SearchResults() : _buildView(view),
    );

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Hans Wehr',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DISCLAIMER - Not 100% Accurate.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onErrorContainer)),
                      const SizedBox(height: 4),
                      Text(
                          'Text was extracted from scanned pages and has many errors which unfortunately is not possible to fix manually.',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onErrorContainer)),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse('https://arabicstudentsdictionary.com/')),
                        child: Text('Try Arabic Students Dictionary for corrected text.',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Introduction'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/introduction');
                },
              ),
              ListTile(
                leading: const Icon(Icons.format_list_numbered),
                title: const Text('Verb Forms'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/verb-forms');
                },
              ),
              ListTile(
                leading: const Icon(Icons.short_text),
                title: const Text('Abbreviations'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/abbreviations');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/about');
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ConstrainedBody(
          child: Stack(
            children: [
              Column(
                children: isBottom
                    ? [content, const Divider(height: 1), searchBar]
                    : [searchBar, const Divider(height: 1), content],
              ),
              Positioned(
                bottom: isBottom ? 12 : null,
                top: isBottom ? null : 12,
                left: 0,
                child: Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
              ),
              Positioned(
                bottom: isBottom ? 12 : null,
                top: isBottom ? null : 12,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () => context.go('/'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildView(HomeView view) {
    switch (view) {
      case HomeView.dashboard:
        return const _Dashboard();
      case HomeView.favorites:
        return const _FavoritesList();
      case HomeView.quranicWords:
        return const _QuranicWordsList();
      case HomeView.browse:
        return const _BrowseAll();
      case HomeView.history:
        return const _HistoryList();
    }
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _Tile(
            icon: Icons.favorite,
            color: cs.error,
            title: 'Favorites',
            onTap: () => context.go('/favorites'),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.menu_book,
            color: cs.tertiary,
            title: 'Quranic Words',
            onTap: () => context.go('/quranic-words'),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.list,
            color: cs.primary,
            title: 'Browse',
            onTap: () => context.go('/browse'),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.history,
            color: cs.secondary,
            title: 'History',
            onTap: () => context.go('/history'),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _Tile({required this.icon, required this.color, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
        trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}

class _FavoritesList extends ConsumerWidget {
  const _FavoritesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoriteEntriesProvider);
    return favs.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 4, bottom: 16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final entry = list[i];
            return EntryCard(
              entry: entry,
              onTap: () => _pushEntry(context, ref, entry),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _QuranicWordsList extends ConsumerWidget {
  const _QuranicWordsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(quranicWordsProvider);
    return words.when(
      data: (list) => ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        itemCount: list.length,
        itemBuilder: (_, i) {
          final entry = list[i];
          return EntryCard(
            entry: entry,
            onTap: () => _pushEntry(context, ref, entry),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);
    final mode = ref.watch(searchModeProvider);
    final query = ref.watch(searchQueryProvider);

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
              highlightQuery: mode == SearchMode.fullText ? query : null,
              onTap: () {
                ref.read(searchHistoryProvider.notifier).add(entry.word);
                _pushEntry(context, ref, entry);
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

class _HistoryList extends ConsumerStatefulWidget {
  const _HistoryList();

  @override
  ConsumerState<_HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends ConsumerState<_HistoryList> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(searchHistoryProvider).value ?? [];
    final cs = Theme.of(context).colorScheme;

    if (history.isEmpty) {
      return const Center(child: Text('No history yet'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (_selected.isNotEmpty) ...[
                Text('${_selected.length} selected',
                    style: TextStyle(color: cs.onSurfaceVariant)),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Delete'),
                  onPressed: () {
                    for (final q in _selected) {
                      ref.read(searchHistoryProvider.notifier).remove(q);
                    }
                    setState(() => _selected.clear());
                  },
                ),
              ] else ...[
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.delete_sweep, size: 18),
                  label: const Text('Clear all'),
                  onPressed: () => ref.read(searchHistoryProvider.notifier).clear(),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: history.length,
            itemBuilder: (_, i) {
              final query = history[i];
              final isSelected = _selected.contains(query);
              return ListTile(
                leading: isSelected
                    ? Icon(Icons.check_circle, color: cs.primary)
                    : Icon(Icons.history, color: cs.onSurfaceVariant),
                title: Text(query),
                selected: isSelected,
                onTap: () {
                  if (_selected.isNotEmpty) {
                    setState(() {
                      isSelected ? _selected.remove(query) : _selected.add(query);
                    });
                  } else {
                    ref.read(searchQueryProvider.notifier).set(query);
                  }
                },
                onLongPress: () {
                  setState(() {
                    isSelected ? _selected.remove(query) : _selected.add(query);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BrowseAll extends ConsumerWidget {
  const _BrowseAll();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final letters = ref.watch(rootFirstLettersProvider);
    return letters.when(
      data: (list) => ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        itemCount: list.length,
        itemBuilder: (_, i) => _LetterTile(letter: list[i]),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _LetterTile extends ConsumerWidget {
  final String letter;
  const _LetterTile({required this.letter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final singleCharAsync = ref.watch(singleCharRootsProvider(letter));
    final prefixesAsync = ref.watch(rootPrefixesProvider(letter));

    return Container(
      color: cs.primaryContainer.withValues(alpha: 0.08),
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(letter,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: cs.onSurface),
            textDirection: TextDirection.rtl),
        children: [
          // Single-char root entries shown first
          ...singleCharAsync.when(
            data: (entries) => entries.map((e) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: EntryCard(
                    entry: e,
                    onTap: () => _pushRootEntry(context, ref, e),
                  ),
                )),
            loading: () => [const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))],
            error: (e, _) => [Text('Error: $e')],
          ),
          // Two-letter prefix groups
          ...prefixesAsync.when(
            data: (prefixes) => prefixes.map((p) => _PrefixTile(prefix: p)),
            loading: () => [const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))],
            error: (e, _) => [Text('Error: $e')],
          ),
        ],
      ),
    );
  }
}

class _PrefixTile extends ConsumerWidget {
  final String prefix;
  const _PrefixTile({required this.prefix});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.secondaryContainer.withValues(alpha: 0.12),
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        tilePadding: const EdgeInsets.only(left: 32, right: 48),
        title: Text(prefix,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: cs.onSurface),
            textDirection: TextDirection.rtl),
        children: [_PrefixEntries(prefix: prefix)],
      ),
    );
  }
}

class _PrefixEntries extends ConsumerWidget {
  final String prefix;
  const _PrefixEntries({required this.prefix});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final entriesAsync = ref.watch(rootsByPrefixProvider(prefix));
    return Container(
      color: cs.tertiaryContainer.withValues(alpha: 0.1),
      child: entriesAsync.when(
        data: (entries) => Column(
          children: entries.map((e) => Padding(
                padding: const EdgeInsets.only(right: 48),
                child: EntryCard(
                  entry: e,
                  onTap: () => _pushRootEntry(context, ref, e),
                ),
              )).toList(),
        ),
        loading: () => const Padding(padding: EdgeInsets.all(8), child: Center(child: CircularProgressIndicator())),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}
