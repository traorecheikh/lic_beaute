import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.neutral,
      appBar: const AppTopBar(
        title: 'Mes Adresses',
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 60.h),
        child: const AppEmptyState(
          icon: 'location',
          title: 'Aucune adresse enregistrée',
          subtitle:
              'La gestion des adresses de livraison sera disponible prochainement.',
        ),
      ),
    );
  }
}
