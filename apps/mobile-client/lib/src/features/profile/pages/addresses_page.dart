import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_snackbar.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final List<_Address> _addresses = [
    _Address(id: '1', title: 'Domicile', address: 'Villa 123, Mermoz Pyrotechnie, Dakar', isDefault: true),
    _Address(id: '2', title: 'Bureau', address: 'Immeuble ABC, Plateau, Dakar', isDefault: false),
  ];

  void _delete(String id) async {
    final confirmed = await AppSnackbar.confirmDestructive(
      context,
      title: 'Supprimer cette adresse ?',
      body: 'Cette action est irréversible.',
      confirmLabel: 'Supprimer',
    );
    if (confirmed && mounted) {
      setState(() => _addresses.removeWhere((a) => a.id == id));
      AppSnackbar.success(context, 'Adresse supprimée.');
    }
  }

  void _setDefault(String id) {
    AppHaptics.select();
    setState(() {
      for (final a in _addresses) {
        a.isDefault = a.id == id;
      }
    });
    AppSnackbar.success(context, 'Adresse par défaut mise à jour.');
  }

  void _addAddress() {
    AppHaptics.medium();
    AppSnackbar.info(context, "Ajout d'adresse bientôt disponible.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Mes Adresses', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 60.h),
        children: [
          ..._addresses.map((a) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _AddressCard(
              address: a,
              onSetDefault: () => _setDefault(a.id),
              onDelete: () => _delete(a.id),
            ),
          )),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: _addAddress,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: 20.r, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Text(
                    'Ajouter une adresse',
                    style: AppTextStyles.labelLg.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onSetDefault,
    required this.onDelete,
  });

  final _Address address;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppShadows.card,
        border: address.isDefault
            ? Border.all(color: AppColors.primary, width: 1.5)
            : Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                address.title == 'Domicile' ? Icons.home_outlined : Icons.work_outline,
                size: 18.r,
                color: AppColors.onSurfaceVariant,
              ),
              SizedBox(width: 8.w),
              Text(address.title, style: AppTextStyles.labelLg),
              const Spacer(),
              if (address.isDefault)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Par défaut',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.primary,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            address.address,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              if (!address.isDefault)
                TextButton(
                  onPressed: onSetDefault,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Définir par défaut',
                    style: AppTextStyles.labelSm.copyWith(color: AppColors.primary),
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: onDelete,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Supprimer',
                  style: AppTextStyles.labelSm.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Address {
  _Address({
    required this.id,
    required this.title,
    required this.address,
    required this.isDefault,
  });
  final String id;
  final String title;
  final String address;
  bool isDefault;
}
