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
          color: const Color(0xFFFFF7EB),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFF1D49C)),
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
              decoration: const BoxDecoration(
                color: Color(0xFFFFE7BF),
                shape: BoxShape.circle,
              ),
              child: const AppIcon('wifi-off', size: 18, color: Color(0xFF9B6A10)),
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
