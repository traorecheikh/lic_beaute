import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders a custom SVG icon from assets/icons/ with automatic fallback
/// to a Material icon when the SVG hasn't been placed yet.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size,
    this.color,
    this.fallback,
  });

  final String name;
  final double? size;
  final Color? color;
  final IconData? fallback;

  static const _fallbacks = <String, IconData>{
    'compass':        Icons.explore_outlined,
    'calendar':       Icons.calendar_month_outlined,
    'user':           Icons.person_outline,
    'search':         Icons.search_rounded,
    'map-pin':        Icons.location_on_outlined,
    'star':           Icons.star_rounded,
    'heart':          Icons.favorite_border_rounded,
    'heart-filled':   Icons.favorite_rounded,
    'bell':           Icons.notifications_none_rounded,
    'arrow-left':     Icons.arrow_back_ios_new_rounded,
    'close':          Icons.close_rounded,
    'filter':         Icons.tune_rounded,
    'clock':          Icons.schedule_outlined,
    'check':          Icons.check_circle_outline_rounded,
    'sparkle':        Icons.auto_awesome_outlined,
    'share':          Icons.ios_share_rounded,
    'chevron-right':  Icons.chevron_right_rounded,
    'add':            Icons.add_rounded,
    'minus':          Icons.remove_rounded,
    'image':          Icons.image_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final s = (size ?? 24).w;
    final col = color ?? IconTheme.of(context).color;

    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: s,
      height: s,
      colorFilter: col != null
          ? ColorFilter.mode(col, BlendMode.srcIn)
          : null,
      placeholderBuilder: (_) => Icon(
        fallback ?? _fallbacks[name] ?? Icons.circle_outlined,
        size: s,
        color: col,
      ),
    );
  }
}
