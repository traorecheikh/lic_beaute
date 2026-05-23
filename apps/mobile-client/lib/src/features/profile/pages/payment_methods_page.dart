import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../models/account_models.dart';
import '../providers/payment_methods_provider.dart';
import '../widgets/payment_tile.dart';
import '../widgets/profile_card_shell.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  ConsumerState<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends ConsumerState<PaymentMethodsPage> {
  final _phoneController = TextEditingController();
  String _channel = 'wave_senegal';
  bool _saving = false;
  static const Map<String, String> _channelLabels = {
    'wave_senegal': 'Wave Sénégal',
    'orange_senegal': 'Orange Money Sénégal',
    'free_senegal': 'Free Money Sénégal',
    'wizall_senegal': 'Wizall Sénégal',
  };

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methodsAsync = ref.watch(paymentMethodsProvider);

    return AppScaffold(
      appBar: const AppTopBar(title: 'Moyens de paiement', showBackButton: true),
      body: methodsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppEmptyState(
          icon: 'star',
          title: 'Impossible de charger vos moyens de paiement',
          subtitle: error.toString(),
          action: () => ref.refresh(paymentMethodsProvider),
          actionLabel: 'Réessayer',
        ),
        data: (methods) => ListView(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 100.h),
          children: [
            if (methods.isEmpty)
              const AppEmptyState(
                icon: 'star',
                title: 'Aucun moyen de paiement',
                subtitle:
                    'Enregistrez un compte mobile money pour simplifier vos réservations.',
              )
            else
              ...methods.map(
                (method) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: PaymentTile(
                    method: method,
                    onTap: () => _showEditSheet(context, method),
                    onDelete: () => _deleteMethod(method.id),
                    onDefault: method.isDefault
                        ? null
                        : () => _setDefault(method.id),
                  ),
                ),
              ),
            SizedBox(height: 12.h),
            ProfileCardShell(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ajouter un numéro', style: AppTextStyles.labelLg),
                  SizedBox(height: 16.h),
                  AppDropdown<String>(
                    label: 'Opérateur',
                    value: _channel,
                    items: _channelLabels.keys.toList(),
                    itemLabel: (v) => _channelLabels[v] ?? v,
                    onChanged: (val) => setState(() => _channel = val),
                  ),
                  gapH16,
                  AppPhoneField(
                    controller: _phoneController,
                    labelText: 'Numéro de téléphone',
                  ),
                  SizedBox(height: 24.h),
                  AppButton.primary(
                    label: 'Ajouter',
                    onPressed: _saving ? null : _addMethod,
                    isLoading: _saving,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, PaymentMethodRecord method) {
    final phoneController = TextEditingController(text: method.phoneNumber);
    final labelController = TextEditingController(text: method.label ?? '');
    bool saving = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20.w,
                24.h,
                20.w,
                MediaQuery.viewInsetsOf(ctx).bottom + 32.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modifier le moyen de paiement',
                      style: AppTextStyles.labelLg),
                  SizedBox(height: 20.h),
                  AppPhoneField(
                    controller: phoneController,
                    labelText: 'Numéro de téléphone',
                  ),
                  gapH16,
                  TextField(
                    controller: labelController,
                    decoration: InputDecoration(
                      labelText: 'Libellé (optionnel)',
                      hintText: 'ex : Mon Wave principal',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    maxLength: 60,
                  ),
                  SizedBox(height: 8.h),
                  AppButton.primary(
                    label: 'Enregistrer',
                    isLoading: saving,
                    onPressed: saving
                        ? null
                        : () async {
                            setSheetState(() => saving = true);
                            try {
                              await ref
                                  .read(paymentMethodsProvider.notifier)
                                  .updateMethod(
                                    method.id,
                                    phoneNumber: phoneController.text.trim(),
                                    label: labelController.text.trim().isEmpty
                                        ? null
                                        : labelController.text.trim(),
                                  );
                              if (context.mounted) {
                                Navigator.of(sheetContext).pop();
                                AppSnackbar.success(
                                  context,
                                  'Moyen de paiement mis à jour.',
                                );
                              }
                            } catch (error) {
                              setSheetState(() => saving = false);
                              if (context.mounted) {
                                await context.handleHttpError(
                                    error, 'Mise à jour impossible.');
                              }
                            }
                          },
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      phoneController.dispose();
      labelController.dispose();
    });
  }

  Future<void> _addMethod() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 9) {
      AppSnackbar.error(context, 'Numéro de téléphone invalide.');
      return;
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(paymentMethodsProvider.notifier)
          .add(
            provider: 'paydunya',
            phoneNumber: phone,
            label: _channelLabels[_channel],
          );
      _phoneController.clear();
      if (!mounted) return;
      AppSnackbar.success(context, 'Moyen de paiement ajouté.');
    } catch (error) {
      await context.handleHttpError(error, 'Ajout impossible.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteMethod(String id) async {
    try {
      await ref.read(paymentMethodsProvider.notifier).remove(id);
      if (!mounted) return;
      AppSnackbar.success(context, 'Moyen de paiement supprimé.');
    } catch (error) {
      await context.handleHttpError(error, 'Suppression impossible.');
    }
  }

  Future<void> _setDefault(String id) async {
    try {
      await ref.read(paymentMethodsProvider.notifier).setDefault(id);
      if (!mounted) return;
      AppSnackbar.success(context, 'Moyen de paiement par défaut mis à jour.');
    } catch (error) {
      await context.handleHttpError(error, 'Mise à jour impossible.');
    }
  }
}
