import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/booking_actions_provider.dart';
import '../providers/bookings_list_provider.dart';
import '../utils/review_prompt_manager.dart';

/// Shows an inline review bottom sheet for [bookingId].
///
/// Pass [logoUrl] so the sheet header shows the salon's actual logo.
/// Set [proactive] = true when triggered automatically (adds dismiss options).
///
/// Returns `true` if the review was submitted, `false` / `null` otherwise.
Future<bool?> showReviewSheet(
  BuildContext context, {
  required String bookingId,
  required String salonName,
  required String serviceName,
  String? logoUrl,
  bool proactive = false,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl.r)),
    ),
    builder: (ctx) => _ReviewSheet(
      bookingId: bookingId,
      salonName: salonName,
      serviceName: serviceName,
      logoUrl: logoUrl,
      proactive: proactive,
    ),
  );
}

// ── Internal sheet widget ────────────────────────────────────────────────────

class _ReviewSheet extends ConsumerStatefulWidget {
  const _ReviewSheet({
    required this.bookingId,
    required this.salonName,
    required this.serviceName,
    required this.logoUrl,
    required this.proactive,
  });

  final String bookingId;
  final String salonName;
  final String serviceName;
  final String? logoUrl;
  final bool proactive;

  @override
  ConsumerState<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<_ReviewSheet>
    with SingleTickerProviderStateMixin {
  int _rating = 0;
  int _hoveredRating = 0;
  final _comment = TextEditingController();
  bool _submitting = false;
  bool _showComment = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _onStarTap(int star) {
    AppHaptics.select();
    setState(() {
      _rating = star;
      _showComment = star > 0;
    });
  }

  Future<void> _submit() async {
    if (_rating == 0) return;
    setState(() => _submitting = true);
    try {
      await ref.read(bookingActionsProvider).submitReview(
            bookingId: widget.bookingId,
            rating: _rating,
            comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
          );
      ref.invalidate(bookingsListProvider);
      await ReviewPromptManager.permanentlySuppress(widget.bookingId);
      if (!mounted) return;
      AppSnackbar.success(context, AppStrings.reviewSuccessMsg);
      Navigator.of(context, rootNavigator: true).pop(true);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.error(context, AppStrings.reviewSubmitError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _dismiss() async {
    if (widget.proactive) {
      await ReviewPromptManager.recordDismissed(widget.bookingId);
    }
    if (mounted) Navigator.of(context, rootNavigator: true).pop(false);
  }

  Future<void> _neverAgain() async {
    await ReviewPromptManager.permanentlySuppress(widget.bookingId);
    if (mounted) Navigator.of(context, rootNavigator: true).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header with salon logo ────────────────────────────────────────
          _SheetHeader(
            salonName: widget.salonName,
            serviceName: widget.serviceName,
            logoUrl: widget.logoUrl,
          ),
          gapH24,

          // ── Question ──────────────────────────────────────────────────────
          Text(
            AppStrings.howWasExperienceInline,
            style: AppTextStyles.headlineMd,
            textAlign: TextAlign.center,
          ),
          gapH4,
          Text(
            widget.salonName,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          gapH24,

          // ── Stars ─────────────────────────────────────────────────────────
          _StarRow(
            rating: _rating,
            hovered: _hoveredRating,
            onTap: _onStarTap,
            onHover: (s) => setState(() => _hoveredRating = s),
          ),
          gapH8,
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _rating == 0
                ? Text(
                    AppStrings.tapStarToRate,
                    key: const ValueKey('hint'),
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    _ratingLabel(_rating),
                    key: ValueKey(_rating),
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
          gapH20,

          // ── Comment (slides in after star selection) ──────────────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _showComment
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _CommentField(controller: _comment),
            secondChild: const SizedBox.shrink(),
          ),

          if (_showComment) gapH20,

          // ── Primary CTA ───────────────────────────────────────────────────
          AppButton.primary(
            onPressed: _rating == 0 ? null : _submit,
            label: AppStrings.reviewCta,
            isLoading: _submitting,
          ),
          gapH12,

          // ── Dismiss row ───────────────────────────────────────────────────
          if (widget.proactive) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TextLink(label: AppStrings.later, onTap: _dismiss),
                SizedBox(width: 24.w),
                _TextLink(
                  label: AppStrings.neverShowAgain,
                  onTap: _neverAgain,
                  faint: true,
                ),
              ],
            ),
          ] else ...[
            _TextLink(label: AppStrings.cancel, onTap: _dismiss),
          ],
        ],
      ),
    );
  }

  String _ratingLabel(int r) => switch (r) {
        1 => AppStrings.rating1,
        2 => AppStrings.rating2,
        3 => AppStrings.rating3,
        4 => AppStrings.rating4,
        _ => AppStrings.rating5,
      };
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.salonName,
    required this.serviceName,
    required this.logoUrl,
  });

  final String salonName;
  final String serviceName;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final hasLogo = logoUrl != null && logoUrl!.isNotEmpty;

    return Row(
      children: [
        // Salon logo — same size/radius as BookingListTile
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          child: hasLogo
              ? CachedNetworkImage(
                  imageUrl: logoUrl!,
                  width: 48.r,
                  height: 48.r,
                  memCacheWidth: 96,
                  memCacheHeight: 96,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => _LogoFallback(),
                )
              : _LogoFallback(),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                salonName,
                style: AppTextStyles.labelLg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                serviceName,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppIconBox(
      size: 48.r,
      color: AppColors.primaryLight,
      radius: BorderRadius.circular(AppRadius.md.r),
      child: AppIcon('sparkle', size: 20, color: AppColors.primary),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({
    required this.rating,
    required this.hovered,
    required this.onTap,
    required this.onHover,
  });

  final int rating;
  final int hovered;
  final ValueChanged<int> onTap;
  final ValueChanged<int> onHover;

  @override
  Widget build(BuildContext context) {
    final effective = hovered > 0 ? hovered : rating;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final star = i + 1;
        final active = star <= effective;
        return AppPressable(
          onTap: () => onTap(star),
          child: MouseRegion(
            onEnter: (_) => onHover(star),
            onExit: (_) => onHover(0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: AnimatedScale(
                scale: active ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutBack,
                child: Icon(
                  active ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 44.r,
                  color: active
                      ? AppColors.secondary
                      : AppColors.outlineVariant,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _CommentField extends StatelessWidget {
  const _CommentField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.commentOptional, style: AppTextStyles.labelMd),
        gapH8,
        TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 500,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: AppStrings.commentShareHint,
            hintStyle: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            contentPadding: EdgeInsets.all(16.r),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              borderSide: BorderSide.none,
            ),
            counterStyle: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _TextLink extends StatelessWidget {
  const _TextLink({
    required this.label,
    required this.onTap,
    this.faint = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool faint;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        child: Text(
          label,
          style: AppTextStyles.bodyMd.copyWith(
            color: faint ? AppColors.onSurfaceVariant : AppColors.primary,
            decoration: TextDecoration.underline,
            decorationColor:
                faint ? AppColors.onSurfaceVariant : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
