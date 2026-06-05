import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/migration.dart';
import 'data/database_init.dart' as db_init;
import 'presentation/providers/db_update_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/router.dart';
import 'presentation/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    final dbReady = ref.watch(dbReadyProvider);
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
        if (!kIsWeb) return scaled;
        return dbReady.when(
          data: (_) => scaled,
          loading: () => const _DbLoadingScreen(),
          error: (e, _) => _DbErrorScreen(error: e),
        );
      },
    );
  }
}

class _DbLoadingScreen extends StatelessWidget {
  const _DbLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hans Wehr Dictionary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87, decoration: TextDecoration.none),
              ),
              SizedBox(height: 24),
              SizedBox(width: 200, child: LinearProgressIndicator()),
              SizedBox(height: 12),
              Text(
                'Loading dictionary…',
                style: TextStyle(fontSize: 14, color: Colors.black54, decoration: TextDecoration.none),
              ),
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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load dictionary:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.red, decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    );
  }
}
