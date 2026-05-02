import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileBootstrapPage extends ConsumerStatefulWidget {
  const ProfileBootstrapPage({super.key});

  @override
  ConsumerState<ProfileBootstrapPage> createState() =>
      _ProfileBootstrapPageState();
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: optionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => AppErrorState(
            title: 'Impossible de charger le formulaire',
            message: error.toString(),
            onRetry: () => ref.refresh(profileOptionsProvider.future),
          ),
          data: (options) => SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'Complétez votre profil',
                  style: AppTextStyles.displayMd.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Votre ville et votre nom serviront à personnaliser vos réservations.',
                  style: AppTextStyles.bodyLg.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 40.h),
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Nom complet'),
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCity,
                  decoration: const InputDecoration(labelText: 'Ville'),
                  items: options.cities
                      .map(
                        (city) =>
                            DropdownMenuItem(value: city, child: Text(city)),
                      )
                      .toList(growable: false),
                  onChanged: (value) => setState(() => _selectedCity = value),
                ),
                SizedBox(height: 48.h),
                ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Commencer l\'aventure'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final fullName = _fullNameController.text.trim();
    if (fullName.length < 2) {
      AppSnackbar.info(context, 'Nom complet requis.');
      return;
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(fullName: fullName, city: _selectedCity);
      if (!mounted) return;
      context.go(AppRoutes.home);
    } on DioException catch (error) {
      if (!mounted) return;
      final data = error.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message'] as String? ?? 'Mise à jour du profil impossible.'
          : 'Mise à jour du profil impossible.';
      AppSnackbar.error(context, message);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Mise à jour du profil impossible.');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
