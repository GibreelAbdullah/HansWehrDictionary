import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/entry_card.dart';
import 'entry_navigation.dart';

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
            onTap: () => pushEntry(context, ref, entry),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
