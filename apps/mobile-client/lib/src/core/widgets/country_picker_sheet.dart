import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'phone_country.dart';

/// Bottom sheet to pick a phone country from a list.
class CountryPickerSheet extends StatelessWidget {
  const CountryPickerSheet({
    required this.countries,
    required this.selected,
    super.key,
  });

  final List<PhoneCountry> countries;
  final PhoneCountry selected;

  /// Shows the bottom sheet and returns the picked country, or null if dismissed.
  static Future<PhoneCountry?> show(BuildContext context, {
    required List<PhoneCountry> countries,
    required PhoneCountry selected,
  }) {
    return showModalBottomSheet<PhoneCountry>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => CountryPickerSheet(countries: countries, selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text('Choisir un pays', style: AppTextStyles.headlineSm),
                  ),
                ),
                Semantics(
                  button: true, label: 'Fermer',
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(Icons.close, color: AppColors.onSurfaceVariant, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
              itemCount: countries.length,
              separatorBuilder: (_, _) => SizedBox(height: 4.h),
              itemBuilder: (_, i) {
                final country = countries[i];
                final isSelected = country.code == selected.code;
                return Semantics(
                  button: true,
                  label: '${country.name}, indicatif ${country.dialCode}${isSelected ? ", sélectionné" : ""}',
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(country),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight : AppColors.surface,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          ExcludeSemantics(child: Text(country.flag, style: TextStyle(fontSize: 24.sp))),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(country.name, style: AppTextStyles.labelLg.copyWith(
                                  color: isSelected ? AppColors.primary : AppColors.onSurface)),
                                Text(country.dialCode, style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Semantics(
                              label: 'Sélectionné',
                              child: Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
