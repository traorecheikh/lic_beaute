import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'app_icon.dart';
import 'app_icon_box.dart';

/// A sliver that renders the standard circular back button row, wrapped in
/// [SliverSafeArea] so it respects the top safe area inset.
///
/// Replaces the recurring:
///   SliverSafeArea(
///     bottom: false,
///     sliver: SliverToBoxAdapter(
///       child: Padding(
///         padding: EdgeInsets.fromLTRB(N.w, 8.h, N.w, 0),
///         child: Row(children: [GestureDetector → AppIconBox(circle) → AppIcon('arrow-left')]),
///       ),
///     ),
///   )
class AppSliverBackButton extends StatelessWidget {
  const AppSliverBackButton({this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      bottom: false,
      sliver: SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: onPressed ?? () => Navigator.of(context).pop(),
                child: AppIconBox(
                  circle: true,
                  color: AppColors.surface,
                  shadow: AppShadows.sm,
                  child: AppIcon(
                    'arrow-left',
                    size: 18,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
