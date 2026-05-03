import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/constrained_body.dart';

const _transliterationTable = [
  ('a', 'ا آ أ إ ء ى'),
  ('b', 'ب'),
  ('t', 'ت ط'),
  ('th', 'ث'),
  ('j', 'ج'),
  ('h', 'ه ح ة'),
  ('kh', 'خ'),
  ('d', 'د ض'),
  ('dh', 'ذ'),
  ('r', 'ر'),
  ('z', 'ز ظ'),
  ('s', 'س ص'),
  ('sh', 'ش'),
  ('e', 'ع'),
  ('gh', 'غ'),
  ('f', 'ف'),
  ('q', 'ق'),
  ('k', 'ك'),
  ('l', 'ل'),
  ('m', 'م'),
  ('n', 'ن'),
  ('w / v', 'و'),
  ('y', 'ي'),
];

class TransliterationScreen extends ConsumerWidget {
  const TransliterationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottom = ref.watch(searchBarBottomProvider).value ?? false;
    final cs = Theme.of(context).colorScheme;

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
            child: Text('Transliteration',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );

    final body = ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Type Latin letters in keyword search to find Arabic words. '
              'Similar-sounding letters share the same key.',
              style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: cs.primaryContainer.withValues(alpha: 0.3)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Latin', style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Arabic', style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary)),
                  ),
                ],
              ),
              for (final (latin, arabic) in _transliterationTable)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(latin,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: cs.onSurface)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(arabic,
                          style: TextStyle(fontSize: 22, color: cs.onSurface),
                          textDirection: TextDirection.rtl),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: ConstrainedBody(
          child: Column(
            children: isBottom
                ? [Expanded(child: body), const Divider(height: 1), toolbar]
                : [toolbar, const Divider(height: 1), Expanded(child: body)],
          ),
        ),
      ),
    );
  }
}
