import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../router/app_router.dart';

class StaffSelectionPage extends StatefulWidget {
  final String serviceId;
  final String salonId;
  const StaffSelectionPage({super.key, required this.serviceId, required this.salonId});

  @override
  State<StaffSelectionPage> createState() => _StaffSelectionPageState();
}

class _StaffSelectionPageState extends State<StaffSelectionPage> {
  String? _selectedStaffId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Étape 1 / 4', style: AppTextStyles.labelSm.copyWith(color: colorScheme.primary)),
            Text('Choisir un prestataire', style: AppTextStyles.headlineMd),
          ],
        ),
      ),
      body: ListView(
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
          Text('Équipe', style: AppTextStyles.labelLg.copyWith(color: colorScheme.onSurfaceVariant)),
          SizedBox(height: 16.h),
          _buildStaffItem(
            context,
            id: 'staff-1',
            name: 'Marie Ndiaye',
            role: 'Coiffeuse Senior',
            image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
          ),
          _buildStaffItem(
            context,
            id: 'staff-2',
            name: 'Awa Diop',
            role: 'Spécialiste Coloration',
            image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200',
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: ElevatedButton(
            onPressed: _selectedStaffId == null 
              ? null 
              : () => context.push(
                  '${AppRoutes.bookingSlot}?serviceId=${widget.serviceId}&salonId=${widget.salonId}&employeeId=$_selectedStaffId'
                ),
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
            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (isAny)
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(color: colorScheme.surfaceVariant, shape: BoxShape.circle),
                child: Icon(Icons.group_outlined, color: colorScheme.primary),
              )
            else
              CircleAvatar(
                radius: 28.w,
                backgroundImage: NetworkImage(image!),
              ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                  Text(role, style: AppTextStyles.bodySm.copyWith(color: colorScheme.onSurfaceVariant)),
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
