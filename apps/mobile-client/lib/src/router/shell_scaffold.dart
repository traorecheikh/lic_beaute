import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_strings.dart';
import '../core/diagnostics/app_runtime_diagnostics.dart';
import '../core/platform/ios_version.dart';
import '../core/session/session_store.dart';
import '../core/widgets/android_material_nav_bar.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../core/widgets/app_icon.dart';
import '../features/auth/widgets/auth_required_sheet.dart';
import 'app_router.dart';
import 'ios_native_tab_bar.dart';
import 'navigation_debug.dart';

class ShellScaffold extends ConsumerStatefulWidget {
  const ShellScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends ConsumerState<ShellScaffold> {
  bool _authSheetOpen = false;

  static const _tabs = [
    _TabItem(
      id: 'discover',
      icon: 'compass',
      label: AppStrings.discoverTab,
      path: AppRoutes.home,
    ),
    _TabItem(
      id: 'bookings',
      icon: 'calendar',
      label: AppStrings.bookingsTab,
      path: AppRoutes.bookingsList,
    ),
    _TabItem(
      id: 'profile',
      icon: 'user',
      label: AppStrings.profileTab,
      path: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final index = widget.navigationShell.currentIndex;
    final session = ref.watch(sessionProvider);
    final location = GoRouterState.of(context).matchedLocation;
    final isSearchPage = location == '/search';
    AppRuntimeDiagnostics.updateNavigation(uri: location, branchIndex: index);

    Future<void> handleTabTap(int i) async {
      final currentUri = GoRouter.of(
        context,
      ).routeInformationProvider.value.uri.toString();
      logBranchTap(
        currentIndex: index,
        requestedIndex: i,
        currentUri: currentUri,
      );

      if (i == 0 || session.isAuthenticated) {
        final restoringStaleProfileSetup =
            i == 2 &&
            index != 2 &&
            NavigationDebugRegistry.topRouteName('branch-profile') ==
                'payment-methods';
        if (restoringStaleProfileSetup) {
          context.go(AppRoutes.profile);
          return;
        }
        widget.navigationShell.goBranch(i, initialLocation: i == index);
        return;
      }
      if (_authSheetOpen) return;
      _authSheetOpen = true;
      await showAuthRequiredSheet(
        context,
        onLogin: () => context.go(AppRoutes.auth),
      );
      _authSheetOpen = false;
    }

    return Scaffold(
      // Reserve the tab-bar footprint so page content and footers never sit
      // underneath the native glass or Material navigation controls.
      extendBody: false,
      body: widget.navigationShell,
      bottomNavigationBar: isSearchPage
          ? null
          : Theme.of(context).platform == TargetPlatform.android
              ? AndroidMaterialNavigationBar(
                  currentIndex: index,
                  onTap: handleTabTap,
                )
              : IOSVersion.supportsNativeGlass &&
                      (AppRuntimeDiagnostics.config.enableIOSNativeTabBar ||
                          AppRuntimeDiagnostics.config.enableIOSNativeGlass)
                  ? IOSNativeTabBar(
                      currentIndex: index,
                      onTap: handleTabTap,
                    )
                  : AppRuntimeDiagnostics.config.useStockNavigationBar
                      ? _StockBottomNav(
                          currentIndex: index,
                          tabs: _tabs,
                          onTap: handleTabTap,
                        )
                      : _BottomNav(
                          currentIndex: index,
                          tabs: _tabs,
                          onTap: handleTabTap,
                        ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const navContentHeight = 50.0;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.outline.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: SizedBox(
        height: navContentHeight + bottomInset,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: navContentHeight,
              child: Row(
                children: List.generate(tabs.length, (i) {
                  return Expanded(
                    child: _NavItem(
                      item: tabs[i],
                      isActive: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: bottomInset),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _TabItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.onSurfaceVariant;
    final animationsDisabled =
        AppRuntimeDiagnostics.config.disableCustomNavAnimations;

    return Semantics(
      label: item.label,
      button: true,
      selected: isActive,
      child: GestureDetector(
        key: ValueKey('bottom-tab-${item.id}'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(
                  item.icon,
                  size: 20,
                  color: isActive ? activeColor : inactiveColor,
                  excludeFromSemantics: true,
                ),
                SizedBox(height: 1.h),
                AnimatedDefaultTextStyle(
                  duration: animationsDisabled
                      ? Duration.zero
                      : const Duration(milliseconds: 150),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.sp,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? activeColor : inactiveColor,
                    height: 1,
                    letterSpacing: 0.2,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
                SizedBox(height: 1.h),
                AnimatedContainer(
                  duration: animationsDisabled
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  width: isActive ? 4.r : 0,
                  height: isActive ? 4.r : 0,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StockBottomNav extends StatelessWidget {
  const _StockBottomNav({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      height: 64,
      destinations: tabs
          .map(
            (tab) => NavigationDestination(
              icon: AppIcon(
                tab.icon,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
              selectedIcon: AppIcon(
                tab.icon,
                size: 20,
                color: AppColors.primary,
              ),
              label: tab.label,
            ),
          )
          .toList(growable: false),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.path,
  });

  final String id;
  final String icon;
  final String label;
  final String path;
}
