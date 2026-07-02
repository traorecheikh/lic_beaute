import '../../../core/widgets/debounced_action.dart';
import '../widgets/booking_funnel_shared.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/widgets/app_icon.dart';
import '../utils/funnel_staff_scorer.dart';

class StaffSelectionPage extends ConsumerStatefulWidget {
  final String salonId;
  final String? serviceId;
  const StaffSelectionPage({super.key, required this.salonId, this.serviceId});

  @override
  ConsumerState<StaffSelectionPage> createState() => _StaffSelectionPageState();
}

class _StaffSelectionPageState extends ConsumerState<StaffSelectionPage> {
  String? _selectedStaffId = 'any';
  bool _isResolvingAny = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
      '[BOOKING_STAFF] open salonId=${widget.salonId} serviceId=${widget.serviceId}',
    );
  }

  String? get _resolvedServiceId {
    if (widget.serviceId != null && widget.serviceId!.isNotEmpty) {
      return widget.serviceId;
    }
    return ref.read(bookingFunnelProvider).serviceId;
  }

  @override
  Widget build(BuildContext context) {
    return AppBookingFunnelScaffold(
      salonId: widget.salonId,
      step: 2,
      title: 'Choisir un prestataire',
      bottomNavigationBar: AppBottomBar(
        child: AppButton.primary(
          onPressed: (_selectedStaffId == null || _isResolvingAny)
              ? null
              : debouncedAction(_onContinue),
          isLoading: _isResolvingAny,
          label: 'Continuer',
          height: 58.h,
        ),
      ),
      builder: (salon) {
        final serviceId = _resolvedServiceId;

        // Filter staff to those who can perform the chosen service.
        final allStaff = salon.staff.toList();
        final staff = (serviceId != null && serviceId.isNotEmpty)
            ? allStaff
                .where(
                  (s) =>
                      s.serviceIds.contains(serviceId) ||
                      s.serviceIds.isEmpty,
                )
                .toList()
            : allStaff;
        debugPrint(
          '[BOOKING_STAFF] render salonId=${widget.salonId} serviceId=$serviceId staff=${staff.length}',
        );

        final showPhotos = salon.teamDisplay.showPhotos;
        final showDesc = salon.teamDisplay.showDescriptions;

        if (showPhotos) {
          return _buildAvatarGrid(staff, showDesc: showDesc);
        }
        return _buildCompactList(staff, showDesc: showDesc);
      },
    );
  }

  // ─── Avatar grid (showPhotos = true) ───────────────────────────────────────

  Widget _buildAvatarGrid(
    List<SalonDetailStaffInner> staff, {
    required bool showDesc,
  }) {
    // null sentinel = "N'importe qui"
    final items = <SalonDetailStaffInner?>[null, ...staff];
    final cellWidth = (MediaQuery.of(context).size.width - 40.w - 32.w) / 3;

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 100.h),
      children: [
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: [
            for (final item in items)
              _AvatarCell(
                key: ValueKey(item == null ? 'any' : item.id),
                name: item == null ? "N'importe qui" : item.displayName,
                avatarUrl: item?.avatarUrl,
                description: showDesc ? item?.description : null,
                isAny: item == null,
                isSelected:
                    _selectedStaffId == (item == null ? 'any' : item.id),
                width: cellWidth,
                onTap: () {
                  AppHaptics.light();
                  setState(
                    () => _selectedStaffId = item == null ? 'any' : item.id,
                  );
                },
              ),
          ],
        ),
      ],
    );
  }

  // ─── Compact list (showPhotos = false) ─────────────────────────────────────

  Widget _buildCompactList(
    List<SalonDetailStaffInner> staff, {
    required bool showDesc,
  }) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 100.h),
      itemCount: staff.length + 1,
      separatorBuilder: (context0, i0) => gapH12,
      itemBuilder: (context, i) {
        if (i == 0) {
          return _listCard(
            id: 'any',
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.primaryLight,
                  child: AppIcon('users', size: 20, color: AppColors.primary),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text("N'importe qui", style: AppTextStyles.labelLg),
                ),
              ],
            ),
          );
        }
        final s = staff[i - 1];
        return _listCard(
          id: s.id,
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: s.avatarUrl != null
                    ? CachedNetworkImageProvider(s.avatarUrl!)
                    : null,
                backgroundColor: AppColors.surfaceVariant,
                child: s.avatarUrl == null
                    ? AppIcon('user', size: 20, color: AppColors.onSurfaceVariant)
                    : null,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.displayName, style: AppTextStyles.labelLg),
                    if (showDesc &&
                        s.description != null &&
                        s.description!.isNotEmpty) ...[
                      gapH4,
                      Text(
                        s.description!,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _listCard({required String id, required Widget child}) {
    final isSelected = _selectedStaffId == id;
    return AppSelectableCard(
      selected: isSelected,
      onTap: () {
        AppHaptics.light();
        setState(() => _selectedStaffId = id);
      },
      child: child,
    );
  }

  // ─── Navigation ────────────────────────────────────────────────────────────

  Future<void> _onContinue() async {
    final salon = ref.read(salonDetailProvider(widget.salonId)).value;
    final serviceId = _resolvedServiceId;
    if (serviceId == null || serviceId.isEmpty) {
      AppSnackbar.error(
        context,
        'Prestation introuvable. Reprenez la réservation.',
      );
      return;
    }

    String? selectedStaffId = _selectedStaffId == 'any'
        ? null
        : _selectedStaffId;
    String name = 'Sans préférence';

    if (_selectedStaffId == 'any') {
      if (salon != null) {
        setState(() => _isResolvingAny = true);
        try {
          selectedStaffId = await resolveBestStaffId(
            ref: ref,
            salonId: widget.salonId,
            serviceId: serviceId,
            salon: salon,
          );
          final picked = salon.staff
              .where((e) => e.id == selectedStaffId)
              .firstOrNull;
          if (picked != null) {
            name = picked.displayName;
          }
        } finally {
          if (mounted) setState(() => _isResolvingAny = false);
        }
      }
    } else {
      final s = salon?.staff.where((e) => e.id == _selectedStaffId).firstOrNull;
      if (s == null) {
        AppSnackbar.error(context, 'Prestataire introuvable.');
        return;
      }
      name = s.displayName;
      selectedStaffId = s.id;
    }

    ref
        .read(bookingFunnelProvider.notifier)
        .selectEmployee(employeeId: selectedStaffId, employeeName: name);
    if (!mounted) return;
    final employeeParam = selectedStaffId == null
        ? ''
        : '&employeeId=$selectedStaffId';
    context.push(
      '${AppRoutes.bookingSlot}?salonId=${widget.salonId}&serviceId=$serviceId$employeeParam',
    );
  }
}

// ─── Avatar cell widget ───────────────────────────────────────────────────────

class _AvatarCell extends StatelessWidget {
  const _AvatarCell({
    required this.name,
    required this.isSelected,
    required this.isAny,
    required this.onTap,
    required this.width,
    this.avatarUrl,
    this.description,
    super.key,
  });

  final String name;
  final String? avatarUrl;
  final String? description;
  final bool isSelected;
  final bool isAny;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected ? null : AppShadows.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 26.r,
                    backgroundColor: isAny
                        ? AppColors.primaryLight
                        : AppColors.surfaceVariant,
                    backgroundImage: avatarUrl != null
                        ? CachedNetworkImageProvider(avatarUrl!)
                        : null,
                    child: avatarUrl == null
                        ? AppIcon(
                            isAny ? 'users' : 'user',
                            size: 20,
                            color: isAny
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          )
                        : null,
                  ),
                  if (isSelected)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 18.r,
                        height: 18.r,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: AppIcon('check', size: 11, color: AppColors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                name,
                style: AppTextStyles.labelMd.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (description != null && description!.isNotEmpty) ...[
                SizedBox(height: 3.h),
                Text(
                  description!,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
