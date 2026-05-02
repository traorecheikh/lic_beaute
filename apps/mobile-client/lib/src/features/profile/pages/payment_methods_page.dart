import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../models/account_models.dart';
import '../providers/payment_methods_provider.dart';
import '../providers/profile_provider.dart';

const _labelOptions = ['Personnel', 'Professionnel', 'Famille', 'Secondaire', 'Autre'];
const _noLabel = 'Aucun libellé';

class PaymentMethodsPage extends ConsumerWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methodsAsync = ref.watch(paymentMethodsProvider);
    final optionsAsync = ref.watch(profileOptionsProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Moyens de paiement', style: AppTextStyles.headlineSm),
        centerTitle: true,
        elevation: 0,
      ),
      body: optionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          title: 'Impossible de charger les options',
          message: error.toString(),
          onRetry: () => ref.refresh(profileOptionsProvider.future),
        ),
        data: (options) => methodsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => AppErrorState(
            title: 'Impossible de charger les numéros',
            message: error.toString(),
            onRetry: () => ref.refresh(paymentMethodsProvider.future),
          ),
          data: (methods) => ListView(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Vos numéros enregistrés sont utilisés pour préremplir le paiement d'acompte lors de la réservation.",
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              if (methods.isEmpty)
                AppEmptyState(
                  icon: Icons.phone_android_outlined,
                  title: 'Aucun numéro enregistré',
                  subtitle:
                      "Ajoutez un numéro Wave ou Orange Money pour accélérer le paiement d'acompte.",
                  compact: true,
                )
              else
                ...methods.map(
                  (method) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _PaymentTile(
                      method: method,
                      onTap: () =>
                          _showEditor(context, ref, options, existing: method),
                      onDefault: method.isDefault
                          ? null
                          : () => ref
                                .read(paymentMethodsProvider.notifier)
                                .setDefault(method.id),
                      onDelete: method.id.startsWith('pending-')
                          ? null
                          : () => ref
                                .read(paymentMethodsProvider.notifier)
                                .remove(method.id),
                    ),
                  ),
                ),
              SizedBox(height: 28.h),
              OutlinedButton.icon(
                onPressed: () => _showEditor(context, ref, options),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Ajouter un numéro'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditor(
    BuildContext context,
    WidgetRef ref,
    ProfileOptions options, {
    PaymentMethodRecord? existing,
  }) async {
    final formKey = GlobalKey<FormState>();
    final phoneController = TextEditingController(
      text: _localDigits(existing?.phoneNumber),
    );
    var provider = existing?.provider ?? options.paymentProviders.first;
    var selectedLabel =
        (existing?.label != null && _labelOptions.contains(existing!.label))
            ? existing.label!
            : _noLabel;
    PhoneCountry selectedCountry = _countryFromNumber(existing?.phoneNumber);

    final providerLabels = {'wave': 'Wave', 'orange_money': 'Orange Money'};

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20.w,
                20.h,
                20.w,
                MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      existing == null ? 'Ajouter un numéro' : 'Modifier le numéro',
                      style: AppTextStyles.headlineSm,
                    ),
                    SizedBox(height: 20.h),
                    AppDropdown<String>(
                      label: 'Opérateur',
                      items: options.paymentProviders,
                      value: provider,
                      itemLabel: (p) => providerLabels[p] ?? p,
                      onChanged: (p) => setModalState(() => provider = p),
                    ),
                    SizedBox(height: 14.h),
                    AppPhoneField(
                      controller: phoneController,
                      initialCountry: selectedCountry,
                      onCountryChanged: (c) =>
                          setModalState(() => selectedCountry = c),
                    ),
                    SizedBox(height: 14.h),
                    AppDropdown<String>(
                      label: 'Libellé',
                      items: [_noLabel, ..._labelOptions],
                      value: selectedLabel,
                      itemLabel: (l) => l,
                      onChanged: (l) => setModalState(() => selectedLabel = l),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        child: Text(
                          existing == null ? 'Enregistrer' : 'Mettre à jour',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    if (saved != true || !context.mounted) return;
    final fullNumber =
        '${selectedCountry.dialCode}${phoneController.text.trim()}';
    final label = selectedLabel == _noLabel ? null : selectedLabel;
    try {
      if (existing == null) {
        await ref.read(paymentMethodsProvider.notifier).add(
              provider: provider,
              phoneNumber: fullNumber,
              label: label,
            );
      } else {
        await ref.read(paymentMethodsProvider.notifier).updateMethod(
              existing.id,
              phoneNumber: fullNumber,
              label: label,
            );
      }
      if (!context.mounted) return;
      AppSnackbar.success(context, 'Numéro enregistré.');
    } on DioException catch (error) {
      if (!context.mounted) return;
      final data = error.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message'] as String? ?? 'Enregistrement impossible.'
          : 'Enregistrement impossible.';
      AppSnackbar.error(context, message);
    }
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────

PhoneCountry _countryFromNumber(String? number) {
  if (number == null) return kPhoneCountries[0];
  for (final c in kPhoneCountries) {
    if (number.startsWith(c.dialCode)) return c;
  }
  return kPhoneCountries[0];
}

String _localDigits(String? number) {
  if (number == null) return '';
  for (final c in kPhoneCountries) {
    if (number.startsWith(c.dialCode)) {
      return number.substring(c.dialCode.length);
    }
  }
  return number;
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.method,
    required this.onTap,
    required this.onDefault,
    required this.onDelete,
  });

  final PaymentMethodRecord method;
  final VoidCallback onTap;
  final VoidCallback? onDefault;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final title = method.provider == 'wave' ? 'Wave' : 'Orange Money';
    final logoAsset = method.provider == 'wave'
        ? 'assets/wave.png'
        : 'assets/om.png';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppShadows.card,
        border: method.isDefault
            ? Border.all(color: AppColors.primary, width: 1.5)
            : Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                padding: EdgeInsets.all(8.r),
                child: Image.asset(logoAsset, fit: BoxFit.contain),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: AppTextStyles.labelLg),
                        if (method.isDefault) ...[
                          SizedBox(width: 8.w),
                          _Badge(label: 'Par défaut', color: AppColors.primary),
                        ],
                        if (method.pendingSync) ...[
                          SizedBox(width: 8.w),
                          const _Badge(
                            label: 'En attente',
                            color: Color(0xFF8C6A1C),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      method.phoneNumber,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (method.label != null && method.label!.isNotEmpty)
                      Text(
                        method.label!,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              TextButton(
                onPressed: onDefault == null
                    ? null
                    : () {
                        AppHaptics.light();
                        onDefault!();
                      },
                child: const Text('Définir par défaut'),
              ),
              const Spacer(),
              TextButton(
                onPressed: onDelete == null
                    ? null
                    : () {
                        AppHaptics.light();
                        onDelete!();
                      },
                child: const Text('Supprimer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(color: color, fontSize: 10.sp),
      ),
    );
  }
}
