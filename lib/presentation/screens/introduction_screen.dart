import 'package:flutter/material.dart';
import '../../data/intro_texts.dart';

class IntroductionBody extends StatelessWidget {
  const IntroductionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Section(title: 'PREFACE', text: prefaceText, cs: cs, textStyle: textStyle),
        const SizedBox(height: 16),
        _Section(title: 'PREFACE TO THE POCKET BOOK EDITION', text: prefacePocketText, cs: cs, textStyle: textStyle),
        const SizedBox(height: 16),
        _Section(title: 'INTRODUCTION', text: introText, cs: cs, textStyle: textStyle, initiallyExpanded: true),
      ],
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
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cs.primary)),
        children: [
          SelectableText(text,
              style: textStyle.bodyMedium?.copyWith(height: 1.6, color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
