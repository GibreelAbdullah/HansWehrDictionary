import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/dictionary_providers.dart';

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
            onPressed: () => Navigator.pop(context),
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
                          text: 'Dictionary of Modern Written Arabic',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
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
        child: Column(
          children: isBottom
              ? [Expanded(child: body), const Divider(height: 1), toolbar]
              : [toolbar, const Divider(height: 1), Expanded(child: body)],
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
