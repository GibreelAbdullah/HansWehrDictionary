import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preset theme options with a seed color.
enum ThemePreset {
  blue(Color(0xFF1565C0), 'Blue'),
  teal(Color(0xFF00897B), 'Teal'),
  purple(Color(0xFF6A1B9A), 'Purple'),
  red(Color(0xFFC62828), 'Red'),
  orange(Color(0xFFE65100), 'Orange'),
  green(Color(0xFF2E7D32), 'Green'),
  indigo(Color(0xFF283593), 'Indigo'),
  brown(Color(0xFF4E342E), 'Brown');

  final Color color;
  final String label;
  const ThemePreset(this.color, this.label);
}

/// Custom color overrides. Null means use the default from the preset.
class CustomColors {
  final Color? background;
  final Color? surface;
  final Color? text;
  final Color? primary;
  final Color? accent;
  final Color? derivativeCard;

  const CustomColors({this.background, this.surface, this.text, this.primary, this.accent, this.derivativeCard});

  CustomColors copyWith({
    Color? Function()? background,
    Color? Function()? surface,
    Color? Function()? text,
    Color? Function()? primary,
    Color? Function()? accent,
    Color? Function()? derivativeCard,
  }) {
    return CustomColors(
      background: background != null ? background() : this.background,
      surface: surface != null ? surface() : this.surface,
      text: text != null ? text() : this.text,
      primary: primary != null ? primary() : this.primary,
      accent: accent != null ? accent() : this.accent,
      derivativeCard: derivativeCard != null ? derivativeCard() : this.derivativeCard,
    );
  }

  bool get hasAny => background != null || surface != null || text != null || primary != null || accent != null || derivativeCard != null;
}

class ThemeSettings {
  final ThemePreset preset;
  final CustomColors customColors;

  const ThemeSettings({this.preset = ThemePreset.blue, this.customColors = const CustomColors()});
}

class ThemeSettingsNotifier extends AsyncNotifier<ThemeSettings> {
  static const _presetKey = 'theme_preset';
  static const _bgKey = 'theme_custom_bg';
  static const _surfaceKey = 'theme_custom_surface';
  static const _textKey = 'theme_custom_text';
  static const _primaryKey = 'theme_custom_primary';
  static const _accentKey = 'theme_custom_accent';
  static const _derivativeCardKey = 'theme_custom_derivative_card';

  @override
  Future<ThemeSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final presetIndex = prefs.getInt(_presetKey) ?? 0;
    final preset = ThemePreset.values[presetIndex.clamp(0, ThemePreset.values.length - 1)];
    final customColors = CustomColors(
      background: _readColor(prefs, _bgKey),
      surface: _readColor(prefs, _surfaceKey),
      text: _readColor(prefs, _textKey),
      primary: _readColor(prefs, _primaryKey),
      accent: _readColor(prefs, _accentKey),
      derivativeCard: _readColor(prefs, _derivativeCardKey),
    );
    return ThemeSettings(preset: preset, customColors: customColors);
  }

  Future<void> setPreset(ThemePreset preset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_presetKey, preset.index);
    final current = state.value ?? const ThemeSettings();
    state = AsyncData(ThemeSettings(preset: preset, customColors: current.customColors));
  }

  Future<void> setCustomColor(String key, Color? color) async {
    final prefs = await SharedPreferences.getInstance();
    if (color != null) {
      await prefs.setInt(key, color.toARGB32());
    } else {
      await prefs.remove(key);
    }
    final current = state.value ?? const ThemeSettings();
    final cc = current.customColors;
    final updated = switch (key) {
      _bgKey => cc.copyWith(background: () => color),
      _surfaceKey => cc.copyWith(surface: () => color),
      _textKey => cc.copyWith(text: () => color),
      _primaryKey => cc.copyWith(primary: () => color),
      _accentKey => cc.copyWith(accent: () => color),
      _derivativeCardKey => cc.copyWith(derivativeCard: () => color),
      _ => cc,
    };
    state = AsyncData(ThemeSettings(preset: current.preset, customColors: updated));
  }

  Future<void> setBackground(Color? c) => setCustomColor(_bgKey, c);
  Future<void> setSurface(Color? c) => setCustomColor(_surfaceKey, c);
  Future<void> setText(Color? c) => setCustomColor(_textKey, c);
  Future<void> setPrimary(Color? c) => setCustomColor(_primaryKey, c);
  Future<void> setAccent(Color? c) => setCustomColor(_accentKey, c);

  Future<void> setDerivativeCard(Color? c) => setCustomColor(_derivativeCardKey, c);

  Future<void> resetCustomColors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bgKey);
    await prefs.remove(_surfaceKey);
    await prefs.remove(_textKey);
    await prefs.remove(_primaryKey);
    await prefs.remove(_accentKey);
    await prefs.remove(_derivativeCardKey);
    final current = state.value ?? const ThemeSettings();
    state = AsyncData(ThemeSettings(preset: current.preset));
  }

  Color? _readColor(SharedPreferences prefs, String key) {
    final val = prefs.getInt(key);
    return val != null ? Color(val) : null;
  }
}

final themeSettingsProvider =
    AsyncNotifierProvider<ThemeSettingsNotifier, ThemeSettings>(ThemeSettingsNotifier.new);

// Font scale
class FontScaleNotifier extends AsyncNotifier<double> {
  static const _key = 'font_scale';

  @override
  Future<double> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_key) ?? 1.0;
  }

  Future<void> set(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, scale);
    state = AsyncData(scale);
  }
}

final fontScaleProvider =
    AsyncNotifierProvider<FontScaleNotifier, double>(FontScaleNotifier.new);
