import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Regression guard for the "URL does not change on navigation" bug.
///
/// go_router's imperative `push` navigates the widget stack but does NOT
/// update the browser-visible location, which made dictionary entries
/// unshareable. Entry navigation must use `go` so the address bar reflects
/// `/entry/<word>`. This test pins that behavior.
void main() {
  GoRouter makeRouter() => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, _) => const Scaffold(body: Text('home'))),
          GoRoute(
            path: '/entry/:word',
            builder: (_, state) =>
                Scaffold(body: Text('entry ${state.pathParameters['word']}')),
          ),
        ],
      );

  String loc(GoRouter r) => r.routerDelegate.currentConfiguration.uri.toString();

  testWidgets('go updates the location (entries are shareable)', (tester) async {
    final router = makeRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    router.go('/entry/kataba');
    await tester.pumpAndSettle();

    expect(loc(router), '/entry/kataba');
    expect(find.text('entry kataba'), findsOneWidget);
  });

  testWidgets('push does NOT update the location (why we use go)', (tester) async {
    final router = makeRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    router.push('/entry/kataba');
    await tester.pumpAndSettle();

    // Documents the root cause: push navigates but leaves the URL at '/'.
    expect(loc(router), '/');
  });
}
