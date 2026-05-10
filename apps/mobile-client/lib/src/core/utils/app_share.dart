import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../widgets/app_icon.dart';

abstract final class AppShare {
  /// Share plain text (salon link, booking ref, etc.)
  static Future<void> text(String text, {String? subject}) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }

  /// Render [card] to PNG and open the native share sheet.
  static Future<void> card({
    required BuildContext context,
    required Widget card,
    String filename = 'partage.png',
    String? text,
  }) async {
    final ctrl = ScreenshotController();
    final bytes = await ctrl.captureFromLongWidget(
      card,
      pixelRatio: 3.0,
      context: context,
    );
    await _shareBytes(bytes, filename, text: text);
  }

  static Future<void> _shareBytes(Uint8List bytes, String filename, {String? text}) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path, mimeType: 'image/png')],
      text: text,
    ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shareable cards (rendered off-screen to PNG)
// ─────────────────────────────────────────────────────────────────────────────

class BookingShareCard extends StatelessWidget {
  const BookingShareCard({
    super.key,
    required this.salonName,
    required this.service,
    required this.date,
    required this.time,
    required this.staffName,
    this.price = '',
  });

  final String salonName;
  final String service;
  final String date;
  final String time;
  final String staffName;
  final String price;

  @override
  Widget build(BuildContext context) {
    return _BaseShareCard(
      title: salonName,
      subtitle: service,
      children: [
        _Row(
          icon: 'calendar',
          label: '$date · $time',
        ),
        const SizedBox(height: 14),
        _Row(icon: 'user', label: staffName),
        if (price.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Row(icon: 'credit-card', label: price),
        ],
      ],
    );
  }
}

class SalonShareCard extends StatelessWidget {
  const SalonShareCard({
    super.key,
    required this.salonName,
    required this.category,
    required this.location,
    this.rating,
  });

  final String salonName;
  final String category;
  final String location;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    return _BaseShareCard(
      title: salonName,
      subtitle: category,
      children: [
        _Row(
          icon: 'map-pin',
          label: location,
        ),
        if (rating != null) ...[
          const SizedBox(height: 14),
          _Row(
            icon: 'star',
            label: '$rating / 5.0',
          ),
        ],
      ],
    );
  }
}

class _BaseShareCard extends StatelessWidget {
  const _BaseShareCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D1520), Color(0xFF1A1614)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/logo.png', width: 32, height: 32),
                    const SizedBox(width: 10),
                    Text(
                      'Beauté Avenue',
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.white,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: AppTextStyles.displaySm.copyWith(
                    color: AppColors.white,
                    fontSize: 26,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                ...children,
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Découvrez sur Beauté Avenue',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyLg.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

