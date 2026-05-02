import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';
import '../../appointments/providers/bookings_list_provider.dart';
import '../providers/booking_create_provider.dart';
import '../../discovery/widgets/stale_data_notice.dart';
import '../../profile/providers/payment_methods_provider.dart';

class PaymentHandoffPage extends ConsumerStatefulWidget {
  const PaymentHandoffPage({super.key, required this.bookingId});
  final String bookingId;

  @override
  ConsumerState<PaymentHandoffPage> createState() => _PaymentHandoffPageState();
}

class _PaymentHandoffPageState extends ConsumerState<PaymentHandoffPage> {
  String _selectedMethod = 'wave';
  bool _initiating = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(
      bookingDetailResourceProvider(widget.bookingId),
    );
    final paymentMethods =
        ref.watch(paymentMethodsProvider).valueOrNull ?? const [];
    dynamic defaultMethod;
    for (final method in paymentMethods) {
      if (method.isDefault) {
        defaultMethod = method;
        break;
      }
    }
    if (defaultMethod != null) {
      final provider = defaultMethod.provider == 'orange_money' ? 'om' : 'wave';
      if (_selectedMethod != provider) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _selectedMethod = provider);
          }
        });
      }
    }
    Future<void> refreshBooking() =>
        ref.refresh(bookingDetailResourceProvider(widget.bookingId).future);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: EdgeInsets.all(24.r),
          child: AppErrorState(
            error: error,
            fallbackTitle: 'Paiement indisponible pour le moment',
            serverTitle: 'Le récapitulatif de paiement est indisponible',
            onRetry: refreshBooking,
          ),
        ),
        data: (resource) {
          final detail = resource.data;
          final salonName = (detail?['salonName'] as String?) ?? 'Salon';
          final serviceName = (detail?['serviceName'] as String?) ?? 'Service';
          final deposit = (detail?['depositAmountXof'] as num?)?.toInt() ?? 0;

          return Stack(
            children: [
              RefreshIndicator.adaptive(
                color: AppColors.primary,
                onRefresh: refreshBooking,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    if (resource.isStale && resource.cachedAt != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                          child: StaleDataNotice(cachedAt: resource.cachedAt!),
                        ),
                      ),
                    SliverSafeArea(
                      bottom: false,
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 36.r,
                                  height: 36.r,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    boxShadow: AppShadows.sm,
                                  ),
                                  child: Center(
                                    child: AppIcon(
                                      'arrow-left',
                                      size: 18,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Paiement', style: AppTextStyles.displaySm),
                            SizedBox(height: 4.h),
                            Text(
                              'Sécurisez votre réservation avec un acompte.',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 28.h),

                            // Amount card
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Acompte à régler',
                                          style: AppTextStyles.bodySm.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          '$deposit XOF',
                                          style: AppTextStyles.headlineLg
                                              .copyWith(
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
                                        salonName,
                                        style: AppTextStyles.labelMd,
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        serviceName,
                                        style: AppTextStyles.bodySm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 28.h),

                            Text(
                              'Moyen de paiement',
                              style: AppTextStyles.headlineSm,
                            ),
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
                              onTap: () {
                                AppHaptics.select();
                                setState(() => _selectedMethod = 'wave');
                              },
                            ),
                            SizedBox(height: 10.h),
                            _MethodTile(
                              id: 'om',
                              label: 'Orange Money',
                              subtitle: 'Paiement mobile Orange',
                              icon: 'star',
                              iconColor: const Color(0xFFFF6B00),
                              selected: _selectedMethod == 'om',
                              onTap: () {
                                AppHaptics.select();
                                setState(() => _selectedMethod = 'om');
                              },
                            ),
                            SizedBox(height: 20.h),

                            Container(
                              padding: EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  AppIcon(
                                    'check',
                                    size: 14,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      'Le paiement en ligne sera activé prochainement.',
                                      style: AppTextStyles.bodyXs,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 140.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // CTA
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.onSurface.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: _initiating ? null : _continueToProvider,
                        child: Text(
                          'Continuer via ${_selectedMethod == 'wave' ? 'Wave' : 'Orange Money'}',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _continueToProvider() async {
    AppHaptics.medium();
    setState(() => _initiating = true);
    try {
      final provider = _selectedMethod == 'wave' ? 'wave' : 'orange_money';
      final redirectUrl = await ref
          .read(paymentInitiateProvider.notifier)
          .initiate(bookingId: widget.bookingId, provider: provider);
      if (redirectUrl != null) {
        final uri = Uri.tryParse(redirectUrl);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
      if (!mounted) return;
      context.go(AppRoutes.success(widget.bookingId));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’initier le paiement.')),
      );
    } finally {
      if (mounted) {
        setState(() => _initiating = false);
      }
    }
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
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            width: selected ? 1.8 : 1,
          ),
          boxShadow: selected ? null : AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(child: AppIcon(icon, size: 20, color: iconColor)),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.labelLg),
                  Text(subtitle, style: AppTextStyles.bodySm),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.outline,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: Icon(Icons.check, color: Colors.white, size: 13.r),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
