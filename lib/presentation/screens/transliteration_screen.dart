import 'package:flutter/material.dart';

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
  ('e / 3', 'ع'),
  ('gh', 'غ'),
  ('f', 'ف'),
  ('q', 'ق'),
  ('k', 'ك'),
  ('l', 'ل'),
  ('m', 'م'),
  ('n', 'ن'),
  ('w / v', 'و'),
  ('y / i', 'ي'),
];

class TransliterationBody extends StatelessWidget {
  const TransliterationBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
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
  }
}
