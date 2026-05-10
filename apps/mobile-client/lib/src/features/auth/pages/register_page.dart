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

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      title: 'Créer un compte',
      subtitle: 'Rejoignez Beauté Avenue pour une expérience personnalisée.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditorialField(
            label: 'NOM COMPLET',
            controller: _fullNameController,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 24.h),
          EditorialField(
            label: 'EMAIL',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 24.h),
          EditorialField(
            label: 'MOT DE PASSE',
            controller: _passwordController,
            obscureText: _obscurePassword,
            suffixBuilder: (focused) => AppPressable(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: AppIcon(
                  _obscurePassword ? 'eye-off' : 'eye',
                  color: focused ? AppColors.primary : AppColors.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: 48.h),
          AuthPrimaryButton(
            label: 'S\'INSCRIRE',
            loading: _submitting,
            onTap: _submitRegister,
          ),
        ],
      ),
    );
  }

  Future<void> _submitRegister() async {
    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      AppSnackbar.info(context, 'Tous les champs sont requis.');
      return;
    }
    if (password.length < 8) {
      AppSnackbar.info(context, 'Le mot de passe doit contenir au moins 8 caractères.');
      return;
    }

    AppHaptics.light();
    setState(() => _submitting = true);
    await handleAuthAction(
      context,
      () async {
        await ref.read(authActionsProvider).registerEmail(
              fullName: name,
              email: email,
              password: password,
            );
        if (!context.mounted) return;
        // ignore: use_build_context_synchronously
        await navigateAfterAuth(context, ref);
      },
      fallback: 'Inscription impossible.',
    );
    if (mounted) setState(() => _submitting = false);
  }
}
