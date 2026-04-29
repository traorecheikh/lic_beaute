import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../router/app_router.dart';

class ServiceSelectionPage extends StatefulWidget {
  final String salonId;
  const ServiceSelectionPage({super.key, required this.salonId});

  @override
  State<ServiceSelectionPage> createState() => _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends State<ServiceSelectionPage> {
  String? _selectedServiceId;

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
            Text('Choisir une prestation', style: AppTextStyles.headlineMd),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          _buildCategoryHeader('Populaire'),
          _buildServiceItem(
            context,
            id: 's1',
            name: 'Coiffure & Brushing',
            duration: '60 min',
            price: '15.000 XOF',
            description: 'Shampoing, soin et brushing professionnel.',
          ),
          SizedBox(height: 32.h),
          _buildCategoryHeader('Soins Cheveux'),
          _buildServiceItem(
            context,
            id: 's2',
            name: 'Coloration Complète',
            duration: '120 min',
            price: '35.000 XOF',
            description: 'Application d\'une couleur sur l\'ensemble de la chevelure.',
          ),
          _buildServiceItem(
            context,
            id: 's3',
            name: 'Tissage Naturel',
            duration: '180 min',
            price: '45.000 XOF',
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: ElevatedButton(
            onPressed: _selectedServiceId == null 
              ? null 
              : () => context.push(
                  '${AppRoutes.bookingStaff}?serviceId=$_selectedServiceId&salonId=${widget.salonId}'
                ),
            child: const Text('Continuer'),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(title, style: AppTextStyles.labelLg.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required String id,
    required String name,
    required String duration,
    required String price,
    String? description,
  }) {
    final isSelected = _selectedServiceId == id;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _selectedServiceId = id),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(name, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600))),
                Text(price, style: AppTextStyles.bodyLg.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4.h),
            Text(duration, style: AppTextStyles.bodySm.copyWith(color: colorScheme.onSurfaceVariant)),
            if (description != null) ...[
              SizedBox(height: 8.h),
              Text(description, style: AppTextStyles.bodySm),
            ],
          ],
        ),
      ),
    );
  }
}
