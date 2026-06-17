import 'package:flutter/widgets.dart';

class AppPressable extends StatefulWidget {
  const AppPressable({
    required this.child,
    this.onTap,
    this.opacity = 0.5,
    this.duration = const Duration(milliseconds: 200),
    this.enabled = true,
    this.minSize,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double opacity;
  final Duration duration;
  final bool enabled;
  /// Minimum touch target size for accessibility (WCAG SC 2.5.8).
  /// Defaults to 44x44 logical pixels when [onTap] is non-null.
  final Size? minSize;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) {
    setState(() => _pressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _pressed = false);
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
  }

  void _onTap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMinSize = widget.minSize ??
        (widget.onTap != null ? const Size(44, 44) : Size.zero);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? _onTap : null,
      onTapDown: widget.enabled ? _onTapDown : null,
      onTapUp: widget.enabled ? _onTapUp : null,
      onTapCancel: widget.enabled ? _onTapCancel : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: effectiveMinSize.width,
          minHeight: effectiveMinSize.height,
        ),
        child: AnimatedOpacity(
          opacity: !widget.enabled ? 0.4 : (_pressed ? widget.opacity : 1.0),
          duration: widget.duration,
          child: widget.child,
        ),
      ),
    );
  }
}
