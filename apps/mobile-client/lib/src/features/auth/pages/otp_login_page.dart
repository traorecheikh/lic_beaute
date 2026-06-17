import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:pinput/pinput.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../providers/auth_provider.dart';
import '../utils/auth_router_helper.dart';
import '../utils/auth_errors.dart';
import '../widgets/auth_form_widgets.dart';

class OtpLoginPage extends ConsumerStatefulWidget {
  const OtpLoginPage({super.key});

  @override
  ConsumerState<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends ConsumerState<OtpLoginPage> {
  final _phoneController = PhoneController(initialValue: PhoneNumber.parse('+221'));
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
    _phoneController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneText = _phoneController.value.international;

    return AuthPageScaffold(
      title: _codeSent ? 'Vérification' : 'Inscription',
      subtitle: _codeSent
          ? 'Code envoyé au $phoneText'
          : 'Nous vous enverrons un code par SMS.',
      leading: AppBackButton(
        onPressed: () {
          if (_codeSent) {
            setState(() => _codeSent = false);
          } else {
            context.pop();
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_codeSent) ...[
            Text(
              'NUMÉRO DE TÉLÉPHONE',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 10.h),
            PhoneFormField(
              controller: _phoneController,
              isCountrySelectionEnabled: true,
              isCountryButtonPersistent: true,
              countrySelectorNavigator: const CountrySelectorNavigator.bottomSheet(
                countries: [IsoCode.SN, IsoCode.CI, IsoCode.ML, IsoCode.FR],
              ),
              countryButtonStyle: CountryButtonStyle(
                showFlag: true,
                showDialCode: true,
                showIsoCode: false,
                textStyle: AppTextStyles.bodyLg.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              validator: PhoneValidator.compose([
                PhoneValidator.required(context),
                PhoneValidator.validMobile(context),
              ]),
              style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurface),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
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
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 48.h),
            AuthPrimaryButton(
              label: 'RECEVOIR LE CODE',
              loading: _submitting,
              onTap: _requestCode,
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
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
            SizedBox(height: 48.h),
            AuthPrimaryButton(
              label: 'VÉRIFIER LE CODE',
              loading: _submitting,
              onTap: _verifyCode,
            ),
            gapH24,
            if (!_canResend)
              Center(
                child: Text(
                  'Renvoyer le code dans ${_secondsRemaining}s',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _submitting ? null : _requestCode,
                    child: Text(
                      'Renvoyer le code',
                      style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _timer?.cancel();
                      context.push(AppRoutes.emailLogin);
                    },
                    child: Text(
                      "Recourir à l'email",
                      style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            gapH16,
            Center(
              child: GestureDetector(
                onTap: () {
                  _timer?.cancel();
                  setState(() => _codeSent = false);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                  child: Text(
                    'Modifier le numéro',
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
    );
  }

  Future<void> _requestCode() async {
    final phone = _phoneController.value.international;
    if (!_phoneController.value.isValid()) {
      AppSnackbar.info(
        context,
        'Numéro invalide. Veuillez vérifier votre saisie.',
      );
      return;
    }
    AppHaptics.light();
    setState(() => _submitting = true);
    await handleAuthAction(
      context,
      () async {
        await ref.read(authActionsProvider).requestOtp(phone: phone);
        if (!mounted) return;
        setState(() => _codeSent = true);
        _startTimer();
        AppSnackbar.success(context, 'Code OTP envoyé.');
      },
      fallback: 'Envoi OTP impossible.',
      errorMapper: parseOtpError,
    );
    if (mounted) setState(() => _submitting = false);
  }

  Future<void> _verifyCode() async {
    final phone = _phoneController.value.international;
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
            .verifyOtp(phone: phone, code: code);
        if (!context.mounted) return;
        // ignore: use_build_context_synchronously
        await navigateAfterAuth(context, ref);
      },
      fallback: 'Vérification OTP impossible.',
      errorMapper: parseOtpError,
    );
    if (mounted) setState(() => _submitting = false);
  }
}

