import 'package:flutter/services.dart';

/// Formats a phone number string by grouping digits according to country.
/// Each country defines its own grouping via [countryDigits].
/// - 9 digits (Sénégal): XX XXX XX XX
/// - Others: groups of 2
String formatPhone(String raw, int countryDigits) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return digits;

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

/// TextInputFormatter that applies phone number formatting based on country.
class PhoneNumberFormatter extends TextInputFormatter {
  PhoneNumberFormatter({required this.countryDigits});

  final int countryDigits;

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
    if (digits.length > countryDigits) {
      final trimmed = digits.substring(0, countryDigits);
      final formatted = formatPhone(trimmed, countryDigits);
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    final formatted = formatPhone(digits, countryDigits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
