import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppSheet {
  /// Shows a modal bottom sheet with the app-standard shape, drag handle, and
  /// root navigator. [builder] receives the sheet's own [BuildContext].
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool useRootNavigator = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: builder,
    );
  }
}
