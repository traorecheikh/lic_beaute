import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_city_dropdown.dart';
import '../../../core/widgets/app_resource_view.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../router/app_router.dart';
import '../../profile/providers/profile_provider.dart';

class ProfileBootstrapPage extends ConsumerStatefulWidget {
  const ProfileBootstrapPage({super.key});

  @override
  ConsumerState<ProfileBootstrapPage> createState() => _ProfileBootstrapPageState();
}

class _ProfileBootstrapPageState extends ConsumerState<ProfileBootstrapPage> {
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
      body: SafeArea(
        child: AppResourceView(
          value: optionsAsync,
          onRetry: () => ref.refresh(profileOptionsProvider.future),
          errorTitle: 'Impossible de charger le formulaire',
          builder: (options) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
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
                AppTextField(
                  controller: _fullNameController,
                  labelText: 'Nom complet',
                ),
                gapH16,
                AppCityDropdown(
                  value: _selectedCity,
                  cities: options.cities,
                  onChanged: (value) => setState(() => _selectedCity = value),
                ),
                SizedBox(height: 48.h),
                AppButton.primary(
                  onPressed: _saving ? null : _submit,
                  label: "Commencer l’aventure",
                  isLoading: _saving,
                ),
                gapH16,
                Center(
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: Text(
                      "Passer pour l’instant",
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final name = _fullNameController.text.trim();
    if (name.length < 2) {
      AppSnackbar.error(context, 'Veuillez entrer votre nom.');
      return;
    }
    if (_selectedCity == null) {
      AppSnackbar.error(context, 'Veuillez choisir votre ville.');
      return;
    }

    AppHaptics.medium();
    setState(() => _saving = true);

    try {
      await ref.read(profileProvider.notifier).updateProfile(
            fullName: name,
            city: _selectedCity,
          );
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Mise à jour impossible.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
