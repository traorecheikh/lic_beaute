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

// Default countries list. Can be overridden via the countries parameter.
const kPhoneCountries = [
  PhoneCountry(code: 'SN', name: 'Sénégal', dialCode: '+221', flag: '🇸🇳', digits: 9),
  PhoneCountry(code: 'CI', name: "Côte d'Ivoire", dialCode: '+225', flag: '🇨🇮', digits: 10),
  PhoneCountry(code: 'ML', name: 'Mali', dialCode: '+223', flag: '🇲🇱', digits: 8),
  PhoneCountry(code: 'FR', name: 'France', dialCode: '+33', flag: '🇫🇷', digits: 9),
];

PhoneCountry get _sn => kPhoneCountries[0];

/// Formatted phone number: removes all non-digits and groups by the country's
/// digit pattern. Each country defines its own grouping via [digits].
/// Default grouping: groups of 2 from the right.
String _formatPhone(String raw, int countryDigits) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return digits;

  // Build groups intelligently: for 9 digits → XX XXX XX XX
  // For 10 digits → XX XX XX XX XX
  // For 8 digits → XX XX XX XX
  final buffer = StringBuffer();
  final length = digits.length;

  if (countryDigits == 9) {
    // Senegal: XX XXX XX XX
    for (int i = 0; i < length; i++) {
      if (i == 2 || i == 5 || i == 7) buffer.write(' ');
      buffer.write(digits[i]);
    }
  } else {
    // Generic: groups of 2
    for (int i = 0; i < length; i++) {
      if (i > 0 && i % 2 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
  }
  return buffer.toString();
}

/// A phone number input field with:
/// - Country flag + dial code prefix (tappable to open a country picker bottom sheet)
/// - Automatic phone number formatting based on country digits
/// - Proper Semantics for accessibility
/// - Configurable list of countries
class AppPhoneField extends StatefulWidget {
  const AppPhoneField({
    required this.controller,
    this.labelText = 'Numéro',
    this.initialCountry,
    this.onCountryChanged,
    this.validator,
    this.countries = kPhoneCountries,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final PhoneCountry? initialCountry;
  final ValueChanged<PhoneCountry>? onCountryChanged;
  final String? Function(String?)? validator;
  final List<PhoneCountry> countries;

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  late PhoneCountry _country;
  late TextEditingController _controller;
  bool _focused = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _country = widget.initialCountry ?? _sn;
    _controller = widget.controller;
    _controller.addListener(_onChanged);
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  void _onChanged() {
    setState(() {});
  }

  @override
  void didUpdateWidget(AppPhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      _controller = widget.controller;
      _controller.addListener(_onChanged);
    }
    if (widget.initialCountry?.code != oldWidget.initialCountry?.code &&
        widget.initialCountry != null) {
      setState(() => _country = widget.initialCountry!);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _focusNode.dispose();
    super.dispose();
  }



  void _openCountryPicker() {
    showModalBottomSheet<PhoneCountry>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return _CountryPickerSheet(
          countries: widget.countries,
          selected: _country,
        );
      },
    ).then((picked) {
      if (picked != null && picked.code != _country.code) {
        setState(() => _country = picked);
        widget.onCountryChanged?.call(picked);
      }
    });
  }

  String? _defaultValidator(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < _country.digits - 1) {
      return 'Numéro invalide (${_country.digits} chiffres attendus)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final errorTextRaw = widget.validator?.call(_controller.text) ??
        _defaultValidator(_controller.text);
    final hasError = errorTextRaw != null;

    return Semantics(
      label: '${widget.labelText ?? "Numéro de téléphone"}, ${_country.name} code ${_country.dialCode}',
      hint: 'Saisissez votre numéro de téléphone',
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _PhoneNumberFormatter(country: _country),
        ],
        decoration: InputDecoration(
          labelText: widget.labelText,
          errorText: hasError ? errorTextRaw : null,
          prefixIcon: Semantics(
            button: true,
            label: 'Changer de pays. Actuellement ${_country.name}',
            child: GestureDetector(
              onTap: _openCountryPicker,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Text(_country.flag, style: TextStyle(fontSize: 18.sp)),
                    ),
                    SizedBox(width: 4.w),
                    Semantics(
                      label: 'Indicatif ${_country.dialCode}',
                      child: Text(
                        _country.dialCode,
                        style: AppTextStyles.labelLg.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Semantics(
                      label: 'Changer de pays',
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 18,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    gapW8,
                    Container(
                      width: 1,
                      height: 18.h,
                      color: _focused ? AppColors.primary : AppColors.outlineVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide(
              color: AppColors.outline.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.8,
            ),
          ),
        ),
        validator: widget.validator ?? _defaultValidator,
      ),
    );
  }
}

/// TextInputFormatter that applies phone number formatting based on country.
class _PhoneNumberFormatter extends TextInputFormatter {
  _PhoneNumberFormatter({required this.country});

  final PhoneCountry country;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If deleting, let the deletion happen naturally
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > country.digits) {
      // Limit digits to country max
      final trimmed = digits.substring(0, country.digits);
      final formatted = _formatPhone(trimmed, country.digits);
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    final formatted = _formatPhone(digits, country.digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Bottom sheet country picker for phone countries.
class _CountryPickerSheet extends StatelessWidget {
  const _CountryPickerSheet({
    required this.countries,
    required this.selected,
  });

  final List<PhoneCountry> countries;
  final PhoneCountry selected;

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
                    child: Text(
                      'Choisir un pays',
                      style: AppTextStyles.headlineSm,
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Fermer',
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.close,
                        color: AppColors.onSurfaceVariant,
                        size: 22,
                      ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryLight
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          ExcludeSemantics(
                            child: Text(
                              country.flag,
                              style: TextStyle(fontSize: 24.sp),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  country.name,
                                  style: AppTextStyles.labelLg.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  country.dialCode,
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Semantics(
                              label: 'Sélectionné',
                              child: Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 22,
                              ),
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
