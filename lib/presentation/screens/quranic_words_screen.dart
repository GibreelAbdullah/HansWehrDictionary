import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/dictionary_entry.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/entry_card.dart';

class QuranicWordsScreen extends ConsumerWidget {
  const QuranicWordsScreen({super.key});

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

  Future<void> _pushEntry(BuildContext context, WidgetRef ref, DictionaryEntry entry) async {
    final router = GoRouter.of(context);
    if (entry.isRoot) {
      router.go('/entry/${entry.word}');
    } else {
      final repo = ref.read(repositoryProvider);
      final parent = await repo.getEntry(entry.parentId);
      if (parent != null) {
        router.go('/entry/${parent.word}?highlight=${entry.id}');
      }
    }
  }
}
