import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../router/app_router.dart';

class OtpLoginPage extends ConsumerStatefulWidget {
  const OtpLoginPage({super.key});

  @override
  ConsumerState<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends ConsumerState<OtpLoginPage> {
  final _phoneController = TextEditingController(text: '77 123 45 67');
  final _otpController = TextEditingController(text: '123456');
  bool _codeSent = false;

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
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Text(
              _codeSent ? 'Vérification' : 'Inscription',
              style: AppTextStyles.displayMd.copyWith(
                color: AppColors.onSurface,
              ),
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
              _buildEditorialTextField(
                label: 'NUMÉRO DE TÉLÉPHONE',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixText: '+221 ',
              ),
              SizedBox(height: 48.h),
              GestureDetector(
                onTap: () => setState(() => _codeSent = true),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Center(
                    child: Text(
                      'RECEVOIR LE CODE',
                      style: AppTextStyles.labelLg.copyWith(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              _buildEditorialTextField(
                label: 'CODE À 6 CHIFFRES',
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineLg.copyWith(
                  letterSpacing: 16.w,
                  color: AppColors.onSurface,
                ),
              ),
              SizedBox(height: 48.h),
              GestureDetector(
                onTap: () async {
                  await ref
                      .read(sessionProvider.notifier)
                      .login(
                        accessToken: 'mock_access_token',
                        refreshToken: 'mock_refresh_token',
                        userId: 'mock_user_1',
                        role: 'client',
                      );
                  if (!mounted) return;
                  context.go(AppRoutes.profileBootstrap);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Center(
                    child: Text(
                      'VÉRIFIER LE CODE',
                      style: AppTextStyles.labelLg.copyWith(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _codeSent = false),
                  child: Text(
                    'Modifier le numéro',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      decoration: TextDecoration.underline,
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

  Widget _buildEditorialTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? prefixText,
    TextAlign textAlign = TextAlign.start,
    TextStyle? style,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: textAlign,
          style:
              style ??
              AppTextStyles.bodyLg.copyWith(color: AppColors.onSurface),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16.h),
            prefixText: prefixText,
            prefixStyle: AppTextStyles.bodyLg.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
