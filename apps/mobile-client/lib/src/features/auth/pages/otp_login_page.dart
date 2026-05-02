import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../providers/auth_provider.dart';
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
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20.w,
            color: AppColors.onSurface,
          ),
          onPressed: () {
            if (_codeSent) {
              setState(() => _codeSent = false);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              _codeSent ? 'Vérification' : 'Inscription',
              style: AppTextStyles.displayMd,
            ),
            SizedBox(height: 8.h),
            Text(
              _codeSent
                  ? 'Code envoyé au +221 ${_phoneController.text}'
                  : 'Nous vous enverrons un code par SMS.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 48.h),
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
              SizedBox(height: 24.h),
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
    try {
      await ref.read(authActionsProvider).requestOtp(phone: phone);
      if (!mounted) return;
      setState(() => _codeSent = true);
      AppSnackbar.success(context, 'Code OTP envoyé.');
    } on DioException catch (error) {
      if (!mounted) return;
      final message = (error.response?.data is Map<String, dynamic>)
          ? ((error.response!.data as Map<String, dynamic>)['message']
                    as String? ??
                'Envoi OTP impossible.')
          : 'Envoi OTP impossible.';
      AppSnackbar.error(context, message);
    } on ClientOnlyAuthException catch (error) {
      if (!mounted) return;
      AppSnackbar.error(context, error.message);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Envoi OTP impossible.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
    try {
      await ref.read(authActionsProvider).verifyOtp(phone: phone, code: code);
      final user = await ref.read(currentUserProvider.future);
      if (!mounted) return;
      final needsBootstrap = (user?.fullName ?? '').trim().isEmpty;
      context.go(needsBootstrap ? AppRoutes.profileBootstrap : AppRoutes.home);
    } on DioException catch (error) {
      if (!mounted) return;
      final message = (error.response?.data is Map<String, dynamic>)
          ? ((error.response!.data as Map<String, dynamic>)['message']
                    as String? ??
                'Vérification OTP impossible.')
          : 'Vérification OTP impossible.';
      AppSnackbar.error(context, message);
    } on ClientOnlyAuthException catch (error) {
      if (!mounted) return;
      AppSnackbar.error(context, error.message);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Vérification OTP impossible.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _normalizeSenegalPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('221') && digits.length == 12) return '+$digits';
    if (digits.length == 9) return '+221$digits';
    return null;
  }
}
