import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/widgets/app_bottom_bar.dart';
import '../../../core/widgets/app_booking_async_scaffold.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../../appointments/providers/bookings_list_provider.dart';
import '../../discovery/providers/cached_resource.dart';
import '../../profile/providers/payment_methods_provider.dart';
import '../providers/booking_create_provider.dart';
import '../providers/payment_methods_provider.dart';

class PaymentHandoffPage extends ConsumerStatefulWidget {
  final String bookingId;
  const PaymentHandoffPage({required this.bookingId, super.key});

  @override
  ConsumerState<PaymentHandoffPage> createState() => _PaymentHandoffPageState();
}

class _PaymentHandoffPageState extends ConsumerState<PaymentHandoffPage> {
  String? _selectedMethod;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(bookingDetailResourceProvider(widget.bookingId));
    final depositFromBooking = detailAsync.asData?.value.depositXof;
    if (depositFromBooking != null && depositFromBooking <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushReplacement(AppRoutes.success(widget.bookingId));
      });
      return const AppScaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final methodsAsync = ref.watch(paymentMethodsProvider);
    final defaultMethod = methodsAsync.asData?.value
        .where((m) => m.isDefault)
        .firstOrNull;
    final defaultChannel = _channelFromMethod(defaultMethod);

    if (_selectedMethod == null && defaultChannel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedMethod = defaultChannel);
      });
    }

    final paydunyaMethodsAsync = ref.watch(availablePaydunyaMethodsProvider);

    return AppBookingAsyncScaffold<Map<String, dynamic>>(
      bookingId: widget.bookingId,
      provider: bookingDetailResourceProvider,
      errorTitle: 'Paiement indisponible pour le moment',
      serverTitle: 'Le récapitulatif de paiement est indisponible',
      pageTitle: 'Paiement',
      pageSubtitle: 'Sécurisez votre réservation avec un acompte.',
      bottomNavigationBar: _buildBottomBar(),
      sliverBuilder: (resource) {
        final deposit =
            (resource.data?['depositAmountXof'] as num?)?.toInt() ?? 0;

        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppPressable(
                  onTap: () => context.pop(),
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: AppIcon('arrow-left', size: 20, color: AppColors.onSurface),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.12),
                          AppColors.secondary.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.primaryLight,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Acompte à régler',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              gapH4,
                              Text(
                                '$deposit XOF',
                                style: AppTextStyles.headlineLg.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              resource.salonName,
                              style: AppTextStyles.labelMd,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              resource.serviceName,
                              style: AppTextStyles.bodySm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text('Moyen de paiement', style: AppTextStyles.headlineSm),
                  if (defaultMethod != null) ...[
                    SizedBox(height: 6.h),
                    Text(
                      'Numéro enregistré: ${defaultMethod.phoneNumber}',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  SizedBox(height: 14.h),
                  paydunyaMethodsAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                    error: (error, _) => Text(
                      'Impossible de charger les moyens de paiement',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    data: (methods) => Column(
                      children: methods
                          .where((m) => m.enabled)
                          .map((method) => Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: _MethodTile(
                                  id: method.code,
                                  label: method.label,
                                  selected: _selectedMethod == method.code,
                                  onTap: () => setState(
                                      () => _selectedMethod = method.code),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }

  Widget _buildBottomBar() {
    return AppBottomBar(
      child: AppButton.primary(
        onPressed: _selectedMethod == null ? null : _pay,
        label: _selectedMethod != null
            ? 'Continuer avec ${_selectedMethod!.replaceAll('_', ' ')}'
            : 'Continuer',
        isLoading: _isProcessing,
      ),
    );
  }

  Future<void> _pay() async {
    setState(() => _isProcessing = true);
    try {
      final paymentResult = await ref
          .read(paymentInitiateProvider.notifier)
          .initiate(bookingId: widget.bookingId, channel: _selectedMethod!);
      final url = paymentResult?['redirectUrl'] as String?;
      final paymentId = paymentResult?['paymentId'] as String?;
      if (!context.mounted) return;
      if (url != null) {
        final uri = Uri.parse(url);
        if (uri.scheme == 'mock') {
          if (paymentId != null && paymentId.isNotEmpty) {
            await ref.read(paymentInitiateProvider.notifier).reconcile(paymentId);
          }
          if (!mounted) return;
          context.pushReplacement(AppRoutes.success(widget.bookingId));
          return;
        }
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (!context.mounted) return;
          context.pushReplacement(AppRoutes.success(widget.bookingId));
        } else {
          if (!context.mounted) return;
          AppSnackbar.error(context, "Impossible d'ouvrir l'application de paiement.");
        }
      } else {
        if (!context.mounted) return;
        context.pushReplacement(AppRoutes.success(widget.bookingId));
      }
    } catch (e) {
      if (!context.mounted) return;
      await _handlePaymentError(e);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handlePaymentError(Object error) async {
    if (error is DioException) {
      final code =
          (error.response?.data as Map<String, dynamic>?)?['code'] as String?;
      final retryAfter =
          (error.response?.data as Map<String, dynamic>?)?['message']
              as String?;

      switch (code) {
        case 'phone_required':
          AppSnackbar.error(
            context,
            'Ajoutez un numéro de téléphone à votre profil pour payer.',
          );
          await Future.delayed(const Duration(milliseconds: 600));
          if (mounted) context.push(AppRoutes.profileEdit);
          return;
        case 'reconcile_throttled':
          AppSnackbar.info(
            context,
            retryAfter ??
                'Réconciliation trop fréquente. Réessayez dans quelques secondes.',
          );
          return;
      }
    }
    if (!context.mounted) return;
    await context.handleHttpError(error, 'Échec du paiement.');
  }

  String? _channelFromMethod(dynamic method) {
    if (method == null) return null;
    final provider = method.provider as String? ?? '';
    if (provider == 'paydunya') {
      // For PayDunya, we need the actual method code from the stored method
      // This should be mapped via the payment methods provider
      return 'wave_senegal';
    }
    return null;
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.id,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String id, label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon('smartphone', size: 20, color: AppColors.onSurfaceVariant),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.labelLg),
                  SizedBox(height: 2.h),
                  Text(
                    id.replaceAll('_', ' ').toUpperCase(),
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              AppIcon('check-circle', color: AppColors.primary, size: 22)
            else
              AppIcon('circle', color: AppColors.outline, size: 22),
          ],
        ),
      ),
    );
  }
}
