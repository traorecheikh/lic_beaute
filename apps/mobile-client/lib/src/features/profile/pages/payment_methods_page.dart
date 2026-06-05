import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../models/account_models.dart';
import '../providers/payment_methods_provider.dart';
import '../../booking/providers/payment_methods_provider.dart' as booking_payment_methods;
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
  static const Map<String, String> _fallbackChannelLabels = {
    'wave_senegal': 'Wave Sénégal',
    'orange_senegal': 'Orange Money Sénégal',
    'free_senegal': 'Free Money Sénégal',
    'wizall_senegal': 'Wizall Sénégal',
    'expresso_sn': 'Expresso Sénégal',
    'djamo': 'Djamo',
    'paydunya_wallet': 'Portefeuille PayDunya',
  };

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methodsAsync = ref.watch(paymentMethodsProvider);
    final paydunyaMethodsAsync = ref.watch(booking_payment_methods.availablePaydunyaMethodsProvider);
    final availableChannels = paydunyaMethodsAsync.asData?.value
            .where((method) => method.enabled)
            .toList() ??
        const <booking_payment_methods.PaydunyaMethodRecord>[];
    final channelItems = availableChannels.isNotEmpty
        ? availableChannels
        : _fallbackChannelLabels.entries
            .map((entry) => booking_payment_methods.PaydunyaMethodRecord(
                  code: entry.key,
                  country: '',
                  label: entry.value,
                  enabled: true,
                ))
            .toList();

    if (!channelItems.any((item) => item.code == _channel) && channelItems.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _channel = channelItems.first.code);
      });
    }

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
                    items: channelItems.map((item) => item.code).toList(),
                    itemLabel: (value) =>
                        channelItems
                            .firstWhere((item) => item.code == value)
                            .label,
                    onChanged: (val) => setState(() => _channel = val),
                  ),
                  gapH16,
                  _buildPhoneField(_phoneController),
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
    final paydunyaMethods = ref
        .read(booking_payment_methods.availablePaydunyaMethodsProvider)
        .asData
        ?.value;
    final channelItems = (paydunyaMethods?.where((item) => item.enabled).toList() ??
            const <booking_payment_methods.PaydunyaMethodRecord>[])
        .isNotEmpty
        ? paydunyaMethods!.where((item) => item.enabled).toList()
        : _fallbackChannelLabels.entries
            .map((entry) => booking_payment_methods.PaydunyaMethodRecord(
                  code: entry.key,
                  country: '',
                  label: entry.value,
                  enabled: true,
                ))
            .toList();
    var selectedChannel = _resolveExistingChannel(method, channelItems);
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
                  AppDropdown<String>(
                    label: 'Opérateur',
                    value: selectedChannel,
                    items: channelItems.map((item) => item.code).toList(),
                    itemLabel: (value) => channelItems
                        .firstWhere((item) => item.code == value)
                        .label,
                    onChanged: (val) => setSheetState(() => selectedChannel = val),
                  ),
                  gapH16,
                  _buildPhoneField(phoneController),
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
                                    method: selectedChannel,
                                    country: _resolveChannelCountryForCode(
                                      selectedChannel,
                                      channelItems,
                                    ),
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
            label: _resolveChannelLabel(),
            method: _channel,
            country: _resolveChannelCountry(),
          );
      _phoneController.clear();
      if (!mounted) return;
      AppSnackbar.success(context, 'Moyen de paiement ajouté.');
      final returnTo = GoRouterState.of(context).uri.queryParameters['returnTo'];
      if (returnTo != null && returnTo.isNotEmpty) {
        context.go(Uri.decodeComponent(returnTo));
      }
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

  Widget _buildPhoneField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Numéro de téléphone',
        hintText: '778676477',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  String _resolveChannelLabel() {
    final liveMethods = ref.read(booking_payment_methods.availablePaydunyaMethodsProvider).asData?.value;
    final matched = liveMethods?.firstWhere(
      (item) => item.code == _channel,
      orElse: () => booking_payment_methods.PaydunyaMethodRecord(
        code: _channel,
        country: '',
        label: _fallbackChannelLabels[_channel] ?? _channel,
        enabled: true,
      ),
    );
    return matched?.label ?? (_fallbackChannelLabels[_channel] ?? _channel);
  }

  String? _resolveChannelCountry() {
    final liveMethods = ref.read(booking_payment_methods.availablePaydunyaMethodsProvider).asData?.value;
    final channelItems = liveMethods?.isNotEmpty == true
        ? liveMethods!
        : _fallbackChannelLabels.entries
            .map((entry) => booking_payment_methods.PaydunyaMethodRecord(
                  code: entry.key,
                  country: '',
                  label: entry.value,
                  enabled: true,
                ))
            .toList();
    return _resolveChannelCountryForCode(_channel, channelItems);
  }

  String _resolveExistingChannel(
    PaymentMethodRecord method,
    List<booking_payment_methods.PaydunyaMethodRecord> channelItems,
  ) {
    final savedMethod = method.method?.trim();
    if (savedMethod != null &&
        savedMethod.isNotEmpty &&
        channelItems.any((item) => item.code == savedMethod)) {
      return savedMethod;
    }
    final normalizedLabel = (method.label ?? '').toLowerCase();
    final matched = channelItems.where((item) {
      final label = item.label.toLowerCase();
      return label == normalizedLabel ||
          normalizedLabel.contains(label) ||
          label.contains(normalizedLabel);
    }).firstOrNull;
    return matched?.code ?? channelItems.first.code;
  }

  String? _resolveChannelCountryForCode(
    String channelCode,
    List<booking_payment_methods.PaydunyaMethodRecord> channelItems,
  ) {
    final matched = channelItems.firstWhere(
      (item) => item.code == channelCode,
      orElse: () => booking_payment_methods.PaydunyaMethodRecord(
        code: channelCode,
        country: '',
        label: _fallbackChannelLabels[channelCode] ?? channelCode,
        enabled: true,
      ),
    );
    final country = matched.country.trim().toLowerCase();
    return country.isEmpty ? null : country;
  }
}
