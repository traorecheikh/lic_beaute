import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

const _requestInitiatorZoneKey = #requestInitiator;

bool get diagnosticsEnabled => kDebugMode || kProfileMode;

class DiagnosticsConfig {
  const DiagnosticsConfig({
    this.label = 'default',
    this.blockNetworkRequests = false,
    this.useStockNavigationBar = false,
    this.forceLocationLabel,
    this.forceDisableLocation = false,
    this.disableCustomNavAnimations = false,
    this.enableIOSNativeTabBar = false,
    this.enableIOSNativeSearchBar = false,
    this.enableIOSNativeIconButtons = false,
    this.enableIOSNativeGlass = false,
  });

  final String label;
  final bool blockNetworkRequests;
  final bool useStockNavigationBar;
  final String? forceLocationLabel;
  final bool forceDisableLocation;
  final bool disableCustomNavAnimations;

  // ── iOS 26+ native Liquid Glass feature flags ──────────────────────────
  /// When true and running on iOS 26+, replaces the Flutter bottom nav with
  /// a native [CNTabBar] (from cupertino_native_better).
  final bool enableIOSNativeTabBar;

  /// When true and running on iOS 26+, replaces the inline search control
  /// with a native [CNSearchBar].
  final bool enableIOSNativeSearchBar;

  /// When true and running on iOS 26+, converts icon action buttons
  /// (notification bell, back, share, etc.) to native [CNButton.icon]
  /// with Liquid Glass styling.
  final bool enableIOSNativeIconButtons;

  /// Master toggle that enables all iOS native glass features at once.
  /// Individual [enableIOSNative*] flags still take precedence when set.
  final bool enableIOSNativeGlass;

  DiagnosticsConfig copyWith({
    String? label,
    bool? blockNetworkRequests,
    bool? useStockNavigationBar,
    Object? forceLocationLabel = _sentinel,
    bool? forceDisableLocation,
    bool? disableCustomNavAnimations,
    bool? enableIOSNativeTabBar,
    bool? enableIOSNativeSearchBar,
    bool? enableIOSNativeIconButtons,
    bool? enableIOSNativeGlass,
  }) {
    return DiagnosticsConfig(
      label: label ?? this.label,
      blockNetworkRequests: blockNetworkRequests ?? this.blockNetworkRequests,
      useStockNavigationBar:
          useStockNavigationBar ?? this.useStockNavigationBar,
      forceLocationLabel: identical(forceLocationLabel, _sentinel)
          ? this.forceLocationLabel
          : forceLocationLabel as String?,
      forceDisableLocation: forceDisableLocation ?? this.forceDisableLocation,
      disableCustomNavAnimations:
          disableCustomNavAnimations ?? this.disableCustomNavAnimations,
      enableIOSNativeTabBar:
          enableIOSNativeTabBar ?? this.enableIOSNativeTabBar,
      enableIOSNativeSearchBar:
          enableIOSNativeSearchBar ?? this.enableIOSNativeSearchBar,
      enableIOSNativeIconButtons:
          enableIOSNativeIconButtons ?? this.enableIOSNativeIconButtons,
      enableIOSNativeGlass:
          enableIOSNativeGlass ?? this.enableIOSNativeGlass,
    );
  }
}

const _sentinel = Object();

class NavigationSnapshot {
  const NavigationSnapshot({
    required this.uri,
    required this.branchIndex,
    required this.tabSequence,
  });

  final String uri;
  final int branchIndex;
  final int tabSequence;
}

class ProviderEventRecord {
  const ProviderEventRecord({
    required this.timestamp,
    required this.provider,
    required this.event,
    required this.uri,
    required this.branchIndex,
    required this.tabSequence,
    this.detail,
  });

  final DateTime timestamp;
  final String provider;
  final String event;
  final String uri;
  final int branchIndex;
  final int tabSequence;
  final String? detail;
}

class ProviderMetrics {
  int added = 0;
  int updated = 0;
  int disposed = 0;
  int recomputations = 0;
  int loading = 0;
  int data = 0;
  int error = 0;
}

class RequestRunRecord {
  RequestRunRecord({
    required this.id,
    required this.method,
    required this.normalizedKey,
    required this.path,
    required this.query,
    required this.startedAt,
    required this.uri,
    required this.branchIndex,
    required this.tabSequence,
    required this.initiator,
    required this.duplicateInFlight,
  });

  final int id;
  final String method;
  final String normalizedKey;
  final String path;
  final Map<String, dynamic> query;
  final DateTime startedAt;
  final String uri;
  final int branchIndex;
  final int tabSequence;
  final String? initiator;
  final bool duplicateInFlight;
}

class RequestAggregate {
  int total = 0;
  int completed = 0;
  int failed = 0;
  int cancelled = 0;
  int duplicateWhileInFlight = 0;
  int cacheHits = 0;
  int maxConcurrent = 0;
  final List<int> durationsMs = <int>[];
}

class RequestSummary {
  const RequestSummary({
    required this.key,
    required this.total,
    required this.completed,
    required this.failed,
    required this.cancelled,
    required this.duplicateWhileInFlight,
    required this.cacheHits,
    required this.maxConcurrent,
    required this.p50Ms,
    required this.p95Ms,
  });

  final String key;
  final int total;
  final int completed;
  final int failed;
  final int cancelled;
  final int duplicateWhileInFlight;
  final int cacheHits;
  final int maxConcurrent;
  final int p50Ms;
  final int p95Ms;
}

class FrameTimingSummary {
  const FrameTimingSummary({
    required this.totalFrames,
    required this.uiJankyFrames,
    required this.rasterJankyFrames,
    required this.p50BuildMs,
    required this.p95BuildMs,
    required this.maxBuildMs,
    required this.p50RasterMs,
    required this.p95RasterMs,
    required this.maxRasterMs,
  });

  final int totalFrames;
  final int uiJankyFrames;
  final int rasterJankyFrames;
  final int p50BuildMs;
  final int p95BuildMs;
  final int maxBuildMs;
  final int p50RasterMs;
  final int p95RasterMs;
  final int maxRasterMs;
}

class AppRuntimeDiagnostics {
  AppRuntimeDiagnostics._();

  static DiagnosticsConfig config = const DiagnosticsConfig();

  static String _currentUri = '/';
  static int _currentBranchIndex = 0;
  static int _tabSequence = 0;

  static int _requestId = 0;
  static final Map<int, RequestRunRecord> _activeRequests =
      <int, RequestRunRecord>{};
  static final Map<String, int> _inFlightCounts = <String, int>{};
  static final Map<String, RequestAggregate> _requestAggregates =
      <String, RequestAggregate>{};
  static final Map<String, ProviderMetrics> _providerMetrics =
      <String, ProviderMetrics>{};
  static final List<ProviderEventRecord> _providerEvents =
      <ProviderEventRecord>[];
  static final List<String> _lifecycleEvents = <String>[];
  static final List<int> _buildFrameMicros = <int>[];
  static final List<int> _rasterFrameMicros = <int>[];
  static bool _frameCallbackInstalled = false;

  static NavigationSnapshot get navigation => NavigationSnapshot(
    uri: _currentUri,
    branchIndex: _currentBranchIndex,
    tabSequence: _tabSequence,
  );

  static void updateConfig(DiagnosticsConfig next) {
    config = next;
    ensureInitialized();
    logLifecycle('config=${next.label}');
  }

  static void reset({String? label}) {
    ensureInitialized();
    if (label != null) {
      config = config.copyWith(label: label);
    }
    _currentUri = '/';
    _currentBranchIndex = 0;
    _tabSequence = 0;
    _requestId = 0;
    _activeRequests.clear();
    _inFlightCounts.clear();
    _requestAggregates.clear();
    _providerMetrics.clear();
    _providerEvents.clear();
    _lifecycleEvents.clear();
    _buildFrameMicros.clear();
    _rasterFrameMicros.clear();
  }

  static void ensureInitialized() {
    if (_frameCallbackInstalled || !diagnosticsEnabled) return;
    SchedulerBinding.instance.addTimingsCallback((timings) {
      for (final timing in timings) {
        _buildFrameMicros.add(timing.buildDuration.inMicroseconds);
        _rasterFrameMicros.add(timing.rasterDuration.inMicroseconds);
      }
    });
    _frameCallbackInstalled = true;
  }

  static void updateNavigation({
    String? uri,
    int? branchIndex,
    bool incrementTabSequence = false,
  }) {
    if (uri != null) _currentUri = uri;
    if (branchIndex != null) _currentBranchIndex = branchIndex;
    if (incrementTabSequence) _tabSequence++;
  }

  static void logLifecycle(String message) {
    if (!diagnosticsEnabled) return;
    final snapshot = navigation;
    final line =
        '[diag][${config.label}] $message uri=${snapshot.uri} branch=${snapshot.branchIndex} tabSeq=${snapshot.tabSequence}';
    _lifecycleEvents.add(line);
    developer.log(line, name: 'diagnostics');
  }

  static Future<T> runWithInitiator<T>(
    String initiator,
    Future<T> Function() action,
  ) {
    if (!diagnosticsEnabled) return action();
    return runZoned(
      action,
      zoneValues: <Object?, Object?>{_requestInitiatorZoneKey: initiator},
    );
  }

  static String? get currentInitiator =>
      Zone.current[_requestInitiatorZoneKey] as String?;

  static RequestRunRecord startRequest(RequestOptions options) {
    final id = ++_requestId;
    final method = options.method.toUpperCase();
    final path = _normalizePath(options.path);
    final query = _normalizeQuery(options.queryParameters);
    final key = _requestKey(method, path, query);
    final inFlight = _inFlightCounts[key] ?? 0;
    final snapshot = navigation;
    final record = RequestRunRecord(
      id: id,
      method: method,
      normalizedKey: key,
      path: path,
      query: query,
      startedAt: DateTime.now(),
      uri: snapshot.uri,
      branchIndex: snapshot.branchIndex,
      tabSequence: snapshot.tabSequence,
      initiator: currentInitiator,
      duplicateInFlight: inFlight > 0,
    );
    final aggregate = _requestAggregates.putIfAbsent(
      key,
      () => RequestAggregate(),
    );
    aggregate.total += 1;
    if (record.duplicateInFlight) {
      aggregate.duplicateWhileInFlight++;
    }
    _inFlightCounts[key] = inFlight + 1;
    aggregate.maxConcurrent = aggregate.maxConcurrent < inFlight + 1
        ? inFlight + 1
        : aggregate.maxConcurrent;
    _activeRequests[id] = record;
    options.extra['diagnosticsRequestId'] = id;

    developer.log(
      '[http][$id] ${record.method} ${record.path} q=${jsonEncode(record.query)} '
      'uri=${record.uri} branch=${record.branchIndex} tabSeq=${record.tabSequence} '
      'dup=${record.duplicateInFlight} initiator=${record.initiator}',
      name: 'http',
    );
    return record;
  }

  static void completeRequest(
    RequestOptions options, {
    required String outcome,
    int? responseSizeBytes,
  }) {
    final id = options.extra['diagnosticsRequestId'];
    if (id is! int) return;
    final record = _activeRequests.remove(id);
    if (record == null) return;
    final aggregate = _requestAggregates[record.normalizedKey];
    if (aggregate == null) return;
    final durationMs = DateTime.now()
        .difference(record.startedAt)
        .inMilliseconds;
    aggregate.durationsMs.add(durationMs);
    switch (outcome) {
      case 'completed':
        aggregate.completed++;
        break;
      case 'failed':
        aggregate.failed++;
        break;
      case 'cancelled':
        aggregate.cancelled++;
        break;
    }
    final current = _inFlightCounts[record.normalizedKey] ?? 1;
    if (current <= 1) {
      _inFlightCounts.remove(record.normalizedKey);
    } else {
      _inFlightCounts[record.normalizedKey] = current - 1;
    }

    developer.log(
      '[http][$id] $outcome ${record.method} ${record.path} '
      'duration=${durationMs}ms size=${responseSizeBytes ?? -1}B',
      name: 'http',
    );
  }

  static void markCacheHit(
    String method,
    String path,
    Map<String, dynamic> query,
  ) {
    final key = _requestKey(
      method,
      _normalizePath(path),
      _normalizeQuery(query),
    );
    final aggregate = _requestAggregates.putIfAbsent(
      key,
      () => RequestAggregate(),
    );
    aggregate.cacheHits++;
  }

  static List<RequestSummary> requestSummaries() {
    return _requestAggregates.entries
        .map((entry) {
          final durations = [...entry.value.durationsMs]..sort();
          int percentile(double p) {
            if (durations.isEmpty) return 0;
            final index = ((durations.length - 1) * p).round();
            return durations[index];
          }

          return RequestSummary(
            key: entry.key,
            total: entry.value.total,
            completed: entry.value.completed,
            failed: entry.value.failed,
            cancelled: entry.value.cancelled,
            duplicateWhileInFlight: entry.value.duplicateWhileInFlight,
            cacheHits: entry.value.cacheHits,
            maxConcurrent: entry.value.maxConcurrent,
            p50Ms: percentile(0.5),
            p95Ms: percentile(0.95),
          );
        })
        .toList(growable: false)
      ..sort((a, b) => a.key.compareTo(b.key));
  }

  static void recordProviderEvent(
    String provider,
    String event, {
    String? detail,
  }) {
    if (!diagnosticsEnabled) return;
    final snapshot = navigation;
    final metrics = _providerMetrics.putIfAbsent(
      provider,
      () => ProviderMetrics(),
    );
    switch (event) {
      case 'added':
        metrics.added++;
        break;
      case 'updated':
        metrics.updated++;
        metrics.recomputations++;
        break;
      case 'disposed':
        metrics.disposed++;
        break;
      case 'loading':
        metrics.loading++;
        break;
      case 'data':
        metrics.data++;
        break;
      case 'error':
        metrics.error++;
        break;
    }
    final record = ProviderEventRecord(
      timestamp: DateTime.now(),
      provider: provider,
      event: event,
      uri: snapshot.uri,
      branchIndex: snapshot.branchIndex,
      tabSequence: snapshot.tabSequence,
      detail: detail,
    );
    _providerEvents.add(record);
    developer.log(
      '[provider][$provider] $event uri=${record.uri} branch=${record.branchIndex} tabSeq=${record.tabSequence}${detail == null ? '' : ' detail=$detail'}',
      name: 'provider',
    );
  }

  static UnmodifiableListView<ProviderEventRecord> get providerEvents =>
      UnmodifiableListView(_providerEvents);

  static Map<String, ProviderMetrics> get providerMetrics =>
      UnmodifiableMapView(_providerMetrics);

  static UnmodifiableListView<String> get lifecycleEvents =>
      UnmodifiableListView(_lifecycleEvents);

  static int currentMemoryRssBytes() {
    try {
      return ProcessInfo.currentRss;
    } catch (_) {
      return -1;
    }
  }

  static int get transientCallbackCount =>
      SchedulerBinding.instance.transientCallbackCount;

  static FrameTimingSummary frameTimingSummary() {
    int percentile(List<int> values, double p) {
      if (values.isEmpty) return 0;
      final sorted = [...values]..sort();
      final index = ((sorted.length - 1) * p).round();
      return sorted[index] ~/ 1000;
    }

    final maxBuild = _buildFrameMicros.isEmpty
        ? 0
        : _buildFrameMicros.reduce((a, b) => a > b ? a : b) ~/ 1000;
    final maxRaster = _rasterFrameMicros.isEmpty
        ? 0
        : _rasterFrameMicros.reduce((a, b) => a > b ? a : b) ~/ 1000;

    return FrameTimingSummary(
      totalFrames: _buildFrameMicros.length,
      uiJankyFrames: _buildFrameMicros.where((value) => value > 16000).length,
      rasterJankyFrames: _rasterFrameMicros
          .where((value) => value > 16000)
          .length,
      p50BuildMs: percentile(_buildFrameMicros, 0.5),
      p95BuildMs: percentile(_buildFrameMicros, 0.95),
      maxBuildMs: maxBuild,
      p50RasterMs: percentile(_rasterFrameMicros, 0.5),
      p95RasterMs: percentile(_rasterFrameMicros, 0.95),
      maxRasterMs: maxRaster,
    );
  }

  static String _normalizePath(String path) {
    final uri = Uri.tryParse(path);
    if (uri == null) return path;
    return uri.path;
  }

  static Map<String, dynamic> _normalizeQuery(Map<String, dynamic> query) {
    final entries = query.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map<String, dynamic>.fromEntries(entries);
  }

  static String _requestKey(
    String method,
    String path,
    Map<String, dynamic> query,
  ) {
    return '$method $path?${jsonEncode(query)}';
  }
}

class HttpInstrumentationInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!diagnosticsEnabled) {
      handler.next(options);
      return;
    }
    AppRuntimeDiagnostics.startRequest(options);
    if (AppRuntimeDiagnostics.config.blockNetworkRequests) {
      handler.reject(
        DioException.connectionError(
          requestOptions: options,
          reason: 'Diagnostics blocked network request',
        ),
      );
      return;
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.data;
    final size = switch (data) {
      final String s => utf8.encode(s).length,
      null => 0,
      _ => utf8.encode(jsonEncode(data)).length,
    };
    AppRuntimeDiagnostics.completeRequest(
      response.requestOptions,
      outcome: 'completed',
      responseSizeBytes: size,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppRuntimeDiagnostics.completeRequest(
      err.requestOptions,
      outcome: err.type == DioExceptionType.cancel ? 'cancelled' : 'failed',
    );
    handler.next(err);
  }
}
