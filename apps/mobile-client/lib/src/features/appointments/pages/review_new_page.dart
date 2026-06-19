import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_booking_async_scaffold.dart';
import '../../../core/widgets/app_booking_header_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_bottom_bar.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../appointments/models/booking_detail.dart';
import '../../appointments/providers/bookings_list_provider.dart';
import '../../discovery/providers/cached_resource.dart';
import '../providers/booking_actions_provider.dart';

class ReviewNewPage extends ConsumerStatefulWidget {
  final String bookingId;
  const ReviewNewPage({required this.bookingId, super.key});

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
    // Review form scaffold driven by the booking detail resource
    return AppBookingAsyncScaffold<BookingDetail>(
      bookingId: widget.bookingId,
      provider: bookingDetailResourceProvider,
      errorTitle: AppStrings.loadReviewFormError,
      serverTitle: AppStrings.reviewUnavailable,
      bottomNavigationBar: _buildBottomBar(),
      sliverBuilder: (bookingResource) {
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 140.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppBookingHeaderBadge(
                    salonName: bookingResource.salonName,
                    serviceName: bookingResource.serviceName,
                  ),
                  gapH24,
                  Text(
                    AppStrings.howWasExperience,
                    style: AppTextStyles.headlineMd,
                    textAlign: TextAlign.center,
                  ),
                  gapH8,
                  Text(
                    AppStrings.shareReviewPrompt,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  gapH32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      final active = star <= _rating;
                      return AppPressable(
                        onTap: () {
                          AppHaptics.select();
                          setState(() => _rating = star);
                        },
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: AnimatedScale(
                              scale: active ? 1.15 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOutBack,
                              child: Icon(
                                active
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                size: 40.r,
                                color: active
                                    ? AppColors.secondary
                                    : AppColors.outlineVariant,
                              ),
                            ),
                          ),
                      );
                    }),
                  ),
                  gapH32,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppStrings.yourComment, style: AppTextStyles.labelLg),
                  ),
                  gapH12,
                  TextField(
                    controller: _comment,
                    maxLines: 5,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: AppStrings.commentHint,
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }

  Widget _buildBottomBar() {
    return AppBottomBar(
      child: AppButton.primary(
        onPressed: _rating == 0 ? null : _submit,
        label: AppStrings.reviewCta,
        isLoading: _submitting,
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await ref.read(bookingActionsProvider).submitReview(
            bookingId: widget.bookingId,
            rating: _rating,
            comment: _comment.text.trim(),
          );
      if (!mounted) return;
      AppSnackbar.success(context, AppStrings.reviewSuccessMsg);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, AppStrings.reviewSubmitError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
