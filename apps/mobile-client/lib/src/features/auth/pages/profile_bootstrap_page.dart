import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_resource_view.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../router/app_router.dart';
import '../../profile/providers/profile_provider.dart';

class ProfileBootstrapPage extends ConsumerStatefulWidget {
  const ProfileBootstrapPage({
    this.requiredSetup = false,
    this.nextRoute = AppRoutes.home,
    super.key,
  });

  final bool requiredSetup;
  final String nextRoute;

  @override
  ConsumerState<ProfileBootstrapPage> createState() => _ProfileBootstrapPageState();
}

class _ProfileBootstrapPageState extends ConsumerState<ProfileBootstrapPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  String? _selectedCity;
  bool _saving = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final optionsAsync = ref.watch(profileOptionsProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppTopBar(
        title: 'Mon profil',
        showBackButton: !widget.requiredSetup,
      ),
      body: SafeArea(
        top: false,
        child: AppResourceView(
          value: optionsAsync,
          onRetry: () => ref.refresh(profileOptionsProvider.future),
          errorTitle: 'Impossible de charger le formulaire',
          builder: (options) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 40.h),
                      child: Image.asset(
                        'assets/logo.png',
                        height: 120.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Text(
                    'Complétez votre profil',
                    style: AppTextStyles.displayMd,
                  ),
                  gapH12,
                  Text(
                    'Votre ville et votre nom serviront à personnaliser vos réservations.',
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom complet',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return 'Nom complet requis (2 caractères minimum)';
                      }
                      return null;
                    },
                  ),
                  gapH16,
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    decoration: const InputDecoration(
                      labelText: 'Ville',
                    ),
                    items: options.cities
                        .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                        .toList(growable: false),
                    onChanged: (value) => setState(() => _selectedCity = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez choisir votre ville';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 48.h),
                  AppButton.primary(
                    onPressed: _saving ? null : _submit,
                    label: "Commencer l'aventure",
                    isLoading: _saving,
                  ),
                  if (!widget.requiredSetup) ...[
                    gapH16,
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.home),
                        child: Text(
                          "Passer pour l'instant",
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPaymentNudge() async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon('star', size: 26, color: AppColors.primary),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Réservez en un tap',
              style: AppTextStyles.headlineMd,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Ajoutez un moyen de paiement maintenant pour réserver sans friction.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28.h),
            AppButton.primary(
              label: 'Ajouter un moyen de paiement',
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go(
                  AppRoutes.profilePaymentsSetup(next: widget.nextRoute),
                );
              },
            ),
            SizedBox(height: 12.h),
            AppButton.text(
              label: 'Plus tard',
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    AppHaptics.medium();
    setState(() => _saving = true);

    try {
      await ref.read(profileProvider.notifier).updateProfile(
            fullName: _fullNameController.text.trim(),
            city: _selectedCity,
          );
      if (!mounted) return;
      if (widget.requiredSetup) {
        context.go(AppRoutes.profilePaymentsSetup(next: widget.nextRoute));
        return;
      }
      await _showPaymentNudge();
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Mise à jour impossible.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
