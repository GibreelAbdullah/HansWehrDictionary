import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/dictionary_entry.dart';
import '../providers/dictionary_providers.dart';
import '../providers/favorites_provider.dart';
import '../widgets/definition_text.dart';
import '../widgets/entry_card.dart';
import '../widgets/quran_references_sheet.dart';

class EntryDetailScreen extends ConsumerStatefulWidget {
  final DictionaryEntry entry;
  final int? highlightEntryId;

  const EntryDetailScreen({super.key, required this.entry, this.highlightEntryId});

  @override
  ConsumerState<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends ConsumerState<EntryDetailScreen> {
  final _highlightKey = GlobalKey();
  bool _hasScrolled = false;

  void _tryScroll() {
    if (_hasScrolled || widget.highlightEntryId == null) return;
    _hasScrolled = true;
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      final ctx = _highlightKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          alignment: 0.3,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(childEntriesProvider(widget.entry.id));
    final cs = Theme.of(context).colorScheme;
    final isBottom = ref.watch(searchBarBottomProvider).value ?? false;

    final toolbar = _Toolbar(entry: widget.entry);

    final body = children.when(
      data: (list) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _tryScroll());
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildRootHeader(cs),
                if (list.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text('Derived Forms',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: cs.primary, fontWeight: FontWeight.w600)),
                  ),
                for (final child in list)
                  Padding(
                    key: child.id == widget.highlightEntryId ? _highlightKey : null,
                    padding: const EdgeInsets.only(right: 24),
                    child: EntryCard(entry: child, isHighlighted: child.id == widget.highlightEntryId),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );

    if (isBottom) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: body),
              const Divider(height: 1),
              toolbar,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            toolbar,
            const Divider(height: 1),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _buildRootHeader(ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.entry.word,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: cs.onSurface),
            textDirection: TextDirection.rtl,
          ),
          if (widget.entry.quranOccurrence != null && widget.entry.quranOccurrence!.isNotEmpty) ...[
            const SizedBox(height: 8),
            SelectionContainer.disabled(
              child: GestureDetector(
                onTap: () => _showQuranRefs(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.menu_book, size: 16, color: cs.tertiary),
                      const SizedBox(width: 6),
                      Text('Quran occurrences: ${widget.entry.quranOccurrence}',
                          style: TextStyle(color: cs.tertiary, fontSize: 13)),
                      const SizedBox(width: 4),
                      Icon(Icons.open_in_new, size: 13, color: cs.tertiary),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 16, height: 1.5, color: cs.onSurfaceVariant),
              children: parseDefinition(widget.entry.definition,
                  boldStyle: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface)),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuranRefs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuranReferencesSheet(rootWord: widget.entry.word),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final DictionaryEntry entry;
  const _Toolbar({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(entry.word,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis),
          ),
          _FavoriteButton(entryId: entry.id),
        ],
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  final int entryId;
  const _FavoriteButton({required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoritesProvider);
    final isFav = favs.value?.contains(entryId) ?? false;
    return IconButton(
      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? Theme.of(context).colorScheme.error : null),
      onPressed: () => ref.read(favoritesProvider.notifier).toggle(entryId),
    );
  }
}
