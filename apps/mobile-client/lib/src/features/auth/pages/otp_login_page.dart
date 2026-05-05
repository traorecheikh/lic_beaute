import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
  final _phoneController = TextEditingController(text: '77 000 00 00');
  final _otpController = TextEditingController(text: '123456');
  bool _codeSent = false;
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      title: _codeSent ? 'Vérification' : 'Inscription',
      subtitle: _codeSent
          ? 'Code envoyé au +221 ${_phoneController.text}'
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
            EditorialField(
              label: 'NUMÉRO DE TÉLÉPHONE',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefixText: '+221 ',
            ),
            SizedBox(height: 48.h),
            AuthPrimaryButton(
              label: 'RECEVOIR LE CODE',
              loading: _submitting,
              onTap: _requestCode,
            ),
          ] else ...[
            EditorialField(
              label: 'CODE À 6 CHIFFRES',
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineLg.copyWith(
                letterSpacing: 12.w,
                color: AppColors.onSurface,
              ),
            ),
            SizedBox(height: 48.h),
            AuthPrimaryButton(
              label: 'VÉRIFIER LE CODE',
              loading: _submitting,
              onTap: _verifyCode,
            ),
            gapH24,
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _codeSent = false),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
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
    final phone = _normalizeSenegalPhone(_phoneController.text);
    if (phone == null) {
      AppSnackbar.info(
        context,
        'Numéro invalide. Entrez un numéro Sénégal (+221 XX XXX XX XX).',
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
        AppSnackbar.success(context, 'Code OTP envoyé.');
      },
      fallback: 'Envoi OTP impossible.',
    );
    if (mounted) setState(() => _submitting = false);
  }

  Future<void> _verifyCode() async {
    final phone = _normalizeSenegalPhone(_phoneController.text);
    final code = _otpController.text.trim();
    if (phone == null) {
      AppSnackbar.info(context, 'Numéro Sénégal invalide.');
      return;
    }
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
        await navigateAfterAuth(context, ref);
        },

      fallback: 'Vérification OTP impossible.',
    );
    if (mounted) setState(() => _submitting = false);
  }

  String? _normalizeSenegalPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('221') && digits.length == 12) return '+$digits';
    if (digits.length == 9) return '+221$digits';
    return null;
  }
}
