import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../router/app_router.dart';

class ProfileBootstrapPage extends StatefulWidget {
  const ProfileBootstrapPage({super.key});

  @override
  State<ProfileBootstrapPage> createState() => _ProfileBootstrapPageState();
}

class _ProfileBootstrapPageState extends State<ProfileBootstrapPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String? _selectedCity;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),
              Text(
                'Complétez votre profil',
                style: AppTextStyles.displayMd.copyWith(color: colorScheme.onSurface),
              ),
              SizedBox(height: 12.h),
              Text(
                'Juste quelques détails pour personnaliser votre expérience.',
                style: AppTextStyles.bodyLg.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              SizedBox(height: 40.h),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_outline, size: 50.w, color: colorScheme.onSurfaceVariant),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: colorScheme.surface, width: 2),
                        ),
                        child: Icon(Icons.camera_alt, size: 16.w, color: colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Prénom'),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(labelText: 'Ville'),
                items: ['Dakar', 'Abidjan', 'Saint-Louis', 'Casablanca'].map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCity = value),
              ),
              SizedBox(height: 48.h),
              ElevatedButton(
                onPressed: () {
                  // Mock save and go to home
                  context.go(AppRoutes.home);
                },
                child: const Text('Commencer l\'aventure'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
