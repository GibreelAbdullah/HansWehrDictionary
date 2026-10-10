import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/dictionary_entry.dart';
import '../providers/dictionary_providers.dart';

/// Entry navigation helpers.
///
/// Hans Wehr navigates straight to `/entry/<word>` (no occurrence index).
/// (Lane's Lexicon has a divergent version of this file that resolves an
/// occurrence index before navigating, because its headwords can repeat.)
String entryUri(String word, int occ) => '/entry/$word';

Future<void> pushRootEntry(BuildContext context, WidgetRef ref, DictionaryEntry entry) async {
  GoRouter.of(context).go('/entry/${entry.word}');
}

Future<void> pushEntry(BuildContext context, WidgetRef ref, DictionaryEntry entry) async {
  if (entry.isRoot) {
    return pushRootEntry(context, ref, entry);
  }
  final repo = ref.read(repositoryProvider);
  final router = GoRouter.of(context);
  final parent = await repo.getEntry(entry.parentId);
  if (parent != null) {
    router.go('/entry/${parent.word}?highlight=${entry.id}');
  }
}
