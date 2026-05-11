import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Donate')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Icon(Icons.volunteer_activism, size: 48, color: cs.primary),
            const SizedBox(height: 16),
            Text(
              'Your generosity matters',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Millions are facing a devastating crisis and previously unimaginable hardship, persecution and genocide. Your contribution, no matter how small, can make a difference.',
              style: textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            _CharityCard(
              name: 'Sadaqa',
              url: 'https://sadaqa.org.au/',
              color: cs.primary,
            ),
            const SizedBox(height: 10),
            _CharityCard(
              name: 'IDRF',
              url: 'https://idrf.ca/',
              color: cs.tertiary,
            ),
            const SizedBox(height: 10),
            _CharityCard(
              name: 'Miles2Smile',
              url: 'https://miles2smile.org/',
              color: cs.secondary,
            ),
            const SizedBox(height: 36),
            Divider(color: cs.outlineVariant),
            const SizedBox(height: 24),
            Text(
              'مَّن ذَا ٱلَّذِى يُقْرِضُ ٱللَّهَ قَرْضًا حَسَنًۭا فَيُضَـٰعِفَهُۥ لَهُۥٓ أَضْعَافًۭا كَثِيرَةًۭ ۚ وَٱللَّهُ يَقْبِضُ وَيَبْصُۜطُ وَإِلَيْهِ تُرْجَعُونَ',
              style: textTheme.titleLarge?.copyWith(height: 2),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(
              '(سورة البقرة - 2:245)',
              style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            Text(
              'Who will lend to Allah a good loan which Allah will multiply many times over? It is Allah alone who decreases and increases wealth. And to Him you will all be returned. (Al Baqarah 2:245)',
              style: textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }
}

class _CharityCard extends StatelessWidget {
  final String name;
  final String url;
  final Color color;

  const _CharityCard({required this.name, required this.url, required this.color});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => launchUrl(Uri.parse(url)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(width: 8),
          Icon(Icons.open_in_new, size: 16, color: color),
        ],
      ),
    );
  }
}
