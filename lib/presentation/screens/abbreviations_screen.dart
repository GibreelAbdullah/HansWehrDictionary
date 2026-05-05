import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/abbreviations.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/constrained_body.dart';

class AbbreviationsScreen extends ConsumerStatefulWidget {
  const AbbreviationsScreen({super.key});

  @override
  ConsumerState<AbbreviationsScreen> createState() => _AbbreviationsScreenState();
}

class _AbbreviationsScreenState extends ConsumerState<AbbreviationsScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final isBottom = ref.watch(searchBarBottomProvider).value ?? false;
    final cs = Theme.of(context).colorScheme;
    final entries = abbreviations.entries
        .where((e) =>
            _filter.isEmpty ||
            e.key.toLowerCase().contains(_filter) ||
            e.value.toLowerCase().contains(_filter))
        .toList();

    final toolbar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          const Expanded(
            child: Text('Abbreviations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );

    final searchField = Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: TextField(
        onChanged: (v) => setState(() => _filter = v.trim().toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Filter abbreviations...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );

    final body = ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: entries.length,
      separatorBuilder: (_, _) => Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.3)),
      itemBuilder: (_, i) {
        final e = entries[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(e.key,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: cs.primary)),
              ),
              Expanded(
                child: Text(e.value,
                    style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant)),
              ),
            ],
          ),
        );
      },
    );

    return Scaffold(
      body: SafeArea(
        child: ConstrainedBody(
          child: Column(
            children: isBottom
                ? [Expanded(child: body), const Divider(height: 1), searchField, toolbar]
                : [toolbar, searchField, const Divider(height: 1), Expanded(child: body)],
          ),
        ),
      ),
    );
  }
}
