import 'package:flutter/material.dart';

class AppCityDropdown extends StatelessWidget {
  final String? value;
  final List<String> cities;
  final ValueChanged<String?> onChanged;

  const AppCityDropdown({
    required this.value,
    required this.cities,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Ville'),
      items: cities
          .map((city) => DropdownMenuItem(value: city, child: Text(city)))
          .toList(growable: false),
      onChanged: onChanged,
    );
  }
}
