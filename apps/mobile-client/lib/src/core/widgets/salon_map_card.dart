import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../utils/app_haptics.dart';
import 'app_icon.dart';

class SalonMapCard extends StatefulWidget {
  const SalonMapCard({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.salonName,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String salonName;
  final String address;

  @override
  State<SalonMapCard> createState() => _SalonMapCardState();
}

class _SalonMapCardState extends State<SalonMapCard> {
  bool _isPressed = false;

  Future<void> _openMaps() async {
    AppHaptics.light();

    if (kIsWeb) {
      return;
    }

    final encodedName = Uri.encodeComponent(widget.salonName);

    if (Platform.isIOS) {
      final Uri appleUri = Uri.parse('maps://?q=$encodedName&ll=${widget.latitude},${widget.longitude}');
      if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
      } else {
        final Uri fallbackWebUrl = Uri.parse('https://maps.apple.com/?q=$encodedName&ll=${widget.latitude},${widget.longitude}');
        await launchUrl(fallbackWebUrl, mode: LaunchMode.externalApplication);
      }
    } else {
      final Uri androidUri = Uri.parse('geo:${widget.latitude},${widget.longitude}?q=${widget.latitude},${widget.longitude}($encodedName)');
      if (await canLaunchUrl(androidUri)) {
        await launchUrl(androidUri, mode: LaunchMode.externalApplication);
      } else {
        final Uri fallbackWebUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}');
        await launchUrl(fallbackWebUrl, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Subtle background shift on press
    final Color baseBgColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final Color pressedBgColor = isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceElevated;
    final Color bgColor = _isPressed ? pressedBgColor : baseBgColor;
    
    final Color textColor = isDark ? AppColors.darkOnSurface : AppColors.onSurface;
    final Color subtextColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.onSurfaceVariant;
    final Color borderColor = isDark ? AppColors.darkOutline : AppColors.outlineVariant;

    return GestureDetector(
      onTap: _openMaps,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _isPressed ? borderColor.withValues(alpha: 0.8) : borderColor,
              width: 1.2,
            ),
            boxShadow: _isPressed ? AppShadows.sm : AppShadows.card,
          ),
          child: Row(
            children: [
              // Left: small and refined location icon with soft background circle tint
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const AppIcon(
                  'map-pin',
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              // Middle: Left-aligned, stacked typography with tightened line height
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.salonName,
                      style: AppTextStyles.labelMd.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600, // semibold weight
                        height: 1.15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      widget.address,
                      style: AppTextStyles.bodySm.copyWith(
                        color: subtextColor,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              // Right: Subtle, right-facing chevron icon
              AppIcon(
                'chevron-right',
                size: 16,
                color: subtextColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
