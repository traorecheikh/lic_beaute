import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

abstract final class AppShare {
  /// Share plain text (salon link, booking ref, etc.)
  static Future<void> text(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }

  /// Render [card] to PNG and open the native share sheet.
  static Future<void> card({
    required BuildContext context,
    required Widget card,
    String filename = 'partage.png',
  }) async {
    final ctrl = ScreenshotController();
    final bytes = await ctrl.captureFromLongWidget(
      card,
      pixelRatio: 3.0,
      context: context,
    );
    await _shareBytes(bytes, filename);
  }

  static Future<void> _shareBytes(Uint8List bytes, String filename) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shareable booking card widget (rendered off-screen to PNG)
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
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
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
                    Image.asset('assets/logo.png', width: 28, height: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Beauté Avenue',
                      style: AppTextStyles.labelMd.copyWith(
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  salonName,
                  style: AppTextStyles.displaySm.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  service,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _Row(icon: Icons.calendar_today_rounded, label: '$date · $time'),
                const SizedBox(height: 14),
                _Row(icon: Icons.person_outline_rounded, label: staffName),
                if (price.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _Row(icon: Icons.payments_outlined, label: price),
                ],
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Réservé sur Beauté Avenue',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0.5,
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
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
          ),
        ),
      ],
    );
  }
}
