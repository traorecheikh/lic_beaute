import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/diagnostics/app_runtime_diagnostics.dart';

bool get navigationDebugEnabled => !kReleaseMode;

class NavigationDebugRegistry {
  NavigationDebugRegistry._();

  static final Map<String, List<Route<dynamic>>> _stacks =
      <String, List<Route<dynamic>>>{};

  static bool get hasVisiblePopup => _stacks.values.any(
    (stack) => stack.isNotEmpty && stack.last is PopupRoute,
  );

  static String get stackSummary => _stacks.entries
      .map((entry) {
        final top = entry.value.isEmpty
            ? 'empty'
            : _routeLabel(entry.value.last);
        return '${entry.key}=$top';
      })
      .join(', ');

  static String? topRouteName(String navigatorName) {
    final stack = _stacks[navigatorName];
    if (stack == null || stack.isEmpty) return null;
    return stack.last.settings.name;
  }

  static void push(String navigatorName, Route<dynamic> route) {
    _stacks.putIfAbsent(navigatorName, () => <Route<dynamic>>[]).add(route);
  }

  static void pop(String navigatorName, Route<dynamic> route) {
    final stack = _stacks[navigatorName];
    if (stack == null || stack.isEmpty) return;
    stack.remove(route);
  }

  static void replace(
    String navigatorName,
    Route<dynamic>? oldRoute,
    Route<dynamic>? newRoute,
  ) {
    final stack = _stacks.putIfAbsent(navigatorName, () => <Route<dynamic>>[]);
    if (oldRoute != null) {
      stack.remove(oldRoute);
    }
    if (newRoute != null) {
      stack.add(newRoute);
    }
  }

  static void logEvent({
    required String navigatorName,
    required String action,
    required String currentUri,
    required Route<dynamic>? route,
    Route<dynamic>? previousRoute,
    int? selectedBranchIndex,
    int? requestedBranchIndex,
  }) {
    AppRuntimeDiagnostics.updateNavigation(
      uri: currentUri,
      branchIndex: selectedBranchIndex,
      incrementTabSequence: action == 'tabTap',
    );
    if (!navigationDebugEnabled) return;
    developer.log(
      '[NAV][$navigatorName] $action '
      'route=${_routeLabel(route)} '
      'prev=${_routeLabel(previousRoute)} '
      'uri=$currentUri '
      'selected=$selectedBranchIndex '
      'requested=$requestedBranchIndex '
      'popupVisible=$hasVisiblePopup '
      'lifecycle=${WidgetsBinding.instance.lifecycleState} '
      'stacks=[$stackSummary]',
      name: 'router',
    );
  }

  static String _routeLabel(Route<dynamic>? route) {
    if (route == null) return 'null';
    final settingsName = route.settings.name;
    if (settingsName != null && settingsName.isNotEmpty) {
      return '$settingsName (${route.runtimeType})';
    }
    return route.runtimeType.toString();
  }
}

class LoggingNavigatorObserver extends NavigatorObserver {
  LoggingNavigatorObserver({
    required this.navigatorName,
    required this.currentUri,
    this.selectedBranchIndex,
  });

  final String navigatorName;
  final String Function() currentUri;
  final int? Function()? selectedBranchIndex;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    NavigationDebugRegistry.push(navigatorName, route);
    NavigationDebugRegistry.logEvent(
      navigatorName: navigatorName,
      action: 'didPush',
      currentUri: currentUri(),
      route: route,
      previousRoute: previousRoute,
      selectedBranchIndex: selectedBranchIndex?.call(),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    NavigationDebugRegistry.pop(navigatorName, route);
    NavigationDebugRegistry.logEvent(
      navigatorName: navigatorName,
      action: 'didPop',
      currentUri: currentUri(),
      route: route,
      previousRoute: previousRoute,
      selectedBranchIndex: selectedBranchIndex?.call(),
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    NavigationDebugRegistry.pop(navigatorName, route);
    NavigationDebugRegistry.logEvent(
      navigatorName: navigatorName,
      action: 'didRemove',
      currentUri: currentUri(),
      route: route,
      previousRoute: previousRoute,
      selectedBranchIndex: selectedBranchIndex?.call(),
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    NavigationDebugRegistry.replace(navigatorName, oldRoute, newRoute);
    NavigationDebugRegistry.logEvent(
      navigatorName: navigatorName,
      action: 'didReplace',
      currentUri: currentUri(),
      route: newRoute,
      previousRoute: oldRoute,
      selectedBranchIndex: selectedBranchIndex?.call(),
    );
  }
}

void logBranchTap({
  required int currentIndex,
  required int requestedIndex,
  required String currentUri,
}) {
  NavigationDebugRegistry.logEvent(
    navigatorName: 'shell',
    action: 'tabTap',
    currentUri: currentUri,
    route: null,
    selectedBranchIndex: currentIndex,
    requestedBranchIndex: requestedIndex,
  );
}
