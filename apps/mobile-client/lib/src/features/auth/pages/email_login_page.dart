import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/auth_provider.dart';
import '../utils/auth_router_helper.dart';
import '../utils/auth_errors.dart';
import '../widgets/auth_form_widgets.dart';

final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

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
    return AuthPageScaffold(
      title: 'Connexion',
      subtitle: 'Veuillez saisir vos identifiants.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            suffixBuilder: (focused) => AppPressable(
              onTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: AppIcon(
                  _obscurePassword ? 'eye-off' : 'eye',
                  color: focused
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),
          gapH12,
          Align(
            alignment: Alignment.centerRight,
            child: AppPressable(
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
    );
  }

  Future<void> _submitLogin() async {
    if (_submitting) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.info(context, 'Email et mot de passe requis.');
      return;
    }
    if (!_emailRegex.hasMatch(email)) {
      AppSnackbar.info(context, 'Format d\'email invalide.');
      return;
    }
    AppHaptics.light();
    setState(() => _submitting = true);
    await handleAuthAction(
      context,
      () async {
        await ref
            .read(authActionsProvider)
            .loginEmail(email: email, password: password);
        if (!context.mounted) return;
        // ignore: use_build_context_synchronously
        await navigateAfterAuth(context, ref);
      },
      fallback: 'Connexion impossible.',
    );
    if (mounted) setState(() => _submitting = false);
  }
}
