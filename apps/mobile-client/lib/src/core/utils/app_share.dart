import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:beauteavenue_mobile_client/src/core/constants/app_contacts.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../widgets/app_icon.dart';

abstract final class AppShare {
  /// Share plain text (salon link, booking ref, etc.)
  static Future<void> text(String text, {String? subject}) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }

  /// Render the widget wrapped by [repaintKey]'s [RepaintBoundary] to PNG
  /// and open the native share sheet. Shows a loading spinner while painting.
  static Future<void> card({
    required BuildContext context,
    required GlobalKey repaintKey,
    String filename = 'partage.png',
    String? text,
  }) async {
    // Show loading spinner
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator.adaptive()),
    );

    try {
      final boundary = repaintKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final bytes = byteData!.buffer.asUint8List();

      if (context.mounted) Navigator.of(context).pop(); // close spinner
      await _shareBytes(bytes, filename, text: text);
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      rethrow;
    }
  }

  static Future<void> _shareBytes(
    Uint8List bytes,
    String filename, {
    String? text,
  }) async {
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
// Shareable cards (rendered via RepaintBoundary)
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
        _Row(icon: 'calendar', label: '$date · $time'),
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
    this.photoUrl,
    this.logoUrl,
    this.rating,
    this.reviewCount,
  });

  final String salonName;
  final String category;
  final String location;
  final String? photoUrl;
  final String? logoUrl;
  final double? rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    final hasReviews = rating != null && (reviewCount ?? 0) > 0;
    return SizedBox(
      width: 380,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: AspectRatio(
          aspectRatio: 1.91,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (photoUrl != null && photoUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: photoUrl!,
                  fit: BoxFit.cover,
                )
              else
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF40202E), Color(0xFF1D1616)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.35, 0.7, 1.0],
                    colors: [
                      AppColors.black.withValues(alpha: 0.18),
                      AppColors.black.withValues(alpha: 0.08),
                      AppColors.black.withValues(alpha: 0.48),
                      AppColors.black.withValues(alpha: 0.78),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (logoUrl != null && logoUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: logoUrl!,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/logo.png',
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Beauté Avenue',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.labelLg.copyWith(
                              fontSize: 14,
                              color: AppColors.white,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.14),
                            ),
                          ),
                          child: Text(
                            'beauteavenue.sn',
                            style: AppTextStyles.labelMd.copyWith(
                              fontSize: 11,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      salonName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.displaySm.copyWith(
                        color: AppColors.white,
                        fontSize: 24,
                        height: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyLg.copyWith(
                              fontSize: 14,
                              color: AppColors.white.withValues(alpha: 0.86),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (hasReviews) ...[
                          const SizedBox(width: 10),
                          AppIcon(
                            'star',
                            size: 14,
                            color: const Color(0xFFFFD36B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${rating!.toStringAsFixed(1)} · ${reviewCount!} avis',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMd.copyWith(
                              fontSize: 13,
                              color: AppColors.white.withValues(alpha: 0.92),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppIcon(
                          'map-pin',
                          size: 16,
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMd.copyWith(
                              fontSize: 13,
                              height: 1.3,
                              color: AppColors.white.withValues(alpha: 0.92),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Partage via Beauté Avenue · ${AppContacts.websiteUrl}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelMd.copyWith(
                        fontSize: 11,
                        color: AppColors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
                        fontSize: 15,
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
                    fontSize: 16,
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
                      fontSize: 13,
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
              fontSize: 16,
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
