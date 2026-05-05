import 'package:flutter/material.dart';
import 'providers/theme_provider.dart';

class AppTheme {
  static ThemeData buildLight(ThemeSettings settings) {
    final seed = settings.customColors.primary ?? settings.preset.color;
    final base = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
    final cs = base.copyWith(
      surface: settings.customColors.background ?? base.surface,
      surfaceContainerHighest: settings.customColors.surface ?? base.surfaceContainerHighest,
      surfaceContainerLow: settings.customColors.derivativeCard ?? base.surfaceContainerLow,
      primary: settings.customColors.primary ?? base.primary,
      secondary: settings.customColors.accent ?? base.secondary,
      onSurface: settings.customColors.text ?? base.onSurface,
      onSurfaceVariant: settings.customColors.text?.withAlpha(180) ?? base.onSurfaceVariant,
    );
    return _build(cs);
  }

  static ThemeData buildDark(ThemeSettings settings) {
    final seed = settings.customColors.primary ?? settings.preset.color;
    final base = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
    final cs = base.copyWith(
      surface: settings.customColors.background ?? base.surface,
      surfaceContainerHighest: settings.customColors.surface ?? base.surfaceContainerHighest,
      surfaceContainerLow: settings.customColors.derivativeCard ?? base.surfaceContainerLow,
      primary: settings.customColors.primary ?? base.primary,
      secondary: settings.customColors.accent ?? base.secondary,
      onSurface: settings.customColors.text ?? base.onSurface,
      onSurfaceVariant: settings.customColors.text?.withAlpha(180) ?? base.onSurfaceVariant,
    );
    return _build(cs);
  }

  static ThemeData _build(ColorScheme cs) {
    return ThemeData(
      colorScheme: cs,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Fallback defaults used before settings load
  static final light = buildLight(const ThemeSettings());
  static final dark = buildDark(const ThemeSettings());
}
