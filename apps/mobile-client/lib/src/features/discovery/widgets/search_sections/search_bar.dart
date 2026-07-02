import 'dart:io' show Platform;

import 'package:cupertino_native_better/components/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/diagnostics/app_runtime_diagnostics.dart';
import '../../../../core/platform/ios_version.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../../../core/widgets/ios_native_icon_button.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    required this.controller,
    required this.focusNode,
    required this.nativeController,
    required this.sort,
    required this.isDebouncing,
    required this.onSortChanged,
    required this.onOpenSortSheet,
    required this.onNativeChanged,
    required this.onNativeSubmitted,
    super.key,
  });

  static const searchHeroTag = 'home-search-hero';

  final TextEditingController controller;
  final FocusNode focusNode;
  final CNSearchBarController nativeController;
  final String sort;
  final bool isDebouncing;
  final void Function(String sort) onSortChanged;
  final VoidCallback onOpenSortSheet;
  final ValueChanged<String> onNativeChanged;
  final ValueChanged<String> onNativeSubmitted;

  bool get _useNativeIOSSearch =>
      IOSVersion.supportsNativeGlass &&
      (AppRuntimeDiagnostics.config.enableIOSNativeSearchBar ||
          AppRuntimeDiagnostics.config.enableIOSNativeGlass);

  @override
  Widget build(BuildContext context) {
    if (_useNativeIOSSearch) {
      return _buildNativeIOSHeader(context);
    }
    if (Platform.isAndroid) {
      return _buildAndroidHeader(context);
    }
    return _buildFlutterHeader(context);
  }

  Widget _buildNativeIOSHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 2.h),
            child: Row(
              children: [
                IOSNativeIconButton(
                  iconName: 'arrow-left',
                  foregroundColor: AppColors.onSurface,
                  tintColor: AppColors.surface.withValues(alpha: 0.28),
                  semanticLabel: 'Retour',
                  onPressed: () => context.pop(),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: CNSearchBar(
                      controller: nativeController,
                      placeholder: AppStrings.searchHintDetailed,
                      expandable: false,
                      initiallyExpanded: true,
                      autofocus: true,
                      showCancelButton: false,
                      tint: AppColors.primary,
                      textColor: AppColors.onSurface,
                      placeholderColor: AppColors.onSurfaceVariant,
                      onChanged: onNativeChanged,
                      onSubmitted: onNativeSubmitted,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                IOSNativeIconButton(
                  iconName: 'filter',
                  foregroundColor: sort == 'relevance'
                      ? AppColors.primary
                      : AppColors.white,
                  tintColor: sort == 'relevance'
                      ? AppColors.primaryLight.withValues(alpha: 0.58)
                      : AppColors.primary,
                  semanticLabel: 'Trier et filtrer',
                  onPressed: onOpenSortSheet,
                ),
              ],
            ),
          ),
        ),
        _SearchActivityStatus(visible: isDebouncing),
      ],
    );
  }

  Widget _buildAndroidHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 2.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  tooltip: 'Retour',
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: SearchBar(
                    controller: controller,
                    focusNode: focusNode,
                    hintText: AppStrings.searchHintDetailed,
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(AppColors.surface),
                    constraints: BoxConstraints(
                      minHeight: 48.h,
                      maxHeight: 48.h,
                    ),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 14.w),
                    ),
                    leading: const Icon(Icons.search_rounded),
                    trailing: [
                      if (controller.text.isNotEmpty)
                        IconButton(
                          tooltip: 'Effacer',
                          onPressed: () {
                            controller.clear();
                            focusNode.requestFocus();
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton.filledTonal(
                  onPressed: onOpenSortSheet,
                  tooltip: 'Trier et filtrer',
                  style: IconButton.styleFrom(
                    minimumSize: Size.square(48.r),
                    foregroundColor: sort == 'relevance'
                        ? AppColors.primary
                        : AppColors.white,
                    backgroundColor: sort == 'relevance'
                        ? AppColors.primaryLight
                        : AppColors.primary,
                  ),
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ),
          ),
        ),
        _SearchActivityStatus(visible: isDebouncing),
      ],
    );
  }

  Widget _buildFlutterHeader(BuildContext context) {
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
        _SearchActivityStatus(visible: isDebouncing),
      ],
    );
  }
}

class _SearchActivityStatus extends StatelessWidget {
  const _SearchActivityStatus({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: visible
          ? SizedBox(
              height: isIOS ? 20.h : 2.h,
              child: isIOS
                  ? Center(
                      child: CupertinoActivityIndicator(
                        radius: 7.r,
                        color: AppColors.primary,
                      ),
                    )
                  : LinearProgressIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.primaryLight,
                    ),
            )
          : const SizedBox.shrink(),
    );
  }
}
