import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';

/// Compact confirmation sheet shown after the payment application is opened.
///
/// It deliberately exposes only the actions a customer needs:
/// verify, return to the existing attempt, restart when no launch target is
/// available, or close while verification continues in the background.
class PaymentWaitingSheet extends StatefulWidget {
  const PaymentWaitingSheet({
    required this.paymentId,
    required this.onConfirmed,
    required this.onFailed,
    required this.reconcile,
    this.onCloseRequested,
    this.onReopenPreferred,
    this.preferredLaunchLabel,
    this.onReopenSecondary,
    this.secondaryLaunchLabel,
    this.onOpenHosted,
    this.hostedLaunchLabel,
    this.onRestartPayment,
    this.pendingProviderConfirmation = false,
    super.key,
  });

  final String paymentId;
  final VoidCallback onConfirmed;
  final void Function(String message) onFailed;
  final VoidCallback? onCloseRequested;
  final Future<void> Function()? onReopenPreferred;
  final String? preferredLaunchLabel;
  final Future<void> Function()? onReopenSecondary;
  final String? secondaryLaunchLabel;
  final Future<void> Function()? onOpenHosted;
  final String? hostedLaunchLabel;
  final Future<void> Function()? onRestartPayment;
  final Future<String?> Function(String paymentId) reconcile;
  final bool pendingProviderConfirmation;

  @override
  State<PaymentWaitingSheet> createState() => _PaymentWaitingSheetState();
}

class _PaymentWaitingSheetState extends State<PaymentWaitingSheet>
    with WidgetsBindingObserver {
  static const _pollInterval = Duration(seconds: 6);
  static const _timeout = Duration(minutes: 5);
  static const _maxConsecutiveFailures = 3;

  bool _manualChecking = false;
  bool _backgroundChecking = false;
  bool _actionLoading = false;
  bool _closeRequested = false;
  int _elapsed = 0;
  int _consecutiveFailures = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startPolling();
    unawaited(_runCheck(showLoading: false));
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    _consecutiveFailures = 0;
    if (_timer == null && _elapsed < _timeout.inSeconds) {
      _startPolling();
    }
    unawaited(_runCheck(showLoading: false));
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(_pollInterval, (_) async {
      _elapsed += _pollInterval.inSeconds;
      if (_elapsed >= _timeout.inSeconds) {
        _timer?.cancel();
        _timer = null;
        if (mounted) setState(() {});
        return;
      }
      await _runCheck(showLoading: false);
    });
  }

  Future<void> _check() async {
    _consecutiveFailures = 0;
    await _runCheck(showLoading: true);
  }

  Future<void> _runCheck({required bool showLoading}) async {
    if (_backgroundChecking ||
        _manualChecking ||
        !mounted ||
        _closeRequested) {
      return;
    }

    if (showLoading) {
      setState(() => _manualChecking = true);
    } else {
      _backgroundChecking = true;
    }

    try {
      final status = await widget.reconcile(widget.paymentId);
      if (!mounted) return;
      _consecutiveFailures = 0;
      if (status == 'succeeded') {
        _timer?.cancel();
        widget.onConfirmed();
      } else if (status == 'failed' || status == 'refunded') {
        _timer?.cancel();
        widget.onFailed('Le paiement n’a pas abouti. Vous pouvez le relancer.');
      }
    } catch (_) {
      _consecutiveFailures++;
      if (_consecutiveFailures >= _maxConsecutiveFailures) {
        _timer?.cancel();
        _timer = null;
      }
    } finally {
      _backgroundChecking = false;
      if (mounted) setState(() => _manualChecking = false);
    }
  }

  Future<void> _runExternalAction(Future<void> Function() action) async {
    if (_actionLoading) return;
    setState(() => _actionLoading = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> Function()? get _reopenAction =>
      widget.onReopenPreferred ??
      widget.onOpenHosted ??
      widget.onReopenSecondary;

  String get _reopenLabel => AppStrings.paymentReopen;

  void _handleClose() {
    _closeRequested = true;
    widget.onCloseRequested?.call();
  }

  @override
  Widget build(BuildContext context) {
    final timedOut = _elapsed >= _timeout.inSeconds;
    final networkLost = _consecutiveFailures >= _maxConsecutiveFailures;
    final status = _statusPresentation(
      networkLost: networkLost,
      timedOut: timedOut,
    );
    final reopenAction = _reopenAction;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(color: AppColors.outlineVariant),
          boxShadow: AppShadows.sheet,
        ),
        padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Column(
                key: ValueKey(status.title),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58.r,
                    height: 58.r,
                    decoration: BoxDecoration(
                      color: status.iconBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: status.loading
                          ? SizedBox(
                              width: 26.r,
                              height: 26.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.6,
                                color: status.iconColor,
                              ),
                            )
                          : AppIcon(
                              status.iconName,
                              color: status.iconColor,
                              size: 26,
                            ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    status.title,
                    style: AppTextStyles.headlineMd,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    status.body,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            AppButton.primary(
              label: AppStrings.paymentRetry,
              onPressed: _manualChecking || _actionLoading
                  ? null
                  : () => unawaited(_check()),
              isLoading: _manualChecking,
            ),
            SizedBox(height: 10.h),
            if (reopenAction != null)
              AppButton.outline(
                label: _reopenLabel,
                onPressed: _actionLoading
                    ? null
                    : () => unawaited(_runExternalAction(reopenAction)),
                isLoading: _actionLoading,
              )
            else if (widget.onRestartPayment != null)
              AppButton.outline(
                label: AppStrings.paymentRestart,
                onPressed: _actionLoading
                    ? null
                    : () => unawaited(
                        _runExternalAction(widget.onRestartPayment!),
                      ),
                isLoading: _actionLoading,
              ),
            if (widget.onCloseRequested != null) ...[
              SizedBox(height: 6.h),
              Center(
                child: AppPressable(
                  onTap: _handleClose,
                  minSize: const Size(44, 44),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 9.h,
                    ),
                    child: Text(
                      AppStrings.paymentCloseAndContinue,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _PaymentWaitingStatus _statusPresentation({
    required bool networkLost,
    required bool timedOut,
  }) {
    if (networkLost) {
      return const _PaymentWaitingStatus(
        iconName: 'wifi-off',
        iconColor: AppColors.error,
        iconBackground: AppColors.errorContainer,
        title: AppStrings.paymentNetworkLostTitle,
        body: AppStrings.paymentNetworkLostBody,
      );
    }
    if (timedOut) {
      return const _PaymentWaitingStatus(
        iconName: 'clock',
        iconColor: AppColors.warning,
        iconBackground: AppColors.warningContainer,
        title: AppStrings.paymentPendingTitle,
        body: AppStrings.paymentPendingBody,
      );
    }
    return const _PaymentWaitingStatus(
      iconName: 'wallet',
      iconColor: AppColors.primary,
      iconBackground: AppColors.primaryLight,
      title: AppStrings.paymentWaitingTitle,
      body: AppStrings.paymentWaitingBody,
      loading: true,
    );
  }
}

class _PaymentWaitingStatus {
  const _PaymentWaitingStatus({
    required this.iconName,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.body,
    this.loading = false,
  });

  final String iconName;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String body;
  final bool loading;
}
