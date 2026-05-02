import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A tappable card that shows a primary-color border when selected.
///
/// Replaces the GestureDetector + Container + BoxDecoration pattern duplicated
/// in service_selection_page and staff_selection_page.
class AppSelectableCard extends StatelessWidget {
  const AppSelectableCard({
    required this.child,
    required this.selected,
    required this.onTap,
    this.margin,
    this.padding,
    super.key,
  });

  final Widget child;
  final bool selected;
  final VoidCallback onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.only(bottom: 16.h),
        padding: padding ?? EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
