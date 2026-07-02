import 'dart:async';

import 'package:cupertino_native_better/components/tab_bar.dart';
import 'package:cupertino_native_better/style/sf_symbol.dart';
import 'package:flutter/cupertino.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';

/// Native iOS 26+ Liquid Glass tab bar wrapper.
///
/// This is **not** a second navigation state machine. The GoRouter
/// [StatefulNavigationShell] remains the single source of truth for
/// the selected index and branch navigation. This widget reads
/// [currentIndex] and delegates tab taps back to the existing shell
/// logic through [onTap].
///
/// Only rendered on iOS 26+ when the `enableIOSNativeTabBar` or
/// `enableIOSNativeGlass` feature flag is active. Falls back to the
/// existing Flutter bottom nav on older iOS and Android.
class IOSNativeTabBar extends StatelessWidget {
  const IOSNativeTabBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final Future<void> Function(int index) onTap;

  static const _tabs = <_TabInfo>[
    _TabInfo(
      label: AppStrings.discoverTab,
      symbol: 'safari',
      activeSymbol: 'safari.fill',
    ),
    _TabInfo(
      label: AppStrings.bookingsTab,
      symbol: 'calendar',
      activeSymbol: 'calendar',
    ),
    _TabInfo(
      label: AppStrings.profileTab,
      symbol: 'person',
      activeSymbol: 'person.fill',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CNTabBar(
      currentIndex: currentIndex,
      onTap: (index) => unawaited(onTap(index)),
      tint: AppColors.primary,
      items: List.generate(_tabs.length, (i) {
        final tab = _tabs[i];
        return CNTabBarItem(
          label: tab.label,
          icon: CNSymbol(tab.symbol, size: 22),
          activeIcon: CNSymbol(tab.activeSymbol, size: 22),
        );
      }),
    );
  }
}

class _TabInfo {
  const _TabInfo({
    required this.label,
    required this.symbol,
    required this.activeSymbol,
  });

  final String label;
  final String symbol;
  final String activeSymbol;
}
