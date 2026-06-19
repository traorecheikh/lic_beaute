import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/reactivity/app_reactivity.dart';

class AppRouteRefreshObserver extends NavigatorObserver {
  AppRouteRefreshObserver(this._ref);

  final Ref _ref;
  DateTime _lastRefresh = DateTime.fromMillisecondsSinceEpoch(0);

  void _refresh() {
    final now = DateTime.now();
    if (now.difference(_lastRefresh) < const Duration(milliseconds: 350)) {
      return;
    }
    _lastRefresh = now;
    _ref.read(appReactivityProvider).refreshAll();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _refresh();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _refresh();
    super.didPop(route, previousRoute);
  }
}
