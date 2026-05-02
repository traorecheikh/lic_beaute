import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_form_widgets.dart';
import '../../../router/app_router.dart';

class EmailLoginPage extends ConsumerStatefulWidget {
  const EmailLoginPage({super.key});

  @override
  ConsumerState<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends ConsumerState<EmailLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text('Connexion', style: AppTextStyles.displayMd),
            SizedBox(height: 8.h),
            Text(
              'Veuillez saisir vos identifiants.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 48.h),
            EditorialField(
              label: 'EMAIL',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 28.h),
            EditorialField(
              label: 'MOT DE PASSE',
              controller: _passwordController,
              obscureText: _obscurePassword,
              suffixBuilder: (focused) => GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: focused
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    size: 20.r,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  AppHaptics.light();
                  AppSnackbar.info(
                    context,
                    'Réinitialisation par email bientôt disponible.',
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(
                    'Mot de passe oublié ?',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 48.h),
            AuthPrimaryButton(
              label: 'SE CONNECTER',
              loading: _submitting,
              onTap: _submitLogin,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.info(context, 'Email et mot de passe requis.');
      return;
    }
    AppHaptics.light();
    setState(() => _submitting = true);
    try {
      await ref
          .read(authActionsProvider)
          .loginEmail(email: email, password: password);
      final user = await ref.read(currentUserProvider.future);
      if (!mounted) return;
      final needsBootstrap = (user?.fullName ?? '').trim().isEmpty;
      context.go(needsBootstrap ? AppRoutes.profileBootstrap : AppRoutes.home);
    } on DioException catch (error) {
      if (!mounted) return;
      final message = (error.response?.data is Map<String, dynamic>)
          ? ((error.response!.data as Map<String, dynamic>)['message']
                    as String? ??
                'Connexion impossible.')
          : 'Connexion impossible.';
      AppSnackbar.error(context, message);
    } on ClientOnlyAuthException catch (error) {
      if (!mounted) return;
      AppSnackbar.error(context, error.message);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Connexion impossible.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
