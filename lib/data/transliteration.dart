/// Returns true if [text] contains no Arabic characters.
bool isLatin(String text) {
  return !text.runes.any(_isArabicCodeUnit);
}

/// Returns true if [text] starts with an Arabic character.
bool isArabic(String text) {
  if (text.isEmpty) return false;
  return _isArabicCodeUnit(text.runes.first);
}

bool _isArabicCodeUnit(int r) {
  return r >= 0x0600 && r <= 0x06FF ||
      r >= 0x0750 && r <= 0x077F ||
      r >= 0xFB50 && r <= 0xFDFF ||
      r >= 0xFE70 && r <= 0xFEFF;
}

/// Normalizes a Latin transliteration query for database lookup.
String normalizeTransliteration(String query) {
  const mapping = {'v': 'w', 'i': 'y', '3': 'e'};
  return query.toLowerCase().replaceAllMapped(
    RegExp(r'[vi3]'),
    (match) => mapping[match.group(0)]!,
  );
}
