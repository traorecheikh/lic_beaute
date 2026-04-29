import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_snackbar.dart';

class ReviewNewPage extends StatefulWidget {
  final String bookingId;
  const ReviewNewPage({super.key, required this.bookingId});

  @override
  State<ReviewNewPage> createState() => _ReviewNewPageState();
}

class _ReviewNewPageState extends State<ReviewNewPage> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon('arrow-left', size: 22, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Laisser un avis', style: AppTextStyles.headlineMd),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Salon name
            Text(
              'Maison Kinka',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              "Comment s'est passé votre expérience ?",
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineLg.copyWith(height: 1.2),
            ),
            SizedBox(height: 40.h),
            // Star rating
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
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: AnimatedScale(
                      scale: filled ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        filled ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: filled ? const Color(0xFFFFC107) : AppColors.outline,
                        size: 44.r,
                      ),
                    ),
                  ),
                );
              }),
            ),
            if (_rating > 0) ...[
              SizedBox(height: 12.h),
              Text(
                _ratingLabel(_rating),
                style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
              ),
            ],
            SizedBox(height: 40.h),
            // Comment field
            TextField(
              controller: _commentController,
              maxLines: 5,
              maxLength: 500,
              style: AppTextStyles.bodyMd,
              decoration: InputDecoration(
                hintText: 'Partagez votre expérience en détail...',
                hintStyle: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                alignLabelWithHint: true,
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: EdgeInsets.all(16.r),
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating == 0
                    ? null
                    : () {
                        AppHaptics.medium();
                        AppSnackbar.success(context, 'Merci pour votre avis !');
                        Future.delayed(const Duration(milliseconds: 800), () {
                          if (context.mounted) context.pop();
                        });
                      },
                child: const Text('Publier mon avis'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1: return 'Très décevant';
      case 2: return 'Décevant';
      case 3: return 'Correct';
      case 4: return 'Très bien';
      case 5: return 'Excellent !';
      default: return '';
    }
  }
}
