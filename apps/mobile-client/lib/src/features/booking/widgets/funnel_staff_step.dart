import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../discovery/providers/salon_detail_provider.dart';

class FunnelStaffStep extends ConsumerWidget {
  const FunnelStaffStep({
    required this.salonId,
    required this.serviceId,
    required this.scrollCtrl,
    required this.selectedId,
    required this.onSelect,
    super.key,
  });

  final String salonId, serviceId;
  final ScrollController scrollCtrl;
  final String selectedId;
  final void Function(String id) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonAsync = ref.watch(salonDetailProvider(salonId));
    return salonAsync.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (_, _) => Center(child: Text(AppStrings.loadStaffError)),
      data: (salon) {
        final staff = (salon?.staff.toList() ?? [])
            .where(
              (e) => e.serviceIds.contains(serviceId) || e.serviceIds.isEmpty,
            )
            .toList();

        final items =
            <(String id, String name, String role, String? image, bool isAny)>[
              ('any', AppStrings.funnelAnyStaff, AppStrings.funnelFirstAvailable, null, true),
              ...staff.map(
                (e) => (
                  e.id,
                  e.displayName,
                  e.description ?? AppStrings.funnelSpecialist,
                  e.avatarUrl,
                  false,
                ),
              ),
            ];

        return ListView.separated(
          controller: scrollCtrl,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
          itemCount: items.length,
          separatorBuilder: (_, _) => SizedBox(height: 10.h),
          itemBuilder: (_, i) {
            final (id, name, role, image, isAny) = items[i];
            final isSelected = selectedId == id;
            return FunnelStaffCard(
              name: name,
              role: role,
              image: image,
              isAny: isAny,
              selected: isSelected,
              onTap: () => onSelect(id),
            );
          },
        );
      },
    );
  }
}

class FunnelStaffCard extends StatelessWidget {
  const FunnelStaffCard({
    required this.name,
    required this.role,
    this.image,
    required this.isAny,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String name, role;
  final String? image;
  final bool isAny, selected;
  final VoidCallback onTap;

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

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
            if (isAny)
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '···',
                    style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              )
            else
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: (image != null && image!.isNotEmpty)
                    ? CachedNetworkImageProvider(image!)
                    : null,
                child: (image == null || image!.isEmpty)
                    ? Text(
                        _initials(name),
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.labelLg),
                  Text(
                    role,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : AppColors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.outline,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: AppIcon('check', size: 13, color: AppColors.white),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
