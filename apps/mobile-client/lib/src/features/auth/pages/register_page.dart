import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../providers/auth_provider.dart';
import '../utils/auth_router_helper.dart';
import '../utils/auth_errors.dart';
import '../widgets/auth_form_widgets.dart';

final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _codeSent = false;
  bool _submitting = false;
  Timer? _timer;
  int _secondsRemaining = 30;
  bool _canResend = false;

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      title: _codeSent ? AppStrings.authVerificationTitle : AppStrings.authCreateAccount,
      subtitle: _codeSent
          ? AppStrings.authCode6Digits
          : AppStrings.authEnterEmailCode,
      body: Form(
        key: _codeSent ? null : _formKey,
        autovalidateMode: _codeSent ? null : AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_codeSent) ...[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppStrings.authEmailUppercase,
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(color: AppColors.error, width: 1.2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(color: AppColors.error, width: 1.8),
                  ),
                  hintStyle: AppTextStyles.bodyLg.copyWith(color: AppColors.outline),
                ),
                style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurface),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.authEmailRequired;
                  }
                  if (!_emailRegex.hasMatch(value.trim())) {
                    return AppStrings.authInvalidEmail;
                  }
                  return null;
                },
              ),
              SizedBox(height: 48.h),
              AuthPrimaryButton(
                label: AppStrings.authReceiveCode,
                loading: _submitting,
                onTap: _requestCode,
              ),
              SizedBox(height: 24.h),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_submitting) return;
                    context.push(AppRoutes.emailLogin);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      AppStrings.authAlreadyAccount,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: AppStrings.authEmailUppercase,
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md.r),
                          borderSide: BorderSide(
                            color: AppColors.outline.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                      ),
                      style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      AppStrings.authOtpCodeLabel,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Pinput(
                      length: 6,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      defaultPinTheme: PinTheme(
                        width: 48.w,
                        height: 56.h,
                        textStyle: AppTextStyles.headlineLg.copyWith(
                          color: AppColors.onSurface,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md.r),
                          border: Border.all(
                            color: AppColors.outline.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 48.w,
                        height: 56.h,
                        textStyle: AppTextStyles.headlineLg.copyWith(
                          color: AppColors.onSurface,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md.r),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onCompleted: (_) => _verifyCode(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              AuthPrimaryButton(
                label: AppStrings.authVerifyCode,
                loading: _submitting,
                onTap: _verifyCode,
              ),
              gapH24,
              if (!_canResend)
                Center(
                  child: Text(
                    '${AppStrings.authResendCodePrefix}$_secondsRemaining${AppStrings.authResendCodeSuffix}',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                )
              else
                Center(
                  child: TextButton(
                    onPressed: _submitting ? null : _requestCode,
                    child: Text(
                      AppStrings.otpResend,
                      style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              gapH16,
              Center(
                child: GestureDetector(
                  onTap: () {
                    _timer?.cancel();
                    if (_submitting) return;
                    setState(() => _codeSent = false);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                    child: Text(
                      AppStrings.authModifyEmail,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.onSurfaceVariant,
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

  Future<void> _requestCode() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();

    AppHaptics.light();
    setState(() => _submitting = true);
    await handleAuthAction(
      context,
      () async {
        await ref.read(authActionsProvider).requestEmailOtp(email: email);
        if (!mounted) return;
        setState(() => _codeSent = true);
        _startTimer();
        AppSnackbar.success(context, AppStrings.authCodeSentEmail);
      },
      fallback: AppStrings.authSendCodeFailed,
      errorMapper: (error, fallback) {
        final data = error.response?.data;
        if (data is Map<String, dynamic>) {
          final code = data['code'] as String?;
          if (code == 'email_already_used') {
            return AppStrings.authEmailAlreadyUsed;
          }
          if (code == 'otp_rate_limited') {
            return AppStrings.authOtpRateLimited;
          }
        }
        return fallback;
      },
    );
    if (mounted) setState(() => _submitting = false);
  }

  Future<void> _verifyCode() async {
    final email = _emailController.text.trim();
    final code = _otpController.text.trim();

    if (code.length != 6) {
      AppSnackbar.info(context, AppStrings.authCodeMustBe6);
      return;
    }

    AppHaptics.light();
    setState(() => _submitting = true);
    await handleAuthAction(
      context,
      () async {
        await ref
            .read(authActionsProvider)
            .verifyEmailOtp(email: email, code: code);
        if (!context.mounted) return;
        // ignore: use_build_context_synchronously
        await navigateAfterAuth(context, ref);
      },
      fallback: AppStrings.authVerifyFailed,
      errorMapper: (error, fallback) {
        final data = error.response?.data;
        if (data is Map<String, dynamic>) {
          final code = data['code'] as String?;
          if (code == 'invalid_otp') {
            return AppStrings.authInvalidOtp;
          }
          if (code == 'otp_locked') {
            return AppStrings.authOtpLocked;
          }
          if (code == 'otp_expired') {
            return AppStrings.authOtpExpired;
          }
        }
        return fallback;
      },
    );
    if (mounted) setState(() => _submitting = false);
  }
}
