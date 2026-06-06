import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      title: _codeSent ? 'Vérification' : 'Créer un compte',
      subtitle: _codeSent
          ? 'Un code à 6 chiffres vous a été envoyé par email.'
          : 'Saisissez votre email pour recevoir un code de vérification.',
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
                  labelText: 'EMAIL',
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: AppColors.error, width: 1.2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: AppColors.error, width: 1.8),
                  ),
                  hintStyle: AppTextStyles.bodyLg.copyWith(color: AppColors.outline),
                ),
                style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurface),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email requis';
                  }
                  if (!_emailRegex.hasMatch(value.trim())) {
                    return "Format d'email invalide";
                  }
                  return null;
                },
              ),
              SizedBox(height: 48.h),
              AuthPrimaryButton(
                label: 'RECEVOIR LE CODE',
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
                      'Déjà un compte ? Connectez-vous',
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
                        labelText: 'EMAIL',
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
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
                      'CODE À 6 CHIFFRES',
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
                          borderRadius: BorderRadius.circular(12.r),
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
                          borderRadius: BorderRadius.circular(12.r),
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
                label: 'VÉRIFIER LE CODE',
                loading: _submitting,
                onTap: _verifyCode,
              ),
              gapH16,
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_submitting) return;
                    setState(() => _codeSent = false);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      "Modifier l'email",
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
        AppSnackbar.success(context, 'Code de vérification envoyé par email.');
      },
      fallback: 'Envoi du code impossible.',
      errorMapper: (error, fallback) {
        final data = error.response?.data;
        if (data is Map<String, dynamic>) {
          final code = data['code'] as String?;
          if (code == 'email_already_used') {
            return 'Cet email est déjà utilisé. Connectez-vous avec votre mot de passe.';
          }
          if (code == 'otp_rate_limited') {
            return 'Trop de tentatives. Réessayez dans quelques minutes.';
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
      AppSnackbar.info(context, 'Le code doit contenir 6 chiffres.');
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
      fallback: 'Vérification impossible.',
      errorMapper: (error, fallback) {
        final data = error.response?.data;
        if (data is Map<String, dynamic>) {
          final code = data['code'] as String?;
          if (code == 'invalid_otp') {
            return 'Code incorrect. Vérifiez et réessayez.';
          }
          if (code == 'otp_locked') {
            return 'Trop de tentatives. Veuillez redemander un code.';
          }
          if (code == 'otp_expired') {
            return 'Code expiré. Demandez un nouveau code.';
          }
        }
        return fallback;
      },
    );
    if (mounted) setState(() => _submitting = false);
  }
}
