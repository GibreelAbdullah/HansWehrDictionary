import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';

TextStyle arabicFontStyle(WidgetRef ref, [TextStyle? base]) {
  final font = ref.watch(arabicFontProvider).value ?? ArabicFont.system;
  final style = base ?? const TextStyle();
  return switch (font) {
    ArabicFont.system => style,
    ArabicFont.amiri => GoogleFonts.amiri(textStyle: style),
    ArabicFont.notoNaskhArabic => GoogleFonts.notoNaskhArabic(textStyle: style),
    ArabicFont.scheherazadeNew => GoogleFonts.scheherazadeNew(textStyle: style),
  };
}

TextStyle englishFontStyle(WidgetRef ref, [TextStyle? base]) {
  final font = ref.watch(englishFontProvider).value ?? EnglishFont.system;
  final style = base ?? const TextStyle();
  return switch (font) {
    EnglishFont.system => style,
    EnglishFont.roboto => GoogleFonts.roboto(textStyle: style),
    EnglishFont.merriweather => GoogleFonts.merriweather(textStyle: style),
    EnglishFont.lora => GoogleFonts.lora(textStyle: style),
  };
}
