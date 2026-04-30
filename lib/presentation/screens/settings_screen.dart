import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/constrained_body.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final searchBarBottom = ref.watch(searchBarBottomProvider).value ?? false;
    final cs = Theme.of(context).colorScheme;

    final toolbar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          const Expanded(
            child: Text('Settings',
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
        Text('Appearance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.primary)),
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
        Text('Layout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.primary)),
        const SizedBox(height: 8),
        Card(
          child: SwitchListTile(
            title: const Text('Search bar at bottom'),
            subtitle: const Text('Move search bar and controls to the bottom of the screen'),
            secondary: const Icon(Icons.vertical_align_bottom),
            value: searchBarBottom,
            onChanged: (_) => ref.read(searchBarBottomProvider.notifier).toggle(),
          ),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: ConstrainedBody(
          child: Column(
            children: searchBarBottom
                ? [Expanded(child: body), const Divider(height: 1), toolbar]
                : [toolbar, const Divider(height: 1), Expanded(child: body)],
          ),
        ),
      ),
    );
  }
}
