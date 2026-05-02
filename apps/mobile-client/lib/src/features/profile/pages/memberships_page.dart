import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../models/account_models.dart';
import '../providers/benefits_provider.dart';

class MembershipsPage extends ConsumerWidget {
  const MembershipsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benefitsAsync = ref.watch(benefitsProvider);
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Mes abonnements', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: RefreshIndicator.adaptive(
        color: AppColors.primary,
        onRefresh: () => ref.refresh(benefitsProvider.future),
        child: benefitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: AppErrorState(
              title: 'Impossible de charger vos avantages',
              message: error.toString(),
              onRetry: () => ref.refresh(benefitsProvider.future),
            ),
          ),
        ),
        data: (benefits) {
          if (benefits.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: AppEmptyState(
              icon: Icons.workspace_premium_outlined,
              title: 'Aucun abonnement',
              subtitle:
                  'Vos abonnements et packages attribués par les salons apparaîtront ici.',
            ),
              ),
            );
          }
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 60.h),
            children: [
              ...benefits.map(
                (benefit) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _BenefitCard(benefit: benefit),
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final BenefitRecord benefit;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');
    final isActive = benefit.status == 'active';
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: AppShadows.card,
        border: isActive
            ? Border.all(color: AppColors.primary, width: 1.5)
            : Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      benefit.salonName,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(benefit.name, style: AppTextStyles.headlineSm),
                  ],
                ),
              ),
              _StatusPill(status: benefit.status),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            benefit.kind == 'membership' ? 'Abonnement salon' : 'Package',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
          ),
          if (benefit.remainingUses != null) ...[
            SizedBox(height: 12.h),
            Text(
              '${benefit.remainingUses} utilisation(s) restante(s)',
              style: AppTextStyles.bodyMd,
            ),
          ],
          if (benefit.expiresAt != null) ...[
            SizedBox(height: 8.h),
            Text(
              'Expire le ${formatter.format(benefit.expiresAt!)}',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
          if (benefit.billingDate != null) ...[
            SizedBox(height: 4.h),
            Text(
              'Échéance ${formatter.format(benefit.billingDate!)}',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'paused' => ('En pause', AppColors.secondary),
      'expired' => ('Expiré', AppColors.outline),
      'exhausted' => ('Épuisé', AppColors.outline),
      'cancelled' => ('Annulé', AppColors.error),
      _ => ('Actif', AppColors.primary),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(label, style: AppTextStyles.labelSm.copyWith(color: color)),
    );
  }
}
