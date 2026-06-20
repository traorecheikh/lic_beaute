import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_strings.dart';
import '../core/session/session_store.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../core/widgets/app_icon.dart';
import '../features/auth/widgets/auth_required_sheet.dart';
import 'app_router.dart';

class ShellScaffold extends ConsumerWidget {
  const ShellScaffold({required this.child, super.key});

  final Widget child;

  static const _tabs = [
    _TabItem(
      icon: 'compass',
      label: AppStrings.discoverTab,
      path: AppRoutes.home,
    ),
    _TabItem(
      icon: 'calendar',
      label: AppStrings.bookingsTab,
      path: AppRoutes.bookingsList,
    ),
    _TabItem(
      icon: 'user',
      label: AppStrings.profileTab,
      path: AppRoutes.profile,
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.bookingsList)) return 1;
    if (location.startsWith(AppRoutes.profile)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = _currentIndex(context);
    final session = ref.watch(sessionProvider);
    final location = GoRouterState.of(context).matchedLocation;
    final isSearchPage = location == '/search';

    Future<void> handleTabTap(int i) async {
      if (i == 0) {
        context.go(_tabs[i].path);
        return;
      }
      if (session.isAuthenticated) {
        context.go(_tabs[i].path);
        return;
      }
      await showAuthRequiredSheet(
        context,
        onLogin: () => context.go(AppRoutes.auth),
      );
    }

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: isSearchPage
          ? null
          : _BottomNav(currentIndex: index, tabs: _tabs, onTap: handleTabTap),
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
    final navHeight = 72.h < 64 ? 64.0 : 72.h;
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
        height: navHeight + bottomInset,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
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
    final inactiveColor = AppColors.onSurfaceVariant.withValues(alpha: 0.5);

    return Semantics(
      label: item.label,
      button: true,
      selected: isActive,
      child: GestureDetector(
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
                  duration: const Duration(milliseconds: 150),
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
                  duration: const Duration(milliseconds: 200),
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

class _TabItem {
  const _TabItem({required this.icon, required this.label, required this.path});

  final String icon;
  final String label;
  final String path;
}
