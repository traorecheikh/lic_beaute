import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Full-screen gallery viewer with swipeable photos, close button, counter,
/// and bottom page dots.
class SalonGalleryViewer extends StatefulWidget {
  const SalonGalleryViewer({
    required this.images,
    required this.initialIndex,
    super.key,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<SalonGalleryViewer> createState() => _SalonGalleryViewerState();
}

class _SalonGalleryViewerState extends State<SalonGalleryViewer> {
  late final PageController _ctrl;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return AppScaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: widget.images.length,
            itemBuilder: (_, i) => InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: widget.images[i],
                fit: BoxFit.contain,
                placeholder: (_, _) => const Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),

          // Close button
          Positioned(
            top: topPad + 10,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.black54,
                  shape: BoxShape.circle,
                ),
                child: const AppIcon('close', color: AppColors.white, size: 18),
              ),
            ),
          ),

          // Compact, consistently pill-shaped counter.
          Positioned(
            top: topPad + 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 34,
                constraints: const BoxConstraints(minWidth: 64),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppIcon(
                      'image',
                      color: AppColors.white,
                      size: 13,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_current + 1}/${widget.images.length}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom dots
          if (widget.images.length > 1)
            Positioned(
              bottom: botPad + 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: i == _current ? 18 : 5,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i == _current
                          ? AppColors.white
                          : AppColors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppRadius.xs.r),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
