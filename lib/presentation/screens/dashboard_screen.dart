import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/db_update_banner.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const DbUpdateBanner(),
          _Tile(
            icon: Icons.list,
            color: cs.primary,
            title: 'Browse',
            onTap: () => context.push('/browse'),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.menu_book,
            color: cs.tertiary,
            title: 'Quranic Words',
            onTap: () => context.push('/quranic-words'),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.favorite,
            color: cs.error,
            title: 'Favorites',
            onTap: () => context.push('/favorites'),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.history,
            color: cs.secondary,
            title: 'History',
            onTap: () => context.push('/history'),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.auto_stories,
            color: cs.tertiary,
            title: 'Read Hadith @ HadithHub',
            isExternal: true,
            onTap: () => launchUrl(Uri.parse('https://www.hadithhub.com/')),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.apps,
            color: cs.primary,
            title: 'Other Apps by Me',
            isExternal: true,
            onTap: () => launchUrl(Uri.parse('https://play.google.com/store/apps/developer?id=Gibreel+Abdullah')),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.volunteer_activism,
            color: cs.error,
            title: 'Donate',
            onTap: () => context.push('/donate'),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.info_outline,
            color: cs.onSurfaceVariant,
            title: 'About',
            onTap: () => context.push('/about'),
          ),
          const SizedBox(height: 12),
          const _RemoteMessage(),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;
  final bool isExternal;

  const _Tile({required this.icon, required this.color, required this.title, required this.onTap, this.isExternal = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
        trailing: Icon(isExternal ? Icons.open_in_new : Icons.chevron_right, color: cs.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}

class _RemoteMessage extends ConsumerWidget {
  const _RemoteMessage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final msg = ref.watch(remoteMessageProvider);
    return msg.when(
      data: (text) => text.isEmpty
          ? const SizedBox.shrink()
          : Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: MarkdownBody(
                  data: text,
                  onTapLink: (_, href, _) {
                    if (href != null) launchUrl(Uri.parse(href));
                  },
                ),
              ),
            ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
