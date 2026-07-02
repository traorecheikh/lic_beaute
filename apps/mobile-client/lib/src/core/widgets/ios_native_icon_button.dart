import 'package:cupertino_native_better/components/button.dart';
import 'package:cupertino_native_better/style/sf_symbol.dart';
import 'package:flutter/cupertino.dart';

/// Maps the app's icon names to native SF Symbols.
String _sfSymbolName(String iconName) {
  switch (iconName) {
    case 'bell':
      return 'bell';
    case 'bell-fill':
      return 'bell.fill';
    case 'arrow-left':
    case 'chevron-left':
      return 'chevron.left';
    case 'x':
    case 'close':
      return 'xmark';
    case 'share':
      return 'square.and.arrow.up';
    case 'heart':
    case 'favorite':
      return 'heart';
    case 'heart-filled':
    case 'heart-fill':
    case 'favorite-fill':
      return 'heart.fill';
    case 'ellipsis':
    case 'more':
      return 'ellipsis';
    case 'edit':
      return 'pencil';
    case 'filter':
      return 'line.3.horizontal.decrease';
    case 'search':
      return 'magnifyingglass';
    case 'calendar':
      return 'calendar';
    default:
      return 'circle';
  }
}

/// Native iOS 26+ circular Liquid Glass icon button.
///
/// The icon foreground and the glass tint are intentionally separate. Passing
/// the same white value for both can make a symbol disappear into its own
/// control, which is a surprisingly efficient way to create an invisible
/// button.
class IOSNativeIconButton extends StatelessWidget {
  const IOSNativeIconButton({
    required this.iconName,
    this.foregroundColor,
    this.tintColor,
    this.onPressed,
    this.badgeCount,
    this.semanticLabel,
    this.symbolSize = 20,
    super.key,
  });

  final String iconName;
  final Color? foregroundColor;
  final Color? tintColor;
  final VoidCallback? onPressed;
  final int? badgeCount;
  final String? semanticLabel;
  final double symbolSize;

  @override
  Widget build(BuildContext context) {
    final button = CNButton.icon(
      icon: CNSymbol(
        _sfSymbolName(iconName),
        size: symbolSize,
        color: foregroundColor,
      ),
      onPressed: onPressed,
      tint: tintColor,
      badgeCount: badgeCount,
    );

    if (semanticLabel == null) return button;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: button,
    );
  }
}
