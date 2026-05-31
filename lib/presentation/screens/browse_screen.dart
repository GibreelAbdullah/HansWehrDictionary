import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/entry_card.dart';

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

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
          ...singleCharAsync.when(
            data: (entries) => entries.map((e) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: EntryCard(
                    entry: e,
                    onTap: () => context.push('/entry/${e.word}'),
                  ),
                )),
            loading: () => [const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))],
            error: (e, _) => [Text('Error: $e')],
          ),
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
                  onTap: () => context.push('/entry/${e.word}'),
                ),
              )).toList(),
        ),
        loading: () => const Padding(padding: EdgeInsets.all(8), child: Center(child: CircularProgressIndicator())),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}
