import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';

/// Branded Material 3 bottom navigation bar for Android.
///
/// Uses [NavigationBar] themed through [NavigationBarThemeData] with the
/// existing Beauté Avenue pink (`AppColors.primary`) for the selected
/// destination and neutral branded colors for unselected destinations.
///
/// The GoRouter [StatefulNavigationShell] remains the single source of
/// truth — this widget reads [currentIndex] and delegates back to the
/// shell via [onTap].
///
/// Minimum 48×48 logical-pixel touch targets (M3 default). Supports
/// TalkBack and font scaling.
class AndroidMaterialNavigationBar extends StatelessWidget {
  const AndroidMaterialNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  /// The currently selected tab index from the navigation shell.
  final int currentIndex;

  /// Called with the destination index. Must delegate to
  /// `navigationShell.goBranch(index, initialLocation: ...)`.
  final ValueChanged<int> onTap;

  static const _destinations = <_DestinationInfo>[
    _DestinationInfo(
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      label: AppStrings.discoverTab,
    ),
    _DestinationInfo(
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month,
      label: AppStrings.bookingsTab,
    ),
    _DestinationInfo(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: AppStrings.profileTab,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(navigationBarTheme: _navigationBarTheme(context)),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        height: 64,
        destinations: List.generate(_destinations.length, (i) {
          final dest = _destinations[i];
          final isSelected = i == currentIndex;
          return NavigationDestination(
            icon: Icon(
              dest.icon,
              color: isSelected ? null : AppColors.onSurfaceVariant,
            ),
            selectedIcon: Icon(dest.selectedIcon),
            label: dest.label,
          );
        }),
      ),
    );
  }

  NavigationBarThemeData _navigationBarTheme(BuildContext context) {
    final labelBase = AppTextStyles.labelSm.copyWith(fontSize: 12);
    return NavigationBarThemeData(
      // Indicator: small restrained pill matching the brand pink
      indicatorColor: AppColors.primaryLight,
      indicatorShape: const StadiumBorder(),

      // Surface: warm white matching the existing page background
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,

      // Elevation: subtle shadow to lift off the page
      elevation: 3,
      shadowColor: AppColors.black.withValues(alpha: 0.08),

      // Height: comfortable touch targets
      height: 64,

      // Selected destination: brand pink
      // Using the Material 3 color scheme for proper indicator theming
      // falls back to AppColors.primary through the theme's colorScheme
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

      // Icon and label sizing
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(size: 24, color: AppColors.primary);
        }
        return const IconThemeData(size: 24, color: AppColors.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return labelBase.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          );
        }
        return labelBase.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        );
      }),
    );
  }
}

class _DestinationInfo {
  const _DestinationInfo({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
