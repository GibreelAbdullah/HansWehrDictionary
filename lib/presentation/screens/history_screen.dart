import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/search_history_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(searchHistoryProvider).value ?? [];
    final cs = Theme.of(context).colorScheme;

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 64, color: cs.outlineVariant),
            const SizedBox(height: 12),
            Text('No history yet', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
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
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: history.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (_, i) {
              final query = history[i];
              final isSelected = _selected.contains(query);
              return ListTile(
                leading: isSelected
                    ? Icon(Icons.check_circle, color: cs.primary)
                    : IconButton(
                        icon: Icon(Icons.delete_outline, color: cs.onSurfaceVariant),
                        onPressed: () => ref.read(searchHistoryProvider.notifier).remove(query),
                      ),
                title: Text(query, style: const TextStyle(fontSize: 18), textDirection: TextDirection.rtl),
                selected: isSelected,
                onTap: () {
                  if (_selected.isNotEmpty) {
                    setState(() {
                      isSelected ? _selected.remove(query) : _selected.add(query);
                    });
                  } else {
                    context.push('/entry/$query');
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
