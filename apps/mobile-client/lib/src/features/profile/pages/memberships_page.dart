import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../models/account_models.dart';
import '../providers/benefits_provider.dart';
import '../widgets/profile_card_shell.dart';

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
              icon: 'sparkle',
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
    return ProfileCardShell(
      highlighted: isActive,
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
              Builder(builder: (_) {
                final (label, color) = switch (benefit.status) {
                  'paused' => ('En pause', AppColors.secondary),
                  'expired' => ('Expiré', AppColors.outline),
                  'exhausted' => ('Épuisé', AppColors.outline),
                  'cancelled' => ('Annulé', AppColors.error),
                  _ => ('Actif', AppColors.primary),
                };
                return AppBadge(label: label, color: color);
              }),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            benefit.kind == 'membership' ? 'Abonnement salon' : 'Package',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
          ),
          if (benefit.remainingUses != null) ...[
            gapH12,
            Text(
              '${benefit.remainingUses} utilisation(s) restante(s)',
              style: AppTextStyles.bodyMd,
            ),
          ],
          if (benefit.expiresAt != null) ...[
            gapH8,
            Text(
              'Expire le ${formatter.format(benefit.expiresAt!)}',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
          if (benefit.billingDate != null) ...[
            gapH4,
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

