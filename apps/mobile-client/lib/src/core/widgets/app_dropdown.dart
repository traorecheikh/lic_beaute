import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'app_icon.dart';

/// A fully custom dropdown that matches the app's design language.
/// Opens a themed bottom sheet — no Material DropdownButton, no Cupertino picker.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    this.itemLeading,
    this.enabled = true,
    super.key,
  });

  final String label;
  final List<T> items;
  final T value;
  final ValueChanged<T> onChanged;
  final String Function(T) itemLabel;

  /// Optional leading widget per item (e.g. a flag emoji Text).
  final Widget Function(T)? itemLeading;
  final bool enabled;

  Future<void> _openSheet(BuildContext context) async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) => _AppDropdownSheet<T>(
        label: label,
        items: items,
        value: value,
        itemLabel: itemLabel,
        itemLeading: itemLeading,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => _openSheet(context) : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            if (itemLeading != null) ...[
              itemLeading!(value),
              SizedBox(width: 10.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(itemLabel(value), style: AppTextStyles.bodyMd),
                ],
              ),
            ),
            AppIcon('chevron-down', color: AppColors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

class _AppDropdownSheet<T> extends StatelessWidget {
  const _AppDropdownSheet({
    required this.label,
    required this.items,
    required this.value,
    required this.itemLabel,
    this.itemLeading,
    super.key,
  });

  final String label;
  final List<T> items;
  final T value;
  final String Function(T) itemLabel;
  final Widget Function(T)? itemLeading;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.5;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(label, style: AppTextStyles.headlineSm),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: AppIcon('close', color: AppColors.onSurfaceVariant, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 32.h),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];
                  final isSelected = item == value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(item),
                        borderRadius: BorderRadius.circular(16.r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.06)
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              if (itemLeading != null) ...[
                                itemLeading!(item),
                                SizedBox(width: 14.w),
                              ],
                              Expanded(
                                child: Text(
                                  itemLabel(item),
                                  style: AppTextStyles.labelLg.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 150),
                                opacity: isSelected ? 1.0 : 0.0,
                                child: AppIcon('check-circle', color: AppColors.primary, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
