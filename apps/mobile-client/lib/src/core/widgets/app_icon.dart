import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  });

  final String name;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    final s = (size ?? 24).w;
    final col = color ?? IconTheme.of(context).color;

    final svg = SvgPicture.asset(
      'assets/icons/$name.svg',
      width: s,
      height: s,
      colorFilter: col != null ? ColorFilter.mode(col, BlendMode.srcIn) : null,
      excludeFromSemantics: excludeFromSemantics || semanticLabel != null,
    );

    if (excludeFromSemantics || semanticLabel == null) return svg;

    return Semantics(
      label: semanticLabel,
      child: svg,
    );
  }
}
