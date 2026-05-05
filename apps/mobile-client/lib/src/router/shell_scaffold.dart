import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_strings.dart';
import '../core/session/session_store.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../core/widgets/app_icon.dart';
import '../core/widgets/app_sheet.dart';
import '../core/widgets/app_sheet_content.dart';
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

    Future<void> handleTabTap(int i) async {
      if (i == 0) {
        context.go(_tabs[i].path);
        return;
      }
      if (session.isAuthenticated) {
        context.go(_tabs[i].path);
        return;
      }
      await _showAuthSheet(context);
    }

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: index,
        tabs: _tabs,
        onTap: handleTabTap,
      ),
    );
  }

  Future<void> _showAuthSheet(BuildContext context) {
    return AppSheet.show<void>(
      context,
      builder: (ctx) => _AuthPromptSheet(
        onLogin: () {
          Navigator.of(ctx).pop();
          context.go(AppRoutes.auth);
        },
        onDismiss: () => Navigator.of(ctx).pop(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating pill nav bar
// ─────────────────────────────────────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
        child: Container(
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: AppShadows.nav,
          ),
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryLight : AppColors.transparent,
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              item.icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            SizedBox(height: 3.h),
            Text(
              item.label,
              style: AppTextStyles.labelSm.copyWith(
                color: isActive
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
                fontSize: 10.sp,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Auth prompt bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _AuthPromptSheet extends StatelessWidget {
  const _AuthPromptSheet({required this.onLogin, required this.onDismiss});

  final VoidCallback onLogin;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AppSheetContent(
      title: 'Connexion requise',
      body: 'Connectez-vous pour accéder à vos rendez-vous et à votre profil.',
      confirmLabel: 'Se connecter',
      cancelLabel: 'Plus tard',
      onConfirm: onLogin,
      onCancel: onDismiss,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data class
// ─────────────────────────────────────────────────────────────────────────────

class _TabItem {
  const _TabItem({required this.icon, required this.label, required this.path});

  final String icon;
  final String label;
  final String path;
}
