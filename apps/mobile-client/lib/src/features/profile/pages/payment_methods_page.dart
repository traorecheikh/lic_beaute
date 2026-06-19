import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/providers/supported_countries_provider.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../router/app_router.dart';
import '../models/account_models.dart';
import '../providers/payment_methods_provider.dart';
import '../../booking/providers/payment_methods_provider.dart'
    as booking_payment_methods;
import '../widgets/payment_tile.dart';
import '../widgets/profile_card_shell.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({
    this.requiredSetup = false,
    this.nextRoute = AppRoutes.home,
    super.key,
  });

  final bool requiredSetup;
  final String nextRoute;

  @override
  ConsumerState<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends ConsumerState<PaymentMethodsPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _channel = 'wave_senegal';
  bool _saving = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methodsAsync = ref.watch(paymentMethodsProvider);
    final paydunyaMethodsAsync = ref.watch(
      booking_payment_methods.availablePaydunyaMethodsProvider,
    );
    final channelItems = paydunyaMethodsAsync.asData?.value
            .where((method) => method.enabled)
            .toList() ??
        const <booking_payment_methods.PaydunyaMethodRecord>[];

    if (channelItems.isNotEmpty &&
        !channelItems.any((item) => item.code == _channel)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _channel = channelItems.first.code);
      });
    }

    return AppScaffold(
      appBar: AppTopBar(
        title: AppStrings.paymentMethodsTitle,
        showBackButton: !widget.requiredSetup,
      ),
      body: methodsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppEmptyState(
          icon: 'star',
          title: AppStrings.loadPaymentMethodsError,
          subtitle: error.toString(),
          action: () => ref.refresh(paymentMethodsProvider),
          actionLabel: AppStrings.retry,
        ),
        data: (methods) {
          if (widget.requiredSetup && methods.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go(widget.nextRoute);
            });
          }

          return ListView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 100.h),
            children: [
              if (widget.requiredSetup) ...[
                ProfileCardShell(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.lastStep, style: AppTextStyles.labelLg),
                      SizedBox(height: 8.h),
                      Text(
                        AppStrings.lastStepSubtitle,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
              ],
              if (methods.isEmpty)
                AppEmptyState(
                  icon: 'star',
                  title: AppStrings.noPaymentMethod,
                  subtitle: AppStrings.noPaymentMethodSubtitle,
                )
              else
                ...methods.take(2).map(
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
              if (methods.length < 2)
              Form(
                key: _addFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ProfileCardShell(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.addPhoneNumber, style: AppTextStyles.labelLg),
                      SizedBox(height: 16.h),
                      AppDropdown<String>(
                        label: AppStrings.operatorLabel,
                        value: _channel,
                        items: channelItems.map((item) => item.code).toList(),
                        itemLabel: (value) => channelItems
                            .firstWhere((item) => item.code == value)
                            .label,
                        onChanged: (val) => setState(() => _channel = val),
                      ),
                      gapH16,
                      _buildPhoneField(_phoneController, _channel),
                      SizedBox(height: 24.h),
                      AppButton.primary(
                        label: AppStrings.add,
                        onPressed: _saving ? null : _addMethod,
                        isLoading: _saving,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
    final channelItems =
        paydunyaMethods?.where((item) => item.enabled).toList() ??
            const <booking_payment_methods.PaydunyaMethodRecord>[];
    var selectedChannel = _resolveExistingChannel(method, channelItems);
    bool saving = false;

    final editFormKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
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
              child: Form(
                key: editFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.editPaymentMethod,
                      style: AppTextStyles.labelLg,
                    ),
                    SizedBox(height: 20.h),
                    AppDropdown<String>(
                      label: 'Opérateur',
                      value: selectedChannel,
                      items: channelItems.map((item) => item.code).toList(),
                      itemLabel: (value) => channelItems
                          .firstWhere((item) => item.code == value)
                          .label,
                      onChanged: (val) {
                        setSheetState(() {
                          final prevChannel = selectedChannel;
                          selectedChannel = val;

                          booking_payment_methods.PaydunyaMethodRecord? prevMethod;
                          booking_payment_methods.PaydunyaMethodRecord? newMethod;
                          for (final item in channelItems) {
                            if (item.code == prevChannel) prevMethod = item;
                            if (item.code == val) newMethod = item;
                          }

                          final currentLabel = labelController.text.trim();
                          if (prevMethod != null && newMethod != null) {
                            if (currentLabel.isEmpty || currentLabel == prevMethod.label) {
                              labelController.text = newMethod.label;
                            }
                          }
                        });
                      },
                    ),
                    gapH16,
                    _buildPhoneField(phoneController, selectedChannel),
                    gapH16,
                    TextField(
                      controller: labelController,
                      decoration: InputDecoration(
                        labelText: AppStrings.labelOptional,
                        hintText: AppStrings.labelHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md.r),
                        ),
                      ),
                      maxLength: 60,
                    ),
                    SizedBox(height: 8.h),
                    AppButton.primary(
                      label: AppStrings.save,
                      isLoading: saving,
                      onPressed: saving
                          ? null
                          : () async {
                              if (!editFormKey.currentState!.validate()) {
                                setSheetState(() => saving = false);
                                return;
                              }
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
                                    error,
                                    'Mise à jour impossible.',
                                  );
                                }
                              }
                            },
                    ),
                  ],
                ),
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
    if (!_addFormKey.currentState!.validate()) return;
    final phone = _phoneController.text.trim();

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
      if (widget.requiredSetup) {
        context.go(widget.nextRoute);
        return;
      }
      final returnTo = GoRouterState.of(
        context,
      ).uri.queryParameters['returnTo'];
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

  Widget _buildPhoneField(TextEditingController controller, String channelCode) {
    final countriesAsync = ref.watch(supportedCountriesProvider);
    final countries = countriesAsync.asData?.value ?? kPhoneCountries;

    final liveMethods = ref
        .read(booking_payment_methods.availablePaydunyaMethodsProvider)
        .asData
        ?.value;
    final channelItems = liveMethods ?? const <booking_payment_methods.PaydunyaMethodRecord>[];
    final countryStr = _resolveChannelCountryForCode(channelCode, channelItems);

    final selectedCountry = countries.firstWhere(
      (c) => countryStr?.toUpperCase() == c.code,
      orElse: () => countries[0],
    );

    return Semantics(
      label: 'Numéro de téléphone pour le moyen de paiement',
      child: AppPhoneField(
        key: ValueKey(channelCode),
        controller: controller,
        labelText: 'Numéro de téléphone',
        initialCountry: selectedCountry,
        countries: countries,
        onCountryChanged: (_) {
          // Country change handled by the channel selection
        },
      ),
    );
  }

  String _resolveChannelLabel() {
    final liveMethods = ref
        .read(booking_payment_methods.availablePaydunyaMethodsProvider)
        .asData
        ?.value;
    final matched = liveMethods?.firstWhere(
      (item) => item.code == _channel,
      orElse: () => booking_payment_methods.PaydunyaMethodRecord(
        code: _channel,
        country: '',
        label: _channel,
        enabled: true,
      ),
    );
    return matched?.label ?? _channel;
  }

  String? _resolveChannelCountry() {
    final liveMethods = ref
        .read(booking_payment_methods.availablePaydunyaMethodsProvider)
        .asData
        ?.value;
    final channelItems = liveMethods ?? const <booking_payment_methods.PaydunyaMethodRecord>[];
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
        label: channelCode,
        enabled: true,
      ),
    );
    final country = matched.country.trim().toLowerCase();
    return country.isEmpty ? null : country;
  }
}
