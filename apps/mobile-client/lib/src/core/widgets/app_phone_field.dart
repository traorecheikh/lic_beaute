import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'country_picker_sheet.dart';
import 'phone_country.dart';
export 'phone_country.dart';
import 'phone_number_formatter.dart';

PhoneCountry get _sn => kPhoneCountries[0];

/// A phone number input field with:
/// - Country flag + dial code prefix (tappable to open country picker)
/// - Automatic formatting based on country digits
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
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  void _onChanged() => setState(() {});

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
    CountryPickerSheet.show(context, countries: widget.countries, selected: _country)
        .then((picked) {
      if (picked != null && picked.code != _country.code) {
        setState(() => _country = picked);
        widget.onCountryChanged?.call(picked);
      }
    });
  }

  String? _defaultValidator(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < _country.digits) {
      return 'Numéro invalide (${_country.digits} chiffres attendus)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final errorTextRaw = widget.validator?.call(_controller.text) ?? _defaultValidator(_controller.text);
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
          PhoneNumberFormatter(countryDigits: _country.digits),
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
                    ExcludeSemantics(child: Text(_country.flag, style: TextStyle(fontSize: 18.sp))),
                    SizedBox(width: 4.w),
                    Semantics(
                      label: 'Indicatif ${_country.dialCode}',
                      child: Text(_country.dialCode, style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.onSurfaceVariant)),
                    ),
                    SizedBox(width: 4.w),
                    Semantics(
                      label: 'Changer de pays',
                      child: Icon(Icons.arrow_drop_down, size: 18, color: AppColors.onSurfaceVariant),
                    ),
                    gapW8,
                    Container(width: 1, height: 18.h,
                      color: _focused ? AppColors.primary : AppColors.outlineVariant),
                  ],
                ),
              ),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide(color: AppColors.outline.withValues(alpha: 0.5), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.error, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.error, width: 1.8),
          ),
        ),
        validator: widget.validator ?? _defaultValidator,
      ),
    );
  }
}
