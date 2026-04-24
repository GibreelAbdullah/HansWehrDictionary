import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/quran_reference.dart';
import '../providers/dictionary_providers.dart';

class QuranReferencesSheet extends ConsumerWidget {
  final String rootWord;

  const QuranReferencesSheet({super.key, required this.rootWord});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refsAsync = ref.watch(quranReferencesProvider(rootWord));
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.menu_book, color: cs.primary),
                    const SizedBox(width: 8),
                    Text('Quran References — $rootWord',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: cs.onSurface)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: refsAsync.when(
                  data: (refs) {
                    if (refs.isEmpty) {
                      return const Center(child: Text('No Quran references found'));
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: refs.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) => _RefTile(ref: refs[i], cs: cs),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RefTile extends StatelessWidget {
  final QuranReference ref;
  final ColorScheme cs;

  const _RefTile({required this.ref, required this.cs});

  Future<void> _openReference(BuildContext context) async {
    // Try quran app URI scheme first
    final quranAppUri = Uri.parse('quran://${ref.surah}/${ref.ayah}/${ref.word}');
    try {
      final launched = await launchUrl(quranAppUri, mode: LaunchMode.externalApplication);
      if (launched) return;
    } catch (_) {}

    // Fallback to quran.com
    final webUri = Uri.parse('https://www.quran.com/${ref.surah}:${ref.ayah}');
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: cs.primaryContainer,
        child: Text('${ref.surah}', style: TextStyle(fontSize: 12, color: cs.onPrimaryContainer)),
      ),
      title: Text('Surah ${ref.surah}, Ayah ${ref.ayah}', style: TextStyle(color: cs.onSurface)),
      subtitle: Text('Word position: ${ref.word}', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
      trailing: Icon(Icons.open_in_new, size: 18, color: cs.primary),
      onTap: () => _openReference(context),
    );
  }
}
