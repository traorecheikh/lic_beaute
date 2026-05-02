import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../features/discovery/providers/salon_detail_provider.dart';
import '../../../router/app_router.dart';
import '../providers/booking_funnel_provider.dart';

class StaffSelectionPage extends ConsumerStatefulWidget {
  final String serviceId;
  final String salonId;
  const StaffSelectionPage({
    super.key,
    required this.serviceId,
    required this.salonId,
  });

  @override
  ConsumerState<StaffSelectionPage> createState() => _StaffSelectionPageState();
}

class _StaffSelectionPageState extends ConsumerState<StaffSelectionPage> {
  String? _selectedStaffId = 'any';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final salonAsync = ref.watch(salonDetailProvider(widget.salonId));
    Future<void> refreshSalon() =>
        ref.refresh(salonDetailProvider(widget.salonId).future);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Étape 2 / 4',
              style: AppTextStyles.labelSm.copyWith(color: colorScheme.primary),
            ),
            Text('Choisir un prestataire', style: AppTextStyles.headlineMd),
          ],
        ),
      ),
      body: salonAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: EdgeInsets.all(24.r),
          child: AppErrorState(
            error: error,
            fallbackTitle: 'Impossible de charger l\'équipe',
            serverTitle: 'L\'équipe est indisponible',
            onRetry: refreshSalon,
          ),
        ),
        data: (salon) {
          final staff = (salon?.staff.toList() ?? const [])
              .where(
                (employee) => employee.serviceIds.contains(widget.serviceId),
              )
              .toList();

          return RefreshIndicator.adaptive(
            color: colorScheme.primary,
            onRefresh: refreshSalon,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.all(24.w),
              children: [
                _buildStaffItem(
                  context,
                  id: 'any',
                  name: 'Peu importe',
                  role: 'Sélectionner le premier disponible',
                  isAny: true,
                ),
                SizedBox(height: 24.h),
                Text(
                  'Équipe',
                  style: AppTextStyles.labelLg.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 16.h),
                ...staff.map(
                  (employee) => _buildStaffItem(
                    context,
                    id: employee.id,
                    name: employee.displayName,
                    role: employee.description ?? 'Spécialiste',
                    image: employee.avatarUrl,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: ElevatedButton(
            onPressed: _selectedStaffId == null
                ? null
                : () {
                    final salon = ref
                        .read(salonDetailProvider(widget.salonId))
                        .value;
                    final selected = _selectedStaffId == 'any'
                        ? null
                        : salon?.staff
                              .where((s) => s.id == _selectedStaffId)
                              .firstOrNull;
                    ref
                        .read(bookingFunnelProvider.notifier)
                        .selectEmployee(
                          employeeId: _selectedStaffId == 'any'
                              ? null
                              : _selectedStaffId,
                          employeeName: selected?.displayName,
                        );
                    context.push(
                      '${AppRoutes.bookingSlot}?serviceId=${widget.serviceId}&salonId=${widget.salonId}&employeeId=${_selectedStaffId == 'any' ? '' : _selectedStaffId}',
                    );
                  },
            child: const Text('Choisir ce prestataire'),
          ),
        ),
      ),
    );
  }

  Widget _buildStaffItem(
    BuildContext context, {
    required String id,
    required String name,
    required String role,
    String? image,
    bool isAny = false,
  }) {
    final isSelected = _selectedStaffId == id;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _selectedStaffId = id),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (isAny)
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.group_outlined, color: colorScheme.primary),
              )
            else
              CircleAvatar(
                radius: 28.w,
                backgroundImage: image != null && image.isNotEmpty
                    ? NetworkImage(image)
                    : null,
                child: image == null || image.isEmpty
                    ? Icon(Icons.person, color: colorScheme.primary)
                    : null,
              ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    role,
                    style: AppTextStyles.bodySm.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary)
            else
              Icon(Icons.circle_outlined, color: colorScheme.outlineVariant),
          ],
        ),
      ),
    );
  }
}
