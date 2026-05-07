import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';

class FaqTile extends StatefulWidget {
  const FaqTile({
    required this.question,
    required this.answer,
    this.padding,
    this.radius,
    this.duration = const Duration(milliseconds: 220),
    super.key,
  });

  final String question;
  final String answer;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Duration duration;

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHaptics.select();
        setState(() => _expanded = !_expanded);
      },
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeOut,
        padding: widget.padding ?? EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            (widget.radius ?? AppRadius.xl).r,
          ),
          border: Border.all(
            color: _expanded ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: AppTextStyles.labelLg.copyWith(
                      color: _expanded
                          ? AppColors.primary
                          : AppColors.onSurface,
                    ),
                  ),
                ),
                gapW8,
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: widget.duration,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22.r,
                    color: _expanded
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (_expanded) ...[
              gapH12,
              Text(
                widget.answer,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
