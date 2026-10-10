import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'data/db_progress.dart';
import 'data/migration.dart';
import 'data/database_init.dart' as db_init;
import 'presentation/providers/db_update_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/router.dart';
import 'presentation/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) usePathUrlStrategy();
  db_init.initDatabaseFactory();
  await migrateFromOldApp();
  runApp(const ProviderScope(child: HansWehrApp()));
}

class HansWehrApp extends ConsumerWidget {
  const HansWehrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);
    final themeSettings = ref.watch(themeSettingsProvider).value ?? const ThemeSettings();
    final fontScale = ref.watch(fontScaleProvider).value ?? 1.0;
    final appFont = ref.watch(appFontProvider).value ?? AppFont.system;
    return MaterialApp.router(
      title: 'Hans Wehr Dictionary',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildLight(themeSettings, font: appFont),
      darkTheme: AppTheme.buildDark(themeSettings, font: appFont),
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        final scaled = MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(fontScale),
          ),
          child: child!,
        );
        // On web the SQLite DB must be fetched/opened before any screen can
        // query it. Gate the UI *inside* the router's builder so the router
        // (and the deep-link URL, e.g. /entry/<word>) stays mounted the whole
        // time. Swapping in a separate MaterialApp here would reset the browser
        // location to "/" and make shared links unusable.
        if (!kIsWeb) return scaled;
        final dbReady = ref.watch(dbReadyProvider);
        return dbReady.when(
          data: (_) => scaled,
          loading: () => const _DbLoadingScreen(),
          error: (e, _) => _DbErrorScreen(error: e),
        );
      },
    );
  }
}

class _DbLoadingScreen extends StatefulWidget {
  const _DbLoadingScreen();

  @override
  State<_DbLoadingScreen> createState() => _DbLoadingScreenState();
}

class _DbLoadingScreenState extends State<_DbLoadingScreen> {
  bool _isDownloading = false;
  double _progress = 0.0;
  StreamSubscription<double>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = dbDownloadProgress.stream.listen((p) {
      if (mounted) {
        setState(() {
          _isDownloading = true;
          _progress = p;
        });
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hans Wehr Dictionary',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              if (_isDownloading) ...[
                const Text('Downloading dictionary...'),
                const SizedBox(height: 24),
                LinearProgressIndicator(
                  value: _progress > 0 ? _progress.clamp(0.0, 1.0) : null,
                ),
                const SizedBox(height: 12),
                Text(
                  '${(_progress.clamp(0.0, 1.0) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 14),
                ),
              ] else ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DbErrorScreen extends StatelessWidget {
  final Object error;
  const _DbErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Failed to load dictionary:\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
