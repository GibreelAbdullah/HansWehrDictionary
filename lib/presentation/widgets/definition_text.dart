import 'package:flutter/material.dart';

final _boldPattern = RegExp(r'<b>(.*?)</b>');

/// Cache of parsed definition spans. Parsing involves a regex pass over the
/// full definition string and building a span tree; doing it on every widget
/// build (e.g. while scrolling long Browse lists) is a major source of jank.
/// The cache is keyed by the raw text plus the bold color, since the bold
/// style's color is the only theme-dependent part of the output.
const int _parseCacheMaxEntries = 2000;
final Map<String, List<TextSpan>> _parseCache = {};

List<TextSpan> parseDefinition(String text, {TextStyle? boldStyle}) {
  final cacheKey = '${boldStyle?.color?.toARGB32() ?? 0}\u0000$text';
  final cached = _parseCache[cacheKey];
  if (cached != null) return cached;

  final result = _parseDefinitionUncached(text, boldStyle: boldStyle);

  // Simple size cap: clear when it grows too large. Browse/search churn makes
  // a true LRU unnecessary here — a periodic reset keeps memory bounded.
  if (_parseCache.length >= _parseCacheMaxEntries) {
    _parseCache.clear();
  }
  _parseCache[cacheKey] = result;
  return result;
}

List<TextSpan> _parseDefinitionUncached(String text, {TextStyle? boldStyle}) {
  final spans = <TextSpan>[];
  int start = 0;

  for (final match in _boldPattern.allMatches(text)) {
    // Text before this bold tag
    if (match.start > start) {
      spans.add(TextSpan(text: text.substring(start, match.start)));
    }
    // Newline before the verb form
    if (spans.isNotEmpty) {
      spans.add(const TextSpan(text: '\n'));
    }
    // Bold verb form
    spans.add(TextSpan(
      text: match.group(1),
      style: boldStyle ?? const TextStyle(fontWeight: FontWeight.bold),
    ));
    start = match.end;
  }

  // Remaining text after last bold tag
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start)));
  }

  return spans;
}
