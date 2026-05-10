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

class PaymentHandoffPage extends ConsumerStatefulWidget {
  final String bookingId;
  const PaymentHandoffPage({required this.bookingId, super.key});

  @override
  ConsumerState<PaymentHandoffPage> createState() => _PaymentHandoffPageState();
}

class _PaymentHandoffPageState extends ConsumerState<PaymentHandoffPage> {
  String? _selectedMethod;
  bool _isProcessing = false;
  static const Map<String, String> _channelLabels = {
    'wave': 'Wave',
    'orange_money': 'Orange Money',
    'free_money': 'Free Money',
  };

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
                  _MethodTile(
                    id: 'wave',
                    label: 'Wave',
                    subtitle: 'Paiement mobile rapide',
                    icon: 'sparkle',
                    iconColor: const Color(0xFF1DB0F5),
                    selected: _selectedMethod == 'wave',
                    onTap: () => setState(() => _selectedMethod = 'wave'),
                  ),
                  SizedBox(height: 10.h),
                  _MethodTile(
                    id: 'orange_money',
                    label: 'Orange Money',
                    subtitle: 'Paiement mobile Orange',
                    icon: 'star',
                    iconColor: const Color(0xFFFF6B00),
                    selected: _selectedMethod == 'orange_money',
                    onTap: () =>
                        setState(() => _selectedMethod = 'orange_money'),
                  ),
                  SizedBox(height: 10.h),
                  _MethodTile(
                    id: 'free_money',
                    label: 'Free Money',
                    subtitle: 'Paiement mobile Free',
                    icon: 'user',
                    iconColor: const Color(0xFF16A34A),
                    selected: _selectedMethod == 'free_money',
                    onTap: () => setState(() => _selectedMethod = 'free_money'),
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
            ? 'Continuer avec ${_channelLabels[_selectedMethod] ?? _selectedMethod}'
            : 'Continuer',
        isLoading: _isProcessing,
      ),
    );
  }

  Future<void> _pay() async {
    setState(() => _isProcessing = true);
    try {
      final url = await ref
          .read(paymentInitiateProvider.notifier)
          .initiate(bookingId: widget.bookingId, channel: _selectedMethod!);
      if (!context.mounted) return;
      if (url != null) {
        final uri = Uri.parse(url);
        if (uri.scheme == 'mock') {
          if (!mounted) return;
          context.pushReplacement(AppRoutes.success(widget.bookingId));
          return;
        }
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (!context.mounted) return;
          // ignore: use_build_context_synchronously
          context.pushReplacement(AppRoutes.success(widget.bookingId));
        } else {
          if (!context.mounted) return;
          // ignore: use_build_context_synchronously
          AppSnackbar.error(context, "Impossible d'ouvrir l'application de paiement.");
        }
      } else {
        if (!context.mounted) return;
        // ignore: use_build_context_synchronously
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
    // ignore: use_build_context_synchronously
    await context.handleHttpError(error, 'Échec du paiement.');
  }

  String? _channelFromMethod(dynamic method) {
    if (method == null) return null;
    final provider = method.provider as String? ?? '';
    if (_channelLabels.containsKey(provider)) return provider;
    final label = (method.label as String?)?.toLowerCase() ?? '';
    if (label.contains('orange')) return 'orange_money';
    if (label.contains('free')) return 'free_money';
    if (label.contains('wave')) return 'wave';
    if (provider == 'om') return 'orange_money';
    return null;
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.selected,
    required this.onTap,
  });

  final String id, label, subtitle, icon;
  final Color iconColor;
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
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(child: AppIcon(icon, color: iconColor, size: 22)),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.labelLg),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
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
