import 'package:flutter/material.dart';

// Native iOS 26+ Liquid Glass sheet safety utilities.
//
// The current `cupertino_native_better` bottom-sheet helpers do not match
// the Flutter SDK pinned in this repo, so these wrappers intentionally
// fall back to the stock Flutter modal APIs for now. Keeping this
// indirection in place lets us restore geometry-aware native wrappers
// once the package side is compatible again.

/// Safe bottom sheet presenter for iOS 26+ with native Liquid Glass.
///
/// Currently uses [showModalBottomSheet] on all platforms.
Future<T?> showSafeBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useSafeArea = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: builder,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
  );
}

/// Placeholder hook for future native-glass sheet protection.
Widget wrapSheetContentForNativeGlass({
  required BuildContext context,
  required Widget child,
}) {
  return child;
}
