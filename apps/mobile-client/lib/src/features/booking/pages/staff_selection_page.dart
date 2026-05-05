import '../widgets/booking_funnel_shared.dart';

class StaffSelectionPage extends ConsumerStatefulWidget {
  final String salonId;
  const StaffSelectionPage({super.key, required this.salonId});

  @override
  ConsumerState<StaffSelectionPage> createState() => _StaffSelectionPageState();
}

class _StaffSelectionPageState extends ConsumerState<StaffSelectionPage> {
  String? _selectedStaffId = 'any';

  @override
  Widget build(BuildContext context) {
    return AppBookingFunnelScaffold(
      salonId: widget.salonId,
      step: 2,
      title: 'Choisir un prestataire',
      bottomNavigationBar: AppBottomBar(
        child: AppButton.primary(
          onPressed: _selectedStaffId == null ? null : _onContinue,
          label: 'Continuer',
        ),
      ),
      builder: (salon) {
        final staff = salon.staff.toList();
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 100.h),
          itemCount: staff.length + 1,
          separatorBuilder: (_, __) => gapH12,
          itemBuilder: (context, i) {
            if (i == 0) {
              return AppSelectableCard(
                selected: _selectedStaffId == 'any',
                onTap: () {
                  AppHaptics.light();
                  setState(() => _selectedStaffId = 'any');
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(
                        Icons.group_outlined,
                        color: AppColors.primary,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        'N’importe qui',
                        style: AppTextStyles.labelLg,
                      ),
                    ),
                  ],
                ),
              );
            }

            final s = staff[i - 1];
            final isSelected = _selectedStaffId == s.id;
            return AppSelectableCard(
              selected: isSelected,
              onTap: () {
                AppHaptics.light();
                setState(() => _selectedStaffId = s.id);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundImage:
                        s.avatarUrl != null ? NetworkImage(s.avatarUrl!) : null,
                    child: s.avatarUrl == null
                        ? Icon(Icons.person_outline, size: 20.r)
                        : null,
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(s.name, style: AppTextStyles.labelLg),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onContinue() {
    final salon = ref.read(salonDetailProvider(widget.salonId)).value;
    String name = 'Peu importe';
    if (_selectedStaffId != 'any') {
      final s = salon?.staff.where((e) => e.id == _selectedStaffId).firstOrNull;
      if (s == null) {
        AppSnackbar.error(context, 'Prestataire introuvable.');
        return;
      }
      name = s.displayName;
    }

    ref.read(bookingFunnelProvider.notifier).selectEmployee(
      employeeId: _selectedStaffId == 'any' ? null : _selectedStaffId,
      employeeName: _selectedStaffId == 'any' ? 'Sans préférence' : name,
    );
    context.push(
      '${AppRoutes.bookingSlot}?salonId=${widget.salonId}',
    );
  }
}
