import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import 'entry_navigation.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoriteEntriesProvider);
    final cs = Theme.of(context).colorScheme;
    return favs.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 64, color: cs.outlineVariant),
                const SizedBox(height: 12),
                Text('No favorites yet', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: list.length,
          separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (_, i) {
            final entry = list[i];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              leading: IconButton(
                icon: Icon(Icons.favorite, color: cs.error),
                onPressed: () => ref.read(favoritesProvider.notifier).toggle(entry.id),
              ),
              title: Text(entry.word,
                  style: TextStyle(fontSize: 18, color: cs.onSurface),
                  textDirection: TextDirection.rtl),
              onTap: () => pushEntry(context, ref, entry),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
