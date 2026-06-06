import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Build a testable widget tree with [MaterialApp] + [Scaffold].
/// Suitable for isolated widgets that don't need routing or Riverpod.
Widget buildTestableWidget(
  Widget child, {
  ThemeData? theme,
  bool scaffold = true,
}) {
  GoogleFonts.config.allowRuntimeFetching = false;

  return ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) {
      return MaterialApp(
        theme: theme ?? ThemeData(useMaterial3: true),
        home: scaffold ? Scaffold(body: child) : child,
      );
    },
  );
}

/// Build a testable widget tree with [GoRouter] at the given [path].
/// The [builder] receives the [BuildContext] which has GoRouterState available.
/// Use this for pages like [AuthChoicePage] that need GoRouter but not Riverpod.
///
/// For pages that also need Riverpod's [ProviderScope], wrap the result:
/// ```dart
/// ProviderScope(
///   overrides: [myProvider.overrideWithValue(myValue)],
///   child: buildTestableRouterWidget(...),
/// )
/// ```
Widget buildTestableRouterWidget(
  Widget Function(BuildContext) builder, {
  String path = '/',
  String initialLocation = '/',
  ThemeData? theme,
}) {
  GoogleFonts.config.allowRuntimeFetching = false;

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: path,
        builder: (context, state) => builder(context),
      ),
    ],
  );

  return ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) {
      return MaterialApp.router(
        routerConfig: router,
        theme: theme ?? ThemeData(useMaterial3: true),
      );
    },
  );
}
