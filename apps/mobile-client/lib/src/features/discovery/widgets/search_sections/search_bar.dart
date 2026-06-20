import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_pressable.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    required this.controller,
    required this.focusNode,
    required this.sort,
    required this.isDebouncing,
    required this.onSortChanged,
    required this.onOpenSortSheet,
    super.key,
  });

  static const searchHeroTag = 'home-search-hero';

  final TextEditingController controller;
  final FocusNode focusNode;
  final String sort;
  final bool isDebouncing;
  final void Function(String sort) onSortChanged;
  final VoidCallback onOpenSortSheet;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: AppIconBox(
                    circle: true,
                    size: 40.r,
                    color: AppColors.surface,
                    shadow: AppShadows.sm,
                    child: AppIcon(
                      'arrow-left',
                      size: 18,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Hero(
                    tag: searchHeroTag,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md.r),
                          boxShadow: AppShadows.sm,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 14.w),
                            AppIcon(
                              'search',
                              size: 18,
                              color: AppColors.onSurfaceVariant,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: AppStrings.searchHintDetailed,
                                  hintStyle: AppTextStyles.bodyMd.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  filled: false,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            if (controller.text.isNotEmpty)
                              AppPressable(
                                onTap: () {
                                  controller.clear();
                                  focusNode.requestFocus();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(10.r),
                                  child: AppIcon(
                                    'close',
                                    size: 16,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            gapW4,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: onOpenSortSheet,
                  child: Container(
                    height: 46.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: sort != 'relevance'
                          ? AppColors.primary
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.md.r),
                      boxShadow: AppShadows.sm,
                    ),
                    child: AppIcon(
                      'filter',
                      size: 16,
                      color: sort != 'relevance'
                          ? AppColors.white
                          : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Debounce bar ────────────────────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isDebouncing ? 2.h : 0,
          child: isDebouncing
              ? LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.primaryLight,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
