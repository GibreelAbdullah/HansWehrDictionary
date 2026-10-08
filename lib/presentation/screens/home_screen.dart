import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/dictionary_providers.dart';
import '../providers/db_update_provider.dart';
import '../widgets/search_bar.dart';
import '../widgets/constrained_body.dart';

class HomeShell extends ConsumerWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottom = ref.watch(searchBarBottomProvider).value ?? false;
    final location = GoRouterState.of(context).uri.path;
    final isHome = location == '/';

    const searchBar = DictionarySearchBar();
    final content = Expanded(child: child);

    return Scaffold(
      drawer: const _AppDrawer(),
      body: SafeArea(
        child: ConstrainedBody(
          child: Stack(
            children: [
              Column(
                children: isBottom
                    ? [content, const Divider(height: 1), searchBar]
                    : [searchBar, const Divider(height: 1), content],
              ),
              Positioned(
                bottom: isBottom ? 12 : null,
                top: isBottom ? null : 12,
                left: 0,
                child: isHome
                    ? Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (GoRouter.of(context).canPop()) {
                            context.pop();
                          } else {
                            context.go('/');
                          }
                        },
                      ),
              ),
              Positioned(
                bottom: isBottom ? 12 : null,
                top: isBottom ? null : 12,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    ref.read(searchQueryProvider.notifier).set('');
                    context.go('/');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Hans Wehr',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DISCLAIMER - Not 100% Accurate.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onErrorContainer)),
                    const SizedBox(height: 4),
                    Text(
                        'Text was extracted from scanned pages and has many errors which unfortunately is not possible to fix manually.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onErrorContainer)),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://arabicstudentsdictionary.com/')),
                      child: Text('Try Arabic Students Dictionary for corrected text.',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Introduction'),
              onTap: () {
                Navigator.pop(context);
                context.push('/introduction');
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_list_numbered),
              title: const Text('Verb Forms'),
              onTap: () {
                Navigator.pop(context);
                context.push('/verb-forms');
              },
            ),
            ListTile(
              leading: const Icon(Icons.short_text),
              title: const Text('Abbreviations'),
              onTap: () {
                Navigator.pop(context);
                context.push('/abbreviations');
              },
            ),
            ListTile(
              leading: const Icon(Icons.translate),
              title: const Text('Transliteration'),
              onTap: () {
                Navigator.pop(context);
                context.push('/transliteration');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App v${const String.fromEnvironment('APP_VERSION', defaultValue: 'dev')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Dictionary v${ref.watch(dbVersionProvider).value ?? '…'}',
                      children: [
                        if (!kIsWeb)
                          if (ref.watch(dbUpdateProvider).value case final info?)
                            TextSpan(
                              text: ' (v${info.remoteVersion} available)',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            ),
                      ],
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}