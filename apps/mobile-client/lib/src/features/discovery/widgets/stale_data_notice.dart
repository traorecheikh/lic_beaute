import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

/// A sliver version of [StaleDataNotice] — renders the notice inside a
/// [SliverToBoxAdapter] with the standard padding, so pages can drop it
/// into a [CustomScrollView] slivers list without boilerplate.
class AppSliverStaleNotice extends StatelessWidget {
  const AppSliverStaleNotice({required this.cachedAt, super.key});

  final DateTime cachedAt;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
        child: StaleDataNotice(cachedAt: cachedAt),
      ),
    );
  }
}

class StaleDataNotice extends StatelessWidget {
  const StaleDataNotice({required this.cachedAt, super.key});

  final DateTime cachedAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8ED),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFFD89B)),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, size: 16, color: Color(0xFF92600A)),
          gapW8,
          Expanded(
            child: Text(
              'Mode hors ligne · Dernière mise à jour ${_relativeLabel(cachedAt)}',
              style: AppTextStyles.bodyXs.copyWith(color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  String _relativeLabel(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'à l’instant';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
    return 'le ${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';
  }
}
