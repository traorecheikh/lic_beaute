import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_snackbar.dart';

class VouchersPage extends StatefulWidget {
  const VouchersPage({super.key});

  @override
  State<VouchersPage> createState() => _VouchersPageState();
}

class _VouchersPageState extends State<VouchersPage> {
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _applyCode() {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) {
      AppSnackbar.error(context, 'Veuillez entrer un code promo.');
      return;
    }
    AppHaptics.medium();
    // Simulate validation
    if (code == 'WELCOME10' || code == 'SUMMER25') {
      AppSnackbar.error(context, 'Ce code est déjà appliqué à votre compte.');
    } else {
      AppSnackbar.error(context, 'Code promo invalide ou expiré.');
    }
    _codeCtrl.clear();
  }

  void _copyCode(BuildContext context, String code) {
    AppHaptics.select();
    Clipboard.setData(ClipboardData(text: code));
    AppSnackbar.success(context, 'Code "$code" copié dans le presse-papiers.');
  }

  static const _vouchers = [
    _Voucher(
      title: 'Réduction de Bienvenue',
      code: 'WELCOME10',
      discount: '-10%',
      expiry: 'Expire le 31/12/2026',
      isPrimary: true,
    ),
    _Voucher(
      title: 'Fidélité Été',
      code: 'SUMMER25',
      discount: '2 500 XOF',
      expiry: 'Expire le 31/08/2026',
      isPrimary: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Mes Bons & Codes', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 60.h),
        children: [
          Text(
            'Codes actifs',
            style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          SizedBox(height: 12.h),
          ..._vouchers.map((v) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _VoucherCard(
              voucher: v,
              onCopy: () => _copyCode(context, v.code),
            ),
          )),
          SizedBox(height: 24.h),
          Text(
            'Ajouter un code promo',
            style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          SizedBox(height: 12.h),
          Container(
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
                    style: AppTextStyles.labelLg.copyWith(letterSpacing: 1.5),
                    decoration: InputDecoration(
                      hintText: 'CODE PROMO',
                      hintStyle: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.outline,
                        letterSpacing: 1,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onSubmitted: (_) => _applyCode(),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: _applyCode,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80.w, 44.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  child: const Text('Appliquer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  const _VoucherCard({required this.voucher, required this.onCopy});
  final _Voucher voucher;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final bgColor = voucher.isPrimary ? AppColors.primary : AppColors.secondary;
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, bgColor.withAlpha(204)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: bgColor.withAlpha(76),
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
                  voucher.discount,
                  style: AppTextStyles.headlineMd.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: onCopy,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          voucher.code,
                          style: AppTextStyles.labelLg.copyWith(
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        const Icon(Icons.copy_rounded, color: Colors.white70, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 48),
              SizedBox(height: 6.h),
              Text(
                voucher.expiry,
                style: AppTextStyles.bodySm.copyWith(color: Colors.white70, fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Voucher {
  const _Voucher({
    required this.title,
    required this.code,
    required this.discount,
    required this.expiry,
    required this.isPrimary,
  });
  final String title, code, discount, expiry;
  final bool isPrimary;
}
