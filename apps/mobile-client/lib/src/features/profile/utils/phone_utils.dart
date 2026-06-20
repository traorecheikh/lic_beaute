import '../../../core/widgets/phone_country.dart';

/// Result of parsing a raw phone number string.
class PhoneSeedResult {
  const PhoneSeedResult({
    required this.country,
    required this.nationalDigits,
  });

  /// The matched country from the dial code.
  final PhoneCountry country;

  /// The phone number without the country dial code, digits only.
  final String nationalDigits;
}

/// Parses a raw phone number (e.g. "+221771234567") and returns the matched
/// country + national digits. Returns `null` if the input is empty.
///
/// Example:
/// ```dart
/// final result = seedPhone('+221771234567');
/// result.country.dialCode   // '+221'
/// result.nationalDigits     // '771234567'
/// ```
PhoneSeedResult? seedPhone(
  String? rawPhone, {
  List<PhoneCountry> countries = kPhoneCountries,
}) {
  final cleaned = (rawPhone ?? '').replaceAll(RegExp(r'\s+'), '');
  if (cleaned.isEmpty) return null;

  for (final country in countries) {
    final dialDigits = country.dialCode.replaceAll(RegExp(r'\D'), '');
    if (cleaned.startsWith(country.dialCode) ||
        cleaned.startsWith(dialDigits)) {
      final withoutDialCode = cleaned
          .replaceFirst(country.dialCode, '')
          .replaceFirst(dialDigits, '');
      return PhoneSeedResult(
        country: country,
        nationalDigits: withoutDialCode,
      );
    }
  }

  // No matching country — return first country with all-numeric national digits
  return PhoneSeedResult(
    country: countries.first,
    nationalDigits: cleaned.replaceAll(RegExp(r'\D'), ''),
  );
}

/// Builds a full E.164 phone number from national digits and a country.
///
/// Returns `null` if `nationalDigits` is empty.
///
/// Example:
/// ```dart
/// buildFullPhone('771234567', snCountry) // '+221771234567'
/// ```
String? buildFullPhone(String nationalDigits, PhoneCountry country) {
  final digits = nationalDigits.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return null;
  return '${country.dialCode}$digits';
}
