import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_snackbar.dart';
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
  String _channel = 'wave';
  bool _saving = false;
  static const Map<String, String> _channelLabels = {
    'wave': 'Wave',
    'orange_money': 'Orange Money',
    'free_money': 'Free Money',
  };

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methodsAsync = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Moyens de paiement', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
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
                    'Enregistrez un numéro Wave, Orange Money ou Free Money pour simplifier vos réservations.',
              )
            else
              ...methods.map(
                (method) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: PaymentTile(
                    method: method,
                    onTap: () {},
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
                    items: const ['wave', 'orange_money', 'free_money'],
                    itemLabel: (v) => _channelLabels[v] ?? v,
                    onChanged: (val) => setState(() => _channel = val),
                  ),
                  gapH16,
                  AppPhoneField(
                    controller: _phoneController,
                    labelText: 'Numéro de téléphone',
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _addMethod,
                      child: _saving
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Ajouter'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            provider: 'intech',
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
