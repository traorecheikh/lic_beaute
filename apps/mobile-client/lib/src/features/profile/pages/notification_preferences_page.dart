import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/profile_provider.dart';

class NotificationPreferencesPage extends ConsumerWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Notifications', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox.shrink(),
        data: (profile) {
          if (profile == null) return const SizedBox.shrink();
          return ListView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 60.h),
            children: [
              _PreferenceGroup(
                label: 'Alertes',
                children: [
                  _PrefTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notifications push',
                    subtitle:
                        'Rappels de rendez-vous, confirmations et alertes salon.',
                    value: profile.pushOptIn,
                    onChanged: (value) => _update(
                      context,
                      ref,
                      pushOptIn: value,
                    ),
                  ),
                  _PrefTile(
                    icon: Icons.campaign_outlined,
                    title: 'Offres et promotions',
                    subtitle:
                        'Codes promo, nouveaux salons et actualités BeautéAvenue.',
                    value: profile.marketingOptIn,
                    onChanged: (value) => _update(
                      context,
                      ref,
                      marketingOptIn: value,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _update(
    BuildContext context,
    WidgetRef ref, {
    bool? pushOptIn,
    bool? marketingOptIn,
  }) async {
    try {
      await ref.read(profileProvider.notifier).updateProfile(
            pushOptIn: pushOptIn,
            marketingOptIn: marketingOptIn,
          );
    } catch (_) {
      if (!context.mounted) return;
      AppSnackbar.error(context, 'Impossible de sauvegarder la préférence.');
    }
  }
}

class _PreferenceGroup extends StatelessWidget {
  const _PreferenceGroup({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: children
                .asMap()
                .entries
                .map(
                  (entry) => Column(
                    children: [
                      entry.value,
                      if (entry.key < children.length - 1)
                        Divider(
                          height: 1,
                          indent: 58.w,
                          color: AppColors.outlineVariant.withValues(alpha: 0.5),
                        ),
                    ],
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class _PrefTile extends StatelessWidget {
  const _PrefTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 20.r, color: AppColors.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLg),
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
          SizedBox(width: 12.w),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
