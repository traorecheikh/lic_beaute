import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

import '../constants/app_strings.dart';
import '../network/connectivity_provider.dart';
import 'app_connectivity_wrapper.dart';
import 'app_icon.dart';

class AppConnectivityBanner extends ConsumerWidget {
  const AppConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    if (isOnline) {
      return const SizedBox.shrink();
    }

    return AppConnectivityWrapper(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.warningContainer.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.warningOutline.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34.r,
              height: 34.r,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: AppIcon('wifi-off', size: 18, color: AppColors.statusPendingText),
            ),
            gapW12,
            Expanded(
              child: ConnectivityMessage(
                title: AppStrings.offlineTitle,
                subtitle: AppStrings.offlineSubtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
