import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/intro_texts.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/constrained_body.dart';

class IntroductionScreen extends ConsumerWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottom = ref.watch(searchBarBottomProvider).value ?? false;
    final cs = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    final toolbar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          const Expanded(
            child: Text('Introduction',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );

    final body = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Section(title: 'PREFACE', text: prefaceText, cs: cs, textStyle: textStyle),
        const SizedBox(height: 16),
        _Section(title: 'PREFACE TO THE POCKET BOOK EDITION', text: prefacePocketText, cs: cs, textStyle: textStyle),
        const SizedBox(height: 16),
        _Section(title: 'INTRODUCTION', text: introText, cs: cs, textStyle: textStyle, initiallyExpanded: true),
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

class _Section extends StatelessWidget {
  final String title;
  final String text;
  final ColorScheme cs;
  final TextTheme textStyle;
  final bool initiallyExpanded;

  const _Section({
    required this.title,
    required this.text,
    required this.cs,
    required this.textStyle,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: cs.primary)),
        children: [
          SelectableText(text,
              style: textStyle.bodyMedium?.copyWith(
                  height: 1.6, color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
