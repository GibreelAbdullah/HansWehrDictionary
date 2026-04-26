import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/constrained_body.dart';

class _VerbForm {
  final String form;
  final String pattern;
  final String meaning;
  final String exampleAr;
  final String exampleEn;

  const _VerbForm({
    required this.form,
    required this.pattern,
    required this.meaning,
    required this.exampleAr,
    required this.exampleEn,
  });
}

const _verbForms = [
  _VerbForm(
    form: 'I',
    pattern: 'فَعَلَ',
    meaning: 'Base form — the simple root meaning of the verb.',
    exampleAr: 'كَتَبَ',
    exampleEn: 'he wrote',
  ),
  _VerbForm(
    form: 'II',
    pattern: 'فَعَّلَ',
    meaning: 'Intensive, causative, or denominative of Form I.',
    exampleAr: 'عَلَّمَ',
    exampleEn: 'he taught (caused to know)',
  ),
  _VerbForm(
    form: 'III',
    pattern: 'فَاعَلَ',
    meaning: 'Doing the action with or towards someone (reciprocal/associative).',
    exampleAr: 'كَاتَبَ',
    exampleEn: 'he corresponded with',
  ),
  _VerbForm(
    form: 'IV',
    pattern: 'أَفْعَلَ',
    meaning: 'Causative — making someone do the Form I action.',
    exampleAr: 'أَجْلَسَ',
    exampleEn: 'he seated (caused to sit)',
  ),
  _VerbForm(
    form: 'V',
    pattern: 'تَفَعَّلَ',
    meaning: 'Reflexive of Form II — doing the action to oneself.',
    exampleAr: 'تَعَلَّمَ',
    exampleEn: 'he learned (taught himself)',
  ),
  _VerbForm(
    form: 'VI',
    pattern: 'تَفَاعَلَ',
    meaning: 'Mutual/reciprocal action, or pretending to do something.',
    exampleAr: 'تَبَادَلَ',
    exampleEn: 'they exchanged with each other',
  ),
  _VerbForm(
    form: 'VII',
    pattern: 'اِنْفَعَلَ',
    meaning: 'Passive or reflexive of Form I.',
    exampleAr: 'اِنْكَسَرَ',
    exampleEn: 'it broke (was broken)',
  ),
  _VerbForm(
    form: 'VIII',
    pattern: 'اِفْتَعَلَ',
    meaning: 'Reflexive with a sense of doing for oneself.',
    exampleAr: 'اِجْتَمَعَ',
    exampleEn: 'he gathered / assembled',
  ),
  _VerbForm(
    form: 'IX',
    pattern: 'اِفْعَلَّ',
    meaning: 'Acquiring a color or physical quality.',
    exampleAr: 'اِحْمَرَّ',
    exampleEn: 'it turned red',
  ),
  _VerbForm(
    form: 'X',
    pattern: 'اِسْتَفْعَلَ',
    meaning: 'Seeking or requesting the Form I action.',
    exampleAr: 'اِسْتَغْفَرَ',
    exampleEn: 'he sought forgiveness',
  ),
];

class VerbFormsScreen extends ConsumerWidget {
  const VerbFormsScreen({super.key});

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
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text('Verb Forms',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );

    final body = ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _verbForms.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final v = _verbForms[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: cs.primaryContainer,
                      child: Text(v.form,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cs.onPrimaryContainer)),
                    ),
                    const SizedBox(width: 12),
                    Text(v.pattern,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface),
                        textDirection: TextDirection.rtl),
                  ],
                ),
                const SizedBox(height: 8),
                Text(v.meaning,
                    style: TextStyle(
                        fontSize: 14, color: cs.onSurfaceVariant)),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(v.exampleAr,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface),
                          textDirection: TextDirection.rtl),
                      const SizedBox(width: 12),
                      Text('— ${v.exampleEn}',
                          style: TextStyle(
                              fontSize: 14, color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
