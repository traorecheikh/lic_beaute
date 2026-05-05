import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

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
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.onSurfaceVariant,
              size: 20.r,
            ),
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
    final maxHeight = MediaQuery.of(context).size.height * 0.72;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
            child: Row(
              children: [
                Expanded(child: Text(label, style: AppTextStyles.headlineSm)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.onSurfaceVariant,
                    size: 22.r,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(height: 6.h),
              itemBuilder: (_, i) {
                final item = items[i];
                final isSelected = item == value;
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(item),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                      ),
                      boxShadow: isSelected ? AppShadows.card : null,
                    ),
                    child: Row(
                      children: [
                        if (itemLeading != null) ...[
                          itemLeading!(item),
                          gapW12,
                        ],
                        Expanded(
                          child: Text(
                            itemLabel(item),
                            style: AppTextStyles.labelLg.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.onSurface,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                            size: 18.r,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
