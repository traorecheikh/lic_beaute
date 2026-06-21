import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_tile.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../providers/profile_provider.dart';

class NotificationPreferencesPage extends ConsumerWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return AppScaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppTopBar(title: AppStrings.notificationsTitle, showBackButton: true),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Padding(
          padding: EdgeInsets.all(24.r),
          child: AppErrorState(
            error: error,
            fallbackTitle: AppStrings.loadPrefsError,
            serverTitle: AppStrings.serviceUnavailable,
            onRetry: () => ref.refresh(profileProvider.future),
          ),
        ),
        data: (profile) {
          if (profile == null) return const SizedBox.shrink();
          return ListView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 60.h),
            children: [
              _PreferenceGroup(
                label: AppStrings.alertsSection,
                children: [
                  _PrefTile(
                    icon: 'bell',
                    title: AppStrings.pushNotifications,
                    subtitle: AppStrings.pushNotificationsSubtitle,
                    value: profile.pushOptIn,
                    onChanged: (value) => _update(
                      context,
                      ref,
                      pushOptIn: value,
                    ),
                  ),
                  // Promos hidden —
                  // _PrefTile(
                  //   icon: Icons.campaign_outlined,
                  //   title: 'Offres et promotions',
                  //   subtitle:
                  //       'Codes promo, nouveaux salons et actualités BeautéAvenue.',
                  //   value: profile.marketingOptIn,
                  //   onChanged: (value) => _update(
                  //     context,
                  //     ref,
                  //     marketingOptIn: value,
                  //   ),
                  // ),
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
      AppSnackbar.error(context, AppStrings.savePrefError);
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
            borderRadius: BorderRadius.circular(AppRadius.xl.r),
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

  final String icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primary,
      ),
    );
  }
}
