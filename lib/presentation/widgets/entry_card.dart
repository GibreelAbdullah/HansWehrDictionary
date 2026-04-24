import 'package:flutter/material.dart';
import '../../domain/dictionary_entry.dart';
import 'definition_text.dart';

class EntryCard extends StatelessWidget {
  final DictionaryEntry entry;
  final VoidCallback? onTap;
  final bool isHighlighted;
  final String? highlightQuery;
  final bool indentDerivative;

  const EntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.isHighlighted = false,
    this.highlightQuery,
    this.indentDerivative = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color cardColor;
    if (isHighlighted) {
      cardColor = cs.tertiaryContainer.withValues(alpha: 0.6);
    } else if (entry.isRoot) {
      cardColor = cs.primaryContainer.withValues(alpha: 0.35);
    } else {
      cardColor = cs.surfaceContainerLow;
    }

    final rightMargin = (!entry.isRoot && indentDerivative) ? 28.0 : 12.0;

    return Card(
      color: cardColor,
      margin: EdgeInsets.only(left: 12, right: rightMargin, top: entry.isRoot ? 6 : 3, bottom: entry.isRoot ? 6 : 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (entry.quranOccurrence != null && entry.quranOccurrence!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.menu_book, size: 12, color: cs.onTertiaryContainer),
                          const SizedBox(width: 3),
                          Text(entry.quranOccurrence!,
                              style: TextStyle(fontSize: 11, color: cs.onTertiaryContainer)),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Text(
                      entry.word,
                      style: TextStyle(
                        fontSize: entry.isRoot ? 26 : 22,
                        fontWeight: entry.isRoot ? FontWeight.bold : FontWeight.w500,
                        color: cs.onSurface,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              highlightQuery != null && highlightQuery!.isNotEmpty
                  ? _buildHighlightedText(entry.definition, highlightQuery!, cs)
                  : RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant, height: 1.4),
                        children: parseDefinition(entry.definition,
                            boldStyle: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface)),
                      ),
                      maxLines: entry.isRoot ? 3 : 10,
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, ColorScheme cs) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lowerText.indexOf(lowerQuery, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: TextStyle(
          color: cs.primary,
          fontWeight: FontWeight.bold,
          backgroundColor: cs.primaryContainer.withValues(alpha: 0.4),
        ),
      ));
      start = idx + query.length;
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant, height: 1.4),
        children: spans,
      ),
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );
  }
}
