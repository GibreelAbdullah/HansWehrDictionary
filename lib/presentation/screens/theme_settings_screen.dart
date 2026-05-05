import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dictionary_providers.dart';
import '../providers/theme_provider.dart';
import '../widgets/constrained_body.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeSettings = ref.watch(themeSettingsProvider).value ?? const ThemeSettings();
    final isBottom = ref.watch(searchBarBottomProvider).value ?? false;
    final cs = Theme.of(context).colorScheme;

    final toolbar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                context.go('/settings');
              }
            },
          ),
          const Expanded(
            child: Text('Theme',
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
        // Theme Mode
        Text('Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.primary)),
        const SizedBox(height: 8),
        Card(
          child: RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).set(v ?? ThemeMode.system),
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System default'),
                  secondary: const Icon(Icons.settings_brightness),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  secondary: const Icon(Icons.light_mode),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  secondary: const Icon(Icons.dark_mode),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Color Preset
        Text('Color Scheme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.primary)),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ThemePreset.values.map((preset) {
                final isSelected = themeSettings.preset == preset;
                return GestureDetector(
                  onTap: () => ref.read(themeSettingsProvider.notifier).setPreset(preset),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: preset.color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: cs.onSurface, width: 3)
                              : null,
                          boxShadow: isSelected
                              ? [BoxShadow(color: preset.color.withAlpha(100), blurRadius: 8)]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                      const SizedBox(height: 4),
                      Text(preset.label, style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Advanced Colors
        Text('Advanced Colors', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.primary)),
        const SizedBox(height: 4),
        Text('Tap to change, long-press to reset.',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              _ColorTile(
                label: 'Background',
                icon: Icons.format_paint,
                color: themeSettings.customColors.background,
                defaultColor: cs.surface,
                onChanged: (c) => ref.read(themeSettingsProvider.notifier).setBackground(c),
              ),
              _ColorTile(
                label: 'Surface',
                icon: Icons.layers,
                color: themeSettings.customColors.surface,
                defaultColor: cs.surfaceContainerHighest,
                onChanged: (c) => ref.read(themeSettingsProvider.notifier).setSurface(c),
              ),
              _ColorTile(
                label: 'Text',
                icon: Icons.text_fields,
                color: themeSettings.customColors.text,
                defaultColor: cs.onSurface,
                onChanged: (c) => ref.read(themeSettingsProvider.notifier).setText(c),
              ),
              _ColorTile(
                label: 'Primary',
                icon: Icons.color_lens,
                color: themeSettings.customColors.primary,
                defaultColor: cs.primary,
                onChanged: (c) => ref.read(themeSettingsProvider.notifier).setPrimary(c),
              ),
              _ColorTile(
                label: 'Accent',
                icon: Icons.palette,
                color: themeSettings.customColors.accent,
                defaultColor: cs.secondary,
                onChanged: (c) => ref.read(themeSettingsProvider.notifier).setAccent(c),
              ),
              _ColorTile(
                label: 'Derivative Card',
                icon: Icons.subtitles,
                color: themeSettings.customColors.derivativeCard,
                defaultColor: cs.surfaceContainerLow,
                onChanged: (c) => ref.read(themeSettingsProvider.notifier).setDerivativeCard(c),
              ),
            ],
          ),
        ),
        if (themeSettings.customColors.hasAny) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.restart_alt, size: 18),
              label: const Text('Reset all custom colors'),
              onPressed: () => ref.read(themeSettingsProvider.notifier).resetCustomColors(),
            ),
          ),
        ],
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

class _ColorTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final Color defaultColor;
  final ValueChanged<Color?> onChanged;

  const _ColorTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.defaultColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? defaultColor;
    final isCustom = color != null;
    return ListTile(
      leading: Icon(icon, color: displayColor),
      title: Text(label),
      subtitle: isCustom ? Text('Custom', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)) : null,
      trailing: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: displayColor,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
      ),
      onTap: () => _showColorPicker(context, displayColor),
      onLongPress: isCustom ? () => onChanged(null) : null,
    );
  }

  Future<void> _showColorPicker(BuildContext context, Color initial) async {
    final picked = await showDialog<Color>(
      context: context,
      builder: (ctx) => _ColorPickerDialog(initialColor: initial),
    );
    if (picked != null) onChanged(picked);
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late HSVColor _hsv;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.initialColor);
  }

  @override
  Widget build(BuildContext context) {
    final color = _hsv.toColor();
    return AlertDialog(
      title: const Text('Pick a color'),
      content: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            _SliderRow(
              label: 'Hue',
              value: _hsv.hue,
              max: 360,
              activeColor: color,
              onChanged: (v) => setState(() => _hsv = _hsv.withHue(v)),
            ),
            _SliderRow(
              label: 'Saturation',
              value: _hsv.saturation * 100,
              max: 100,
              activeColor: color,
              onChanged: (v) => setState(() => _hsv = _hsv.withSaturation(v / 100)),
            ),
            _SliderRow(
              label: 'Brightness',
              value: _hsv.value * 100,
              max: 100,
              activeColor: color,
              onChanged: (v) => setState(() => _hsv = _hsv.withValue(v / 100)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickColors.map((c) => GestureDetector(
                onTap: () => setState(() => _hsv = HSVColor.fromColor(c)),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.5),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, color), child: const Text('Select')),
      ],
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.max,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 12))),
        Expanded(
          child: Slider(
            value: value,
            max: max,
            activeColor: activeColor,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

const _quickColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.amber,
  Colors.orange,
  Colors.brown,
  Colors.blueGrey,
  Colors.black,
  Colors.white,
];
