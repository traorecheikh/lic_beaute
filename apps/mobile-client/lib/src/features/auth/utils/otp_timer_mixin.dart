import 'dart:async';

import 'package:flutter/widgets.dart';

/// Mixin that provides a countdown timer for OTP resend flows.
///
/// Usage:
/// ```dart
/// class _MyPageState extends ConsumerState<MyPage> with OtpTimerMixin {
///   @override
///   void initState() {
///     super.initState();
///     attachOtpTimer(setState);  // <-- required
///   }
///
///   // Call startOtpTimer() when OTP is sent
///   // Call disposeOtpTimer() in dispose()
///   // Access canResend and secondsRemaining in the UI
/// }
/// ```
mixin OtpTimerMixin {
  Timer? _otpTimer;
  int _secondsRemaining = 30;
  bool _canResend = false;
  void Function(VoidCallback)? _setStateFn;

  /// Must be called during initState to wire up setState.
  void attachOtpTimer(void Function(VoidCallback) setStateFn) {
    _setStateFn = setStateFn;
  }

  /// Starts/resets the 30-second countdown.
  void startOtpTimer() {
    _secondsRemaining = 30;
    _canResend = false;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        _canResend = true;
        timer.cancel();
      }
      _setStateFn?.call(() {});
    });
  }

  /// Cancels the timer. Call from dispose().
  void disposeOtpTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
  }

  /// Whether the user can request a new OTP code.
  bool get canResend => _canResend;

  /// Seconds remaining before resend is allowed.
  int get secondsRemaining => _secondsRemaining;
}
