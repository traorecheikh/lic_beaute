import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

class PhoneCountry {
  const PhoneCountry({
    required this.code,
    required this.name,
    required this.dialCode,
    required this.flag,
    required this.digits,
  });

  final String code;
  final String name;
  final String dialCode;
  final String flag;
  final int digits;
}

// Keep this list for future multi-country support.
const kPhoneCountries = [
  PhoneCountry(code: 'SN', name: 'Sénégal', dialCode: '+221', flag: '🇸🇳', digits: 9),
  PhoneCountry(code: 'CI', name: "Côte d'Ivoire", dialCode: '+225', flag: '🇨🇮', digits: 10),
  PhoneCountry(code: 'ML', name: 'Mali', dialCode: '+223', flag: '🇲🇱', digits: 8),
  PhoneCountry(code: 'FR', name: 'France', dialCode: '+33', flag: '🇫🇷', digits: 9),
];

PhoneCountry get _sn => kPhoneCountries[0];

/// Phone number field with a fixed 🇸🇳 +221 prefix (single-country for now).
/// Full international number = dialCode + controller.text.
class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    required this.controller,
    this.labelText = 'Numéro',
    this.initialCountry,
    this.onCountryChanged,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  // Kept for API compat — ignored until multi-country is enabled.
  final PhoneCountry? initialCountry;
  final ValueChanged<PhoneCountry>? onCountryChanged;
  final String? Function(String?)? validator;

  PhoneCountry get _country => initialCountry ?? _sn;

  String? _defaultValidator(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < _country.digits - 1) {
      return 'Numéro invalide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_country.flag, style: TextStyle(fontSize: 18.sp)),
              SizedBox(width: 6.w),
              Text(
                _country.dialCode,
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              gapW8,
              Container(width: 1, height: 18.h, color: AppColors.outlineVariant),
            ],
          ),
        ),
      ),
      validator: validator ?? _defaultValidator,
    );
  }
}
