import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../models/account_models.dart';
import '../providers/vouchers_provider.dart';

class VouchersPage extends ConsumerStatefulWidget {
  const VouchersPage({super.key});

  @override
  ConsumerState<VouchersPage> createState() => _VouchersPageState();
}

class _VouchersPageState extends ConsumerState<VouchersPage> {
  final _codeCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vouchersAsync = ref.watch(vouchersProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Mes bons et codes', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator.adaptive(
              color: AppColors.primary,
              onRefresh: () => ref.refresh(vouchersProvider.future),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
                children: [
                  Text(
                    'Codes enregistrés',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...vouchersAsync.when(
                    loading: () => const [
                      Center(child: CircularProgressIndicator()),
                    ],
                    error: (error, _) => [
                      AppErrorState(
                        title: 'Impossible de charger vos codes',
                        message: error.toString(),
                        onRetry: () => ref.refresh(vouchersProvider.future),
                      ),
                    ],
                    data: (vouchers) {
                      if (vouchers.isEmpty) {
                        return [
                          Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.outlineVariant,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.card_giftcard_outlined,
                                  size: 32.r,
                                  color: AppColors.primary,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Aucun code enregistré',
                                  style: AppTextStyles.labelLg,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Entrez un code ci-dessous pour le sauvegarder.',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ];
                      }
                      return [
                        for (var i = 0; i < vouchers.length; i++) ...[
                          if (i > 0) SizedBox(height: 12.h),
                          _VoucherCard(
                            voucher: vouchers[i],
                            onCopy: () => _copyCode(context, vouchers[i].code),
                          ),
                        ],
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ajouter un code promo',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: AppShadows.card,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _codeCtrl,
                              textCapitalization: TextCapitalization.characters,
                              style: AppTextStyles.labelLg.copyWith(
                                letterSpacing: 1.5,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'CODE PROMO',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                              ),
                              onSubmitted: (_) => _applyCode(),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          ElevatedButton(
                            onPressed: _submitting ? null : _applyCode,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(0, 56.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 16.h,
                              ),
                            ),
                            child: _submitting
                                ? SizedBox(
                                    width: 18.r,
                                    height: 18.r,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Appliquer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _applyCode() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) {
      AppSnackbar.error(context, 'Veuillez entrer un code promo.');
      return;
    }
    AppHaptics.medium();
    setState(() => _submitting = true);
    try {
      await ref.read(vouchersProvider.notifier).redeem(code);
      if (!mounted) return;
      AppSnackbar.success(context, 'Code ajouté à votre compte.');
      _codeCtrl.clear();
    } on DioException catch (error) {
      if (!mounted) return;
      final data = error.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message'] as String? ?? 'Code promo invalide.'
          : 'Code promo invalide.';
      AppSnackbar.error(context, message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _copyCode(BuildContext context, String code) {
    AppHaptics.select();
    Clipboard.setData(ClipboardData(text: code));
    AppSnackbar.success(context, 'Code "$code" copié.');
  }
}

class _VoucherCard extends StatelessWidget {
  const _VoucherCard({required this.voucher, required this.onCopy});

  final VoucherRecord voucher;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');
    final background = voucher.status == 'active'
        ? AppColors.primary
        : voucher.status == 'used'
        ? AppColors.secondary
        : AppColors.surfaceVariant;
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [background, background.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: background.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher.title,
                  style: AppTextStyles.bodySm.copyWith(color: Colors.white70),
                ),
                SizedBox(height: 4.h),
                Text(
                  voucher.discountLabel,
                  style: AppTextStyles.headlineMd.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  voucher.code,
                  style: AppTextStyles.labelLg.copyWith(
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  voucher.expiresAt == null
                      ? 'Sans date limite'
                      : 'Expire le ${formatter.format(voucher.expiresAt!)}',
                  style: AppTextStyles.bodySm.copyWith(color: Colors.white70),
                ),
                if (voucher.salonName != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    voucher.salonName!,
                    style: AppTextStyles.bodySm.copyWith(color: Colors.white70),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCopy,
                child: Text(
                  'Copier',
                  style: AppTextStyles.labelMd.copyWith(color: Colors.white),
                ),
              ),
              _StatusBadge(status: voucher.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      'used' => 'Utilisé',
      'expired' => 'Expiré',
      _ => 'Actif',
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(color: Colors.white),
      ),
    );
  }
}
