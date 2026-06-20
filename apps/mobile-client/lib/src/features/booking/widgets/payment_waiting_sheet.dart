import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';

/// Bottom sheet that polls for payment confirmation.
/// Shows loading state, timeout state, and network error state.
/// Provides buttons to re-open the payment app / hosted page.
class PaymentWaitingSheet extends StatefulWidget {
  const PaymentWaitingSheet({
    required this.paymentId,
    required this.onConfirmed,
    required this.onFailed,
    this.onCloseRequested,
    this.onReopenPreferred,
    this.preferredLaunchLabel,
    this.onReopenSecondary,
    this.secondaryLaunchLabel,
    this.onOpenHosted,
    this.hostedLaunchLabel,
    required this.reconcile,
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
    if (state == AppLifecycleState.resumed) {
      _consecutiveFailures = 0;
      if (_timer == null && _elapsed < _timeout.inSeconds) {
        _startPolling();
      }
      unawaited(_runCheck(showLoading: false));
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(_pollInterval, (_) async {
      _elapsed += _pollInterval.inSeconds;
      if (_elapsed >= _timeout.inSeconds) {
        _timer?.cancel();
        if (mounted) setState(() {}); // trigger rebuild to show timed-out UI
        return;
      }
      await _runCheck(showLoading: false);
    });
  }

  Future<void> _check() async {
    _consecutiveFailures = 0;
    await _runCheck(showLoading: true);
  }

  void _handleClose() {
    _closeRequested = true;
    widget.onCloseRequested?.call();
  }

  Future<void> _runCheck({required bool showLoading}) async {
    if ((_backgroundChecking || _manualChecking) || !mounted || _closeRequested) return;
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
        widget.onFailed('Le paiement a échoué. Veuillez réessayer.');
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

  @override
  Widget build(BuildContext context) {
    final timedOut = _elapsed >= _timeout.inSeconds;
    final networkLost = _consecutiveFailures >= _maxConsecutiveFailures;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 28.h),
            if (networkLost) ...[
              AppIcon('wifi-off', color: AppColors.onSurfaceVariant, size: 48),
              SizedBox(height: 20.h),
              Text(
                'Connexion perdue',
                style: AppTextStyles.labelLg,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Vérifiez votre connexion internet et réessayez.',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ] else if (!timedOut) ...[
              SizedBox(
                width: 48.r,
                height: 48.r,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Vérification en cours…',
                style: AppTextStyles.labelLg,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Complétez le paiement dans votre application, puis revenez ici.',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              AppIcon('clock', color: AppColors.onSurfaceVariant, size: 48),
              SizedBox(height: 20.h),
              Text(
                'En attente de confirmation',
                style: AppTextStyles.labelLg,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Le paiement sera confirmé automatiquement dès que votre opérateur nous notifie. Vous pouvez fermer cette fenêtre.',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 24.h),
            AppButton.outline(
              label: _manualChecking ? 'Vérification…' : 'Vérifier maintenant',
              onPressed: _manualChecking ? null : _check,
              isLoading: _manualChecking,
            ),
            if (widget.onReopenPreferred != null) ...[
              SizedBox(height: 12.h),
              AppButton.outline(
                label:
                    'Ouvrir ${widget.preferredLaunchLabel ?? 'le moyen de paiement'}',
                onPressed: () => widget.onReopenPreferred!(),
              ),
            ],
            if (widget.onReopenSecondary != null) ...[
              SizedBox(height: 12.h),
              AppButton.outline(
                label:
                    'Ouvrir ${widget.secondaryLaunchLabel ?? 'l’autre application'}',
                onPressed: () => widget.onReopenSecondary!(),
              ),
            ],
            if (widget.onOpenHosted != null) ...[
              SizedBox(height: 12.h),
              AppButton.outline(
                label:
                    'Ouvrir ${widget.hostedLaunchLabel ?? 'la page PayDunya'}',
                onPressed: () => widget.onOpenHosted!(),
              ),
            ],
            if (timedOut) ...[
              SizedBox(height: 12.h),
              AppButton.primary(
                label: AppStrings.closeDialog,
                onPressed: _handleClose,
              ),
            ],
            SizedBox(height: 8.h),
            // Always-visible close button with confirmation
            if (!timedOut && widget.onCloseRequested != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: TextButton.icon(
                  onPressed: _handleClose,
                  icon: AppIcon('x', color: AppColors.onSurfaceVariant, size: 18),
                  label: Text(
                    AppStrings.closeDialog,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
