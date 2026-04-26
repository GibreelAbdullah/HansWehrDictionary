import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/quran_reference.dart';
import '../providers/dictionary_providers.dart';

class QuranReferencesSheet extends ConsumerStatefulWidget {
  final String rootWord;

  const QuranReferencesSheet({super.key, required this.rootWord});

  @override
  ConsumerState<QuranReferencesSheet> createState() => _QuranReferencesSheetState();
}

class _QuranReferencesSheetState extends ConsumerState<QuranReferencesSheet> {
  final _sheetController = DraggableScrollableController();
  bool _expanded = false;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _expandIfNeeded() {
    if (_expanded) return;
    _expanded = true;
    _sheetController.animateTo(0.85,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final refsAsync = ref.watch(quranReferencesProvider(widget.rootWord));
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification &&
                notification.scrollDelta != null &&
                notification.scrollDelta! > 0 &&
                _sheetController.size < 0.85) {
              _expandIfNeeded();
            }
            return false;
          },
          child: Container(
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
                      Text('Quran References — ${widget.rootWord}',
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
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      final quranAppUri = Uri.parse('quran://${ref.surah}/${ref.ayah}/${ref.word}');
      try {
        final launched = await launchUrl(quranAppUri, mode: LaunchMode.externalApplication);
        if (launched) return;
      } catch (_) {}
    }
    final webUri = Uri.parse('https://quran.com/${ref.surah}/${ref.ayah}');
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
