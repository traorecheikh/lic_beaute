import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_error_state.dart';

class AppResourceView<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Future<void> Function() onRetry;
  final Widget Function(T data) builder;
  final String? errorTitle;
  final String? emptyMessage;

  const AppResourceView({
    required this.value,
    required this.onRetry,
    required this.builder,
    this.errorTitle,
    this.emptyMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) => AppErrorState(
        error: error,
        fallbackTitle: errorTitle ?? 'Une erreur est survenue',
        onRetry: onRetry,
      ),
      data: (data) {
        if (data == null) {
          return AppErrorState(
            title: errorTitle ?? 'Indisponible',
            message: emptyMessage ?? 'Veuillez réessayer plus tard.',
            onRetry: onRetry,
          );
        }
        return builder(data);
      },
    );
  }
}
