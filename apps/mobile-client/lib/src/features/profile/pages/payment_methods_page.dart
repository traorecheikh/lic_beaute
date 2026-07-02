import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../router/app_router.dart';
import '../models/account_models.dart';
import '../providers/payment_methods_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/phone_utils.dart';
import '../../booking/providers/payment_methods_provider.dart'
    as booking_payment_methods;
import '../widgets/payment_method_sheet.dart';
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
  final _phoneController = TextEditingController();
  String _channel = 'wave_senegal';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _seedPhoneFromProfile();
    });
  }

  void _seedPhoneFromProfile() {
    if (!mounted) return;
    final profile = ref.read(profileProvider).asData?.value;
    if (profile?.phone == null) return;
    final result = seedPhone(profile!.phone);
    if (result != null) {
      _phoneController.text = result.nationalDigits;
    }
  }

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
    final channelItems =
        paydunyaMethodsAsync.asData?.value
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
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
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
              ProfileCardShell(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Moyens de paiement', style: AppTextStyles.labelLg),
                    SizedBox(height: 6.h),
                    Text(
                      '${methods.length.clamp(0, 2)}/2 enregistrés',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (methods.length < 2) ...[
                      SizedBox(height: 16.h),
                      AppButton.outline(
                        label: AppStrings.addPhoneNumber,
                        isFullWidth: true,
                        onPressed: channelItems.isEmpty
                            ? null
                            : () => _showAddSheet(context, channelItems),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              if (methods.isEmpty)
                AppEmptyState(
                  icon: 'star',
                  title: AppStrings.noPaymentMethod,
                  subtitle: AppStrings.noPaymentMethodSubtitle,
                )
              else
                ...methods
                    .take(2)
                    .map(
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
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddSheet(
    BuildContext context,
    List<booking_payment_methods.PaydunyaMethodRecord> channelItems,
  ) async {
    final result = await showPaymentMethodSheet(
      context: context,
      ref: ref,
      isEdit: false,
      channelItems: channelItems,
      initialChannel: _channel,
      initialPhone: _phoneController.text,
    );

    if (result != null && mounted) {
      setState(() {
        _channel = result.channelCode;
        if (result.phoneCleared) _phoneController.clear();
      });

      ref.invalidate(paymentMethodsProvider);

      if (widget.requiredSetup) {
        context.go(widget.nextRoute);
        return;
      }
      final returnTo = GoRouterState.of(context).uri.queryParameters['returnTo'];
      if (returnTo != null && returnTo.isNotEmpty) {
        context.go(Uri.decodeComponent(returnTo));
      }
    }
  }

  Future<void> _showEditSheet(
    BuildContext context,
    PaymentMethodRecord method,
  ) async {
    final paydunyaMethods = ref
        .read(booking_payment_methods.availablePaydunyaMethodsProvider)
        .asData
        ?.value;
    final channelItems =
        paydunyaMethods?.where((item) => item.enabled).toList() ??
        const <booking_payment_methods.PaydunyaMethodRecord>[];

    await showPaymentMethodSheet(
      context: context,
      ref: ref,
      isEdit: true,
      channelItems: channelItems,
      initialChannel: method.method?.trim() ?? '',
      initialPhone: method.phoneNumber,
      initialLabel: method.label ?? '',
      existingMethod: method,
    );

    if (mounted) {
      ref.invalidate(paymentMethodsProvider);
    }
  }

  Future<void> _deleteMethod(String id) async {
    try {
      await ref.read(paymentMethodsProvider.notifier).remove(id);
      if (!mounted) return;
      AppSnackbar.success(context, 'Moyen de paiement supprimé.');
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, 'Suppression impossible pour le moment.');
      }
    }
  }

  Future<void> _setDefault(String id) async {
    try {
      await ref.read(paymentMethodsProvider.notifier).setDefault(id);
      if (!mounted) return;
      AppSnackbar.success(context, 'Moyen de paiement par défaut mis à jour.');
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, 'Mise à jour impossible pour le moment.');
      }
    }
  }
}
