/// Returns true if [text] contains no Arabic characters.
bool isLatin(String text) {
  return !text.runes.any((r) =>
      r >= 0x0600 && r <= 0x06FF ||
      r >= 0x0750 && r <= 0x077F ||
      r >= 0xFB50 && r <= 0xFDFF ||
      r >= 0xFE70 && r <= 0xFEFF);
}
