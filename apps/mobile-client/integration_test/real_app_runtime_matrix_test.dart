import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:beauteavenue_mobile_client/main.dart' as app;
import 'package:beauteavenue_mobile_client/src/core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/constants/storage_keys.dart';
import 'package:beauteavenue_mobile_client/src/core/diagnostics/app_runtime_diagnostics.dart';
import 'package:beauteavenue_mobile_client/src/core/storage/app_cache.dart';
import 'package:beauteavenue_mobile_client/src/core/storage/secure_storage.dart';

class _ScenarioResult {
  const _ScenarioResult({
    required this.label,
    required this.httpRequests,
    required this.duplicateInFlight,
    required this.providerRecomputations,
    required this.totalFrames,
    required this.uiJankyFrames,
    required this.rasterJankyFrames,
    required this.p95BuildMs,
    required this.p95RasterMs,
    required this.memoryBeforeBytes,
    required this.memoryAfterBytes,
    required this.profileBranchSurface,
    required this.freezeReproduced,
  });

  final String label;
  final int httpRequests;
  final int duplicateInFlight;
  final int providerRecomputations;
  final int totalFrames;
  final int uiJankyFrames;
  final int rasterJankyFrames;
  final int p95BuildMs;
  final int p95RasterMs;
  final int memoryBeforeBytes;
  final int memoryAfterBytes;
  final String profileBranchSurface;
  final bool freezeReproduced;
}

Finder _tabFinder(String tab) {
  switch (tab) {
    case 'discover':
      final keyed = find.byKey(const ValueKey('bottom-tab-discover'));
      return keyed.evaluate().isNotEmpty
          ? keyed
          : find.text(AppStrings.discoverTab).last;
    case 'bookings':
      final keyed = find.byKey(const ValueKey('bottom-tab-bookings'));
      return keyed.evaluate().isNotEmpty
          ? keyed
          : find.text(AppStrings.bookingsTab).last;
    case 'profile':
      final keyed = find.byKey(const ValueKey('bottom-tab-profile'));
      return keyed.evaluate().isNotEmpty
          ? keyed
          : find.text(AppStrings.profileTab).last;
    default:
      throw ArgumentError.value(tab, 'tab', 'Unsupported tab id');
  }
}

Future<void> _tapTab(
  WidgetTester tester,
  String tab, {
  Duration settle = const Duration(seconds: 8),
}) async {
  await tester.tap(_tabFinder(tab));
  await tester.pumpAndSettle(settle);
}

Future<void> _ensureAuthenticatedSession() async {
  await AppCache.init();
  await AppCache.settings.put(StorageKeys.onboardingCompleted, true);
  await AppCache.settings.put('location_prompt_count', 5);
  await AppCache.settings.put('location_just_registered', false);
  final storage = SecureStorage();
  final accessToken = await storage.read(StorageKeys.accessToken);
  final userId = await storage.read(StorageKeys.userId);
  if (accessToken == null || userId == null) {
    fail(
      'Authenticated simulator session required. '
      'Log into the real app first, then rerun this integration test.',
    );
  }
}

Future<void> _clearRuntimeCaches() async {
  await AppCache.init();
  await AppCache.salons.clear();
  await AppCache.bookings.clear();
  await AppCache.profile.clear();
  imageCache.clear();
  imageCache.clearLiveImages();
}

Future<void> _launchRealApp(
  WidgetTester tester,
  DiagnosticsConfig config,
) async {
  AppRuntimeDiagnostics.reset(label: config.label);
  AppRuntimeDiagnostics.updateConfig(config);
  app.main();
  await tester.pumpAndSettle(const Duration(seconds: 8));
  await _dismissStartupSurfaces(tester);
  await tester.pumpAndSettle(const Duration(seconds: 4));
}

Future<void> _assertNotOnAuthOrBootstrap(WidgetTester tester) async {
  expect(find.text(AppStrings.authTitle), findsNothing);
  expect(find.text(AppStrings.profileBootstrapTitle), findsNothing);
}

Future<void> _dismissStartupSurfaces(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    var handled = false;

    final onboardingSkip = find.text(AppStrings.onboardingSkip);
    if (onboardingSkip.evaluate().isNotEmpty) {
      await tester.tap(onboardingSkip.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      handled = true;
    }

    final locationLater = find.text('Plus tard');
    if (!handled && locationLater.evaluate().isNotEmpty) {
      await tester.tap(locationLater.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      handled = true;
    }

    final bootstrapSkip = find.text(AppStrings.bootstrapSkip);
    if (!handled && bootstrapSkip.evaluate().isNotEmpty) {
      await tester.tap(bootstrapSkip.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      handled = true;
    }

    final cancelDialog = find.text('Annuler');
    if (!handled && cancelDialog.evaluate().isNotEmpty) {
      await tester.tap(cancelDialog.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      handled = true;
    }

    if (!handled) {
      break;
    }
  }
}

Future<void> _waitForHomeReady(WidgetTester tester) async {
  bool hasHomeChrome() {
    final hasTitle = find.text(AppStrings.appTitle).evaluate().isNotEmpty;
    final hasSearchHint =
        find.text(AppStrings.searchHint).evaluate().isNotEmpty ||
        find.text(AppStrings.searchHintDetailed).evaluate().isNotEmpty;
    final hasDiscoverTab =
        find.byKey(const ValueKey('bottom-tab-discover')).evaluate().isNotEmpty ||
        find.text(AppStrings.discoverTab).evaluate().isNotEmpty;
    return hasTitle && hasSearchHint && hasDiscoverTab;
  }

  await _dismissStartupSurfaces(tester);

  if (!hasHomeChrome()) {
    await _tapTab(tester, 'discover');
  }
  await _dismissStartupSurfaces(tester);
  await tester.pumpAndSettle(const Duration(seconds: 10));
  expect(hasHomeChrome(), isTrue);
  await _assertNotOnAuthOrBootstrap(tester);
}

Future<void> _openBookingsReady(WidgetTester tester) async {
  await _tapTab(tester, 'bookings');
  expect(find.text(AppStrings.bookingsPageHeading), findsOneWidget);
  await _assertNotOnAuthOrBootstrap(tester);
}

Future<String> _openProfileReady(WidgetTester tester) async {
  await _tapTab(tester, 'profile');
  await _assertNotOnAuthOrBootstrap(tester);
  if (find.text('Déconnexion').evaluate().isNotEmpty) {
    return 'profile';
  }
  if (find.text(AppStrings.paymentMethodsTitle).evaluate().isNotEmpty) {
    return 'payment-methods';
  }
  fail('Profile branch did not open ProfilePage or PaymentMethodsPage.');
}

Future<String> _warmRootTabs(WidgetTester tester) async {
  await _waitForHomeReady(tester);
  await _openBookingsReady(tester);
  final profileBranchSurface = await _openProfileReady(tester);
  await _tapTab(tester, 'discover', settle: const Duration(seconds: 6));
  expect(find.text(AppStrings.appTitle), findsWidgets);
  return profileBranchSurface;
}

Future<_ScenarioResult> _runTabSequence(
  WidgetTester tester, {
  required String label,
  required String profileBranchSurface,
}) async {
  AppRuntimeDiagnostics.reset(label: label);
  final memoryBeforeBytes = AppRuntimeDiagnostics.currentMemoryRssBytes();
  const sequence = <String>['discover', 'bookings', 'profile'];

  var freezeReproduced = false;
  for (var i = 0; i < 20; i++) {
    for (final tab in sequence) {
      await tester.tap(_tabFinder(tab));
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 80));
      if (tester.takeException() != null) {
        freezeReproduced = true;
      }
    }
  }

  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle(const Duration(seconds: 5));

  final summaries = AppRuntimeDiagnostics.requestSummaries();
  final frameSummary = AppRuntimeDiagnostics.frameTimingSummary();
  final memoryAfterBytes = AppRuntimeDiagnostics.currentMemoryRssBytes();
  final httpRequests = summaries.fold<int>(0, (sum, item) => sum + item.total);
  final duplicateInFlight = summaries.fold<int>(
    0,
    (sum, item) => sum + item.duplicateWhileInFlight,
  );
  final providerRecomputations = AppRuntimeDiagnostics.providerMetrics.values
      .fold<int>(0, (sum, item) => sum + item.recomputations);

  developer.log(
    'Scenario $label summaries:\n'
    '${summaries.map((s) => '${s.key} total=${s.total} dup=${s.duplicateWhileInFlight} p50=${s.p50Ms} p95=${s.p95Ms}').join('\n')}',
    name: 'matrix',
  );
  debugPrint(
    'MATRIX|$label|profile=$profileBranchSurface|requests=$httpRequests|dup=$duplicateInFlight|'
    'providers=$providerRecomputations|frames=${frameSummary.totalFrames}|uiJank=${frameSummary.uiJankyFrames}|'
    'rasterJank=${frameSummary.rasterJankyFrames}|p95Build=${frameSummary.p95BuildMs}|'
    'p95Raster=${frameSummary.p95RasterMs}|memoryBefore=$memoryBeforeBytes|memoryAfter=$memoryAfterBytes|'
    'transient=${AppRuntimeDiagnostics.transientCallbackCount}|freeze=$freezeReproduced',
  );

  return _ScenarioResult(
    label: label,
    httpRequests: httpRequests,
    duplicateInFlight: duplicateInFlight,
    providerRecomputations: providerRecomputations,
    totalFrames: frameSummary.totalFrames,
    uiJankyFrames: frameSummary.uiJankyFrames,
    rasterJankyFrames: frameSummary.rasterJankyFrames,
    p95BuildMs: frameSummary.p95BuildMs,
    p95RasterMs: frameSummary.p95RasterMs,
    memoryBeforeBytes: memoryBeforeBytes,
    memoryAfterBytes: memoryAfterBytes,
    profileBranchSurface: profileBranchSurface,
    freezeReproduced: freezeReproduced,
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('real app runtime matrix', () {
    testWidgets('scenario A cold cache, real network', (tester) async {
      await _ensureAuthenticatedSession();
      await _clearRuntimeCaches();
      await _launchRealApp(
        tester,
        const DiagnosticsConfig(label: 'A-cold-network'),
      );
      await _waitForHomeReady(tester);
      await _openBookingsReady(tester);
      final profileBranchSurface = await _openProfileReady(tester);
      final result = await _runTabSequence(
        tester,
        label: 'A-cold-network',
        profileBranchSurface: profileBranchSurface,
      );
      developer.log(
        'A | ${result.httpRequests} | ${result.duplicateInFlight} | ${result.providerRecomputations} | '
        'frames=${result.totalFrames} | uiJank=${result.uiJankyFrames} | rasterJank=${result.rasterJankyFrames} | '
        'p95Build=${result.p95BuildMs} | p95Raster=${result.p95RasterMs} | '
        'memory=${result.memoryBeforeBytes}->${result.memoryAfterBytes} | '
        'profile=${result.profileBranchSurface} | freeze=${result.freezeReproduced}',
        name: 'matrix',
      );
    });

    testWidgets('scenario B warm cache, real network', (tester) async {
      await _ensureAuthenticatedSession();
      await _launchRealApp(
        tester,
        const DiagnosticsConfig(label: 'B-warm-network'),
      );
      final profileBranchSurface = await _warmRootTabs(tester);
      final result = await _runTabSequence(
        tester,
        label: 'B-warm-network',
        profileBranchSurface: profileBranchSurface,
      );
      developer.log(
        'B | ${result.httpRequests} | ${result.duplicateInFlight} | ${result.providerRecomputations} | '
        'frames=${result.totalFrames} | uiJank=${result.uiJankyFrames} | rasterJank=${result.rasterJankyFrames} | '
        'p95Build=${result.p95BuildMs} | p95Raster=${result.p95RasterMs} | '
        'memory=${result.memoryBeforeBytes}->${result.memoryAfterBytes} | '
        'profile=${result.profileBranchSurface} | freeze=${result.freezeReproduced}',
        name: 'matrix',
      );
    });

    testWidgets('scenario C warm cache, blocked network', (tester) async {
      await _ensureAuthenticatedSession();
      await _launchRealApp(
        tester,
        const DiagnosticsConfig(label: 'C-warm-network'),
      );
      final profileBranchSurface = await _warmRootTabs(tester);
      AppRuntimeDiagnostics.updateConfig(
        AppRuntimeDiagnostics.config.copyWith(
          label: 'C-blocked-network',
          blockNetworkRequests: true,
        ),
      );
      final result = await _runTabSequence(
        tester,
        label: 'C-blocked-network',
        profileBranchSurface: profileBranchSurface,
      );
      developer.log(
        'C | ${result.httpRequests} | ${result.duplicateInFlight} | ${result.providerRecomputations} | '
        'frames=${result.totalFrames} | uiJank=${result.uiJankyFrames} | rasterJank=${result.rasterJankyFrames} | '
        'p95Build=${result.p95BuildMs} | p95Raster=${result.p95RasterMs} | '
        'memory=${result.memoryBeforeBytes}->${result.memoryAfterBytes} | '
        'profile=${result.profileBranchSurface} | freeze=${result.freezeReproduced}',
        name: 'matrix',
      );
    });

    testWidgets('scenario F forced Dakar, location disabled', (tester) async {
      await _ensureAuthenticatedSession();
      await _launchRealApp(
        tester,
        const DiagnosticsConfig(
          label: 'F-fixed-location',
          forceLocationLabel: 'Dakar',
          forceDisableLocation: true,
        ),
      );
      final profileBranchSurface = await _warmRootTabs(tester);
      final result = await _runTabSequence(
        tester,
        label: 'F-fixed-location',
        profileBranchSurface: profileBranchSurface,
      );
      developer.log(
        'F | ${result.httpRequests} | ${result.duplicateInFlight} | ${result.providerRecomputations} | '
        'frames=${result.totalFrames} | uiJank=${result.uiJankyFrames} | rasterJank=${result.rasterJankyFrames} | '
        'p95Build=${result.p95BuildMs} | p95Raster=${result.p95RasterMs} | '
        'memory=${result.memoryBeforeBytes}->${result.memoryAfterBytes} | '
        'profile=${result.profileBranchSurface} | freeze=${result.freezeReproduced}',
        name: 'matrix',
      );
    });

    testWidgets('scenario G stock navigation bar', (tester) async {
      await _ensureAuthenticatedSession();
      await _launchRealApp(
        tester,
        const DiagnosticsConfig(
          label: 'G-stock-nav',
          useStockNavigationBar: true,
        ),
      );
      final profileBranchSurface = await _warmRootTabs(tester);
      final result = await _runTabSequence(
        tester,
        label: 'G-stock-nav',
        profileBranchSurface: profileBranchSurface,
      );
      developer.log(
        'G | ${result.httpRequests} | ${result.duplicateInFlight} | ${result.providerRecomputations} | '
        'frames=${result.totalFrames} | uiJank=${result.uiJankyFrames} | rasterJank=${result.rasterJankyFrames} | '
        'p95Build=${result.p95BuildMs} | p95Raster=${result.p95RasterMs} | '
        'memory=${result.memoryBeforeBytes}->${result.memoryAfterBytes} | '
        'profile=${result.profileBranchSurface} | freeze=${result.freezeReproduced}',
        name: 'matrix',
      );
    });
  });
}
