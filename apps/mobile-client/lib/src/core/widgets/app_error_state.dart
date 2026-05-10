import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../network/app_network_error.dart';
import '../network/connectivity_provider.dart';
import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'app_icon_box.dart';
import 'app_state_card.dart';

class AppErrorState extends ConsumerStatefulWidget {
  const AppErrorState({
    this.error,
    this.fallbackTitle,
    this.title,
    this.message,
    this.offlineTitle,
    this.serverTitle,
    this.onRetry,
    this.compact = false,
    super.key,
  });

  final Object? error;
  final String? fallbackTitle;
  final String? title;
  final String? message;
  final String? offlineTitle;
  final String? serverTitle;
  final Future<void> Function()? onRetry;
  final bool compact;

  @override
  ConsumerState<AppErrorState> createState() => _AppErrorStateState();
}

class _AppErrorStateState extends ConsumerState<AppErrorState> {
  bool _retrying = false;

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);
    final resolved = widget.error == null
        ? null
        : resolveAppNetworkError(
            widget.error!,
            isOnline: isOnline,
            offlineTitle: widget.offlineTitle ?? 'Connexion indisponible',
            serverTitle:
                widget.serverTitle ?? 'Service momentanément indisponible',
            fallbackTitle: widget.fallbackTitle ?? 'Une erreur est survenue',
          );
    final title = widget.title ?? resolved?.title ?? 'Une erreur est survenue';
    final message = widget.message ?? resolved?.message ?? 'Réessayez.';
    final type = resolved?.type ?? AppNetworkErrorType.unknown;

    return AppStateCard(
      compact: widget.compact,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconBox(
            size: 52.r,
            color: _iconBackground(type),
            circle: true,
            child: AppIcon(_iconName(type), color: _iconColor(type), size: 24),
          ),
          SizedBox(height: 14.h),
          Text(
            title,
            style: AppTextStyles.headlineSm,
            textAlign: TextAlign.center,
          ),
          gapH8,
          Text(
            message,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.onRetry != null) ...[
            SizedBox(height: 18.h),
            SizedBox(
              width: widget.compact ? double.infinity : 180.w,
              child: FilledButton(
                onPressed: _retrying ? null : _handleRetry,
                style: AppTheme.stateButtonStyle(context),
                child: _retrying
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                    : const Text('Réessayer'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _iconBackground(AppNetworkErrorType type) {
    switch (type) {
      case AppNetworkErrorType.offline:
      case AppNetworkErrorType.timeout:
        return AppColors.secondaryContainer;
      case AppNetworkErrorType.server:
      case AppNetworkErrorType.unauthorized:
      case AppNetworkErrorType.unknown:
        return AppColors.errorContainer;
    }
  }

  Color _iconColor(AppNetworkErrorType type) {
    switch (type) {
      case AppNetworkErrorType.offline:
      case AppNetworkErrorType.timeout:
        return AppColors.secondary;
      case AppNetworkErrorType.server:
      case AppNetworkErrorType.unauthorized:
      case AppNetworkErrorType.unknown:
        return AppColors.error;
    }
  }

  String _iconName(AppNetworkErrorType type) {
    switch (type) {
      case AppNetworkErrorType.offline:
        return 'wifi-off';
      case AppNetworkErrorType.timeout:
        return 'clock';
      case AppNetworkErrorType.server:
        return 'cloud-off';
      case AppNetworkErrorType.unauthorized:
        return 'lock';
      case AppNetworkErrorType.unknown:
        return 'alert-circle';
    }
  }

  Future<void> _handleRetry() async {
    final retry = widget.onRetry;
    if (retry == null || _retrying) return;
    setState(() => _retrying = true);
    try {
      await retry();
    } finally {
      if (mounted) {
        setState(() => _retrying = false);
      }
    }
  }
}
