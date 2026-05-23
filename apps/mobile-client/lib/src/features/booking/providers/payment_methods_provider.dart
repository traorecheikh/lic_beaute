import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_store.dart';

class PaydunyaMethodRecord {
  final String code;
  final String country;
  final String label;
  final bool enabled;

  const PaydunyaMethodRecord({
    required this.code,
    required this.country,
    required this.label,
    required this.enabled,
  });

  factory PaydunyaMethodRecord.fromJson(Map<String, dynamic> json) {
    return PaydunyaMethodRecord(
      code: json['code'] as String,
      country: json['country'] as String? ?? '',
      label: json['label'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
    );
  }
}

final availablePaydunyaMethodsProvider =
    FutureProvider<List<PaydunyaMethodRecord>>((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '/api/v1/payments/methods',
  );
  final data = response.data;
  if (data == null) return [];
  final methods = (data['methods'] as List<dynamic>?)
          ?.map((m) =>
              PaydunyaMethodRecord.fromJson(m as Map<String, dynamic>))
          .toList() ??
      [];
  return methods;
});
