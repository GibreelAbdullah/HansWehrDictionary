import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dictionary_providers.dart';
import '../providers/theme_provider.dart';
import '../widgets/constrained_body.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchBarBottom = ref.watch(searchBarBottomProvider).value ?? false;
    final fontScale = ref.watch(fontScaleProvider).value ?? 1.0;
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
                context.go('/');
              }
            },
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
        // 1. Search Bar Position
        Card(
          child: SwitchListTile(
            title: const Text('Search bar at bottom'),
            subtitle: const Text('Move search bar to the bottom of the screen'),
            secondary: const Icon(Icons.vertical_align_bottom),
            value: searchBarBottom,
            onChanged: (_) => ref.read(searchBarBottomProvider.notifier).toggle(),
          ),
        ),
        const SizedBox(height: 12),

        // 2. Font Size
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.format_size, color: cs.onSurfaceVariant),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Font Size', style: TextStyle(fontSize: 16))),
                    Text('${(fontScale * 100).round()}%',
                        style: TextStyle(fontSize: 14, color: cs.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: fontScale,
                  min: 0.7,
                  max: 1.5,
                  divisions: 16,
                  label: '${(fontScale * 100).round()}%',
                  onChanged: (v) => ref.read(fontScaleProvider.notifier).set(v),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('A', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                    if (fontScale != 1.0)
                      GestureDetector(
                        onTap: () => ref.read(fontScaleProvider.notifier).set(1.0),
                        child: Text('Reset', style: TextStyle(fontSize: 12, color: cs.primary)),
                      ),
                    Text('A', style: TextStyle(fontSize: 20, color: cs.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 3. Theme
        Card(
          child: ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            subtitle: const Text('Colors, dark mode, and advanced customization'),
            trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            onTap: () => context.go('/settings/theme'),
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
