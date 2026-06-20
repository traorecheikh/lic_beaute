import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widgets/app_dropdown.dart';

/// Country data for Djamo payment method.
class DjamoCountry {
  const DjamoCountry({
    required this.code,
    required this.name,
    required this.flag,
  });

  final String code;
  final String name;
  final String flag;
}

/// Available Djamo countries.
const List<DjamoCountry> djamoCountries = [
  DjamoCountry(code: 'SN', name: 'Sénégal', flag: '🇸🇳'),
  DjamoCountry(code: 'CI', name: "Côte d'Ivoire", flag: '🇨🇮'),
];

/// Dropdown for selecting the Djamo country.
class DjamoCountrySelector extends StatelessWidget {
  const DjamoCountrySelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Pays du compte Djamo',
      child: AppDropdown<String>(
        label: 'Pays du compte Djamo',
        value: value,
        items: djamoCountries.map((c) => c.code).toList(),
        itemLabel: (code) {
          final country = djamoCountries.firstWhere((c) => c.code == code);
          return '${country.flag} ${country.name}';
        },
        itemLeading: (code) {
          final country = djamoCountries.firstWhere((c) => c.code == code);
          return ExcludeSemantics(
            child: Text(country.flag, style: TextStyle(fontSize: 20.sp)),
          );
        },
        onChanged: onChanged,
      ),
    );
  }
}
