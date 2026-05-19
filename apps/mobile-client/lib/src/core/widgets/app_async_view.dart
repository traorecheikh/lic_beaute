import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_error_state.dart';

/// Wraps AsyncValue.when with the standard loading/error/data shell.
///
/// Set [sliver] to true when used inside a CustomScrollView — the loading
/// and error states are wrapped in SliverToBoxAdapter automatically.
class AppAsyncView<T> extends StatelessWidget {
  const AppAsyncView({
    required this.value,
    required this.builder,
    this.errorTitle,
    this.serverTitle,
    this.onRetry,
    this.loadingWidget,
    this.sliver = false,
    this.keepDataOnReload = false,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final String? errorTitle;
  final String? serverTitle;
  final Future<void> Function()? onRetry;
  final Widget? loadingWidget;
  final bool sliver;
  // When true, keeps showing previous data during a reload instead of a spinner.
  final bool keepDataOnReload;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: keepDataOnReload,
      loading: () => _wrap(
        loadingWidget ?? const Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (error, _) => _wrap(
        Padding(
          padding: EdgeInsets.all(24.r),
          child: AppErrorState(
            error: error,
            fallbackTitle: errorTitle,
            serverTitle: serverTitle,
            onRetry: onRetry,
          ),
        ),
      ),
      data: builder,
    );
  }

  Widget _wrap(Widget child) {
    if (!sliver) return child;
    return SliverToBoxAdapter(child: child);
  }
}
