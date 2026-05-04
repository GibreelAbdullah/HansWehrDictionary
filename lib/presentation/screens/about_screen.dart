import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/constrained_body.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                context.go('/');
              }
            },
          ),
          const Expanded(
            child: Text('About',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );

    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // About
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(children: [
                      const TextSpan(text: 'The '),
                      TextSpan(
                          text: 'Hans Wehr Dictionary of Modern Written Arabic',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface)),
                      const TextSpan(text: ' is an Arabic-English dictionary compiled by '),
                    ]),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _link('Hans Wehr', 'https://en.wikipedia.org/wiki/Hans_Wehr', cs),
                      Text(' and edited by ',
                          style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant)),
                      _link('J Milton Cowan', 'https://en.wikipedia.org/wiki/J_Milton_Cowan', cs),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Source Code
          Card(
            child: InkWell(
              onTap: () => launchUrl(Uri.parse('https://github.com/GibreelAbdullah/HansWehrDictionary')),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Source Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: cs.primary, decoration: TextDecoration.underline)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Available On
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('AVAILABLE ON',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15, color: cs.onSurface)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _platforms.map((p) => _PlatformChip(platform: p)).toList(),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('CONTACT ME',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15, color: cs.onSurface)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse('mailto:gibreel.khan@gmail.com')),
                    child: Text('gibreel.khan@gmail.com',
                        style: TextStyle(
                            fontSize: 14,
                            color: cs.primary,
                            decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Courtesy
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('COURTESY',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15, color: cs.onSurface)),
                  ),
                  const SizedBox(height: 12),
                  _courtesyItem(
                    cs,
                    'Jamal Osman and Muhammad Abdurrahman',
                    'https://github.com/jamalosman/hanswehr-app',
                    'for the digitisation of the dictionary.',
                  ),
                  const SizedBox(height: 8),
                  _courtesyItem(
                    cs,
                    'Quran.com',
                    'https://corpus.quran.com/',
                    'for their word-by-word breakdown of Quranic text.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget _link(String text, String url, ColorScheme cs) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Text(text,
          style: TextStyle(
              fontSize: 14, color: cs.primary, decoration: TextDecoration.underline)),
    );
  }

  Widget _courtesyItem(ColorScheme cs, String name, String url, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(color: cs.onSurfaceVariant)),
        Expanded(
          child: Wrap(
            children: [
              GestureDetector(
                onTap: () => launchUrl(Uri.parse(url)),
                child: Text(name,
                    style: TextStyle(
                        fontSize: 14, color: cs.primary, decoration: TextDecoration.underline)),
              ),
              Text(' $desc', style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

const _releaseUrl = 'https://github.com/GibreelAbdullah/HansWehrDictionary/releases/latest';

const _platforms = [
  (icon: Icons.android, label: 'Android', url: _releaseUrl),
  (icon: Icons.phone_iphone, label: 'iOS', url: _releaseUrl),
  (icon: Icons.language, label: 'Web', url: 'https://gibreelabdullah.github.io/HansWehrDictionary/'),
  (icon: Icons.desktop_windows, label: 'Windows', url: _releaseUrl),
  (icon: Icons.desktop_mac, label: 'macOS', url: _releaseUrl),
  (icon: Icons.computer, label: 'Linux', url: _releaseUrl),
];

class _PlatformChip extends StatelessWidget {
  final ({IconData icon, String label, String url}) platform;
  const _PlatformChip({required this.platform});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ActionChip(
      avatar: Icon(platform.icon, size: 18, color: cs.primary),
      label: Text(platform.label, style: const TextStyle(fontSize: 12)),
      onPressed: () => launchUrl(Uri.parse(platform.url)),
    );
  }
}
