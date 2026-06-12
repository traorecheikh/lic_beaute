import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_contacts.dart';
import '../session/session_store.dart';

class SupportConfig {
  final String phone;
  final String email;

  const SupportConfig({required this.phone, required this.email});

  String get telUri => 'tel:$phone';
  String get emailUri => 'mailto:$email';
  String get whatsApp => 'https://wa.me/${phone.replaceAll(RegExp(r'[^+\d]'), '')}';
}

final supportConfigProvider = FutureProvider<SupportConfig>((ref) async {
  try {
    final dio = ref.read(dioProvider);
    final response = await dio.get<Map<String, dynamic>>(
      '/api/v1/config/support',
    );
    final data = response.data;
    if (data != null && data['phone'] != null && data['email'] != null) {
      return SupportConfig(
        phone: data['phone'] as String,
        email: data['email'] as String,
      );
    }
  } catch (_) {
    // Fallback to hardcoded values
  }
  return SupportConfig(
    phone: AppContacts.supportPhone,
    email: AppContacts.supportEmail,
  );
});
