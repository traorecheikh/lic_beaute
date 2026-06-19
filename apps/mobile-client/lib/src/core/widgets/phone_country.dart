/// Model for a phone country with dial code and digit count.
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

/// Default countries list. Can be overridden via the countries parameter.
const kPhoneCountries = [
  PhoneCountry(code: 'SN', name: 'Sénégal', dialCode: '+221', flag: '🇸🇳', digits: 9),
  PhoneCountry(code: 'CI', name: "Côte d'Ivoire", dialCode: '+225', flag: '🇨🇮', digits: 10),
  PhoneCountry(code: 'ML', name: 'Mali', dialCode: '+223', flag: '🇲🇱', digits: 8),
  PhoneCountry(code: 'FR', name: 'France', dialCode: '+33', flag: '🇫🇷', digits: 9),
];
