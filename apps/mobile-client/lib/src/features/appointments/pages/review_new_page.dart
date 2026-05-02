import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../discovery/widgets/stale_data_notice.dart';
import '../providers/booking_actions_provider.dart';
import '../providers/bookings_list_provider.dart';

class ReviewNewPage extends ConsumerStatefulWidget {
  const ReviewNewPage({super.key, required this.bookingId});
  final String bookingId;

  @override
  ConsumerState<ReviewNewPage> createState() => _ReviewNewPageState();
}

class _ReviewNewPageState extends ConsumerState<ReviewNewPage> {
  int _rating = 0;
  final _comment = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(
      bookingDetailResourceProvider(widget.bookingId),
    );
    Future<void> refreshBooking() =>
        ref.refresh(bookingDetailResourceProvider(widget.bookingId).future);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: EdgeInsets.all(24.r),
          child: AppErrorState(
            error: error,
            fallbackTitle: 'Impossible de charger le formulaire d’avis',
            serverTitle: 'L’avis est indisponible',
            onRetry: refreshBooking,
          ),
        ),
        data: (resource) {
          final detail = resource.data;
          final salonName = (detail?['salonName'] as String?) ?? 'Salon';
          final serviceName = (detail?['serviceName'] as String?) ?? 'Service';

          return Stack(
            children: [
              RefreshIndicator.adaptive(
                color: AppColors.primary,
                onRefresh: refreshBooking,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    if (resource.isStale && resource.cachedAt != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                          child: StaleDataNotice(cachedAt: resource.cachedAt!),
                        ),
                      ),
                    SliverSafeArea(
                      bottom: false,
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 36.r,
                                  height: 36.r,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    boxShadow: AppShadows.sm,
                                  ),
                                  child: Center(
                                    child: AppIcon(
                                      'arrow-left',
                                      size: 18,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 140.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Salon badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppIcon(
                                    'sparkle',
                                    size: 13,
                                    color: AppColors.secondary,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '$salonName · $serviceName',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.onSecondaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),

                            Text(
                              'Comment s\'est passée\nvotre expérience ?',
                              style: AppTextStyles.displaySm.copyWith(
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 32.h),

                            // Star selector
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                final filled = i < _rating;
                                return GestureDetector(
                                  onTap: () {
                                    AppHaptics.select();
                                    setState(() => _rating = i + 1);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                    ),
                                    child: AnimatedScale(
                                      scale: filled ? 1.15 : 1.0,
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      child: Icon(
                                        filled
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        color: filled
                                            ? AppColors.secondary
                                            : AppColors.outline,
                                        size: 40.r,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 8.h),
                            AnimatedOpacity(
                              opacity: _rating > 0 ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                _ratingLabel(_rating),
                                style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                            SizedBox(height: 28.h),

                            // Comment field
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(18.r),
                                boxShadow: AppShadows.card,
                              ),
                              child: TextField(
                                controller: _comment,
                                maxLines: 5,
                                style: AppTextStyles.bodyMd,
                                decoration: InputDecoration(
                                  hintText: 'Partagez votre expérience…',
                                  hintStyle: AppTextStyles.bodyMd.copyWith(
                                    color: AppColors.outline,
                                  ),
                                  contentPadding: EdgeInsets.all(18.r),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Submit CTA
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.onSurface.withValues(alpha: 0.07),
                        blurRadius: 24,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: (_rating == 0 || _submitting)
                            ? null
                            : () async {
                                AppHaptics.medium();
                                setState(() => _submitting = true);
                                try {
                                  await ref
                                      .read(bookingActionsProvider)
                                      .submitReview(
                                        bookingId: widget.bookingId,
                                        rating: _rating,
                                        comment: _comment.text.trim().isEmpty
                                            ? null
                                            : _comment.text.trim(),
                                      );
                                  if (!context.mounted) return;
                                  AppSnackbar.success(
                                    context,
                                    'Merci pour votre avis.',
                                  );
                                  context.pop();
                                } finally {
                                  if (mounted) {
                                    setState(() => _submitting = false);
                                  }
                                }
                              },
                        child: _submitting
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Publier mon avis'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _ratingLabel(int r) => switch (r) {
    1 => 'Décevant',
    2 => 'Passable',
    3 => 'Bien',
    4 => 'Très bien',
    5 => 'Excellent !',
    _ => '',
  };
}
