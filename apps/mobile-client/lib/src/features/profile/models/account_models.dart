import 'package:flutter/foundation.dart';

@immutable
class ClientAccountProfile {
  const ClientAccountProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.city,
    required this.avatarUrl,
    required this.preferredContactChannel,
    required this.pushOptIn,
    required this.marketingOptIn,
    required this.preferredLanguage,
    required this.pendingSync,
  });

  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? city;
  final String? avatarUrl;
  final String preferredContactChannel;
  final bool pushOptIn;
  final bool marketingOptIn;
  final String preferredLanguage;
  final bool pendingSync;

  factory ClientAccountProfile.fromJson(
    Map<String, dynamic> json, {
    bool pendingSync = false,
  }) {
    return ClientAccountProfile(
      id: json['id'] as String,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      preferredContactChannel:
          json['preferredContactChannel'] as String? ?? 'phone',
      pushOptIn: json['pushOptIn'] as bool? ?? true,
      marketingOptIn: json['marketingOptIn'] as bool? ?? false,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'fr',
      pendingSync: pendingSync,
    );
  }

  ClientAccountProfile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? city,
    String? avatarUrl,
    String? preferredContactChannel,
    bool? pushOptIn,
    bool? marketingOptIn,
    String? preferredLanguage,
    bool? pendingSync,
  }) {
    return ClientAccountProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredContactChannel:
          preferredContactChannel ?? this.preferredContactChannel,
      pushOptIn: pushOptIn ?? this.pushOptIn,
      marketingOptIn: marketingOptIn ?? this.marketingOptIn,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'city': city,
      'avatarUrl': avatarUrl,
      'preferredContactChannel': preferredContactChannel,
      'pushOptIn': pushOptIn,
      'marketingOptIn': marketingOptIn,
      'preferredLanguage': preferredLanguage,
    };
  }
}

@immutable
class ProfileOptions {
  const ProfileOptions({
    required this.cities,
    required this.languages,
    required this.contactChannels,
    required this.paymentProviders,
  });

  final List<String> cities;
  final List<String> languages;
  final List<String> contactChannels;
  final List<String> paymentProviders;

  factory ProfileOptions.fromJson(Map<String, dynamic> json) {
    List<String> stringsFor(String key) =>
        ((json[key] as List<dynamic>?) ?? const [])
            .map((value) => value.toString())
            .toList(growable: false);
    return ProfileOptions(
      cities: stringsFor('cities'),
      languages: stringsFor('languages'),
      contactChannels: stringsFor('contactChannels'),
      paymentProviders: stringsFor('paymentProviders'),
    );
  }
}

@immutable
class PaymentMethodRecord {
  const PaymentMethodRecord({
    required this.id,
    required this.provider,
    required this.phoneNumber,
    required this.label,
    required this.isDefault,
    required this.lastUsedAt,
    required this.pendingSync,
  });

  final String id;
  final String provider;
  final String phoneNumber;
  final String? label;
  final bool isDefault;
  final DateTime? lastUsedAt;
  final bool pendingSync;

  factory PaymentMethodRecord.fromJson(
    Map<String, dynamic> json, {
    bool pendingSync = false,
  }) {
    return PaymentMethodRecord(
      id: json['id'] as String,
      provider: json['provider'] as String? ?? 'wave',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      label: json['label'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      lastUsedAt: DateTime.tryParse(json['lastUsedAt'] as String? ?? ''),
      pendingSync: pendingSync,
    );
  }

  PaymentMethodRecord copyWith({
    String? provider,
    String? phoneNumber,
    String? label,
    bool? isDefault,
    DateTime? lastUsedAt,
    bool? pendingSync,
  }) {
    return PaymentMethodRecord(
      id: id,
      provider: provider ?? this.provider,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      label: label ?? this.label,
      isDefault: isDefault ?? this.isDefault,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider,
      'phoneNumber': phoneNumber,
      'label': label,
      'isDefault': isDefault,
      'lastUsedAt': lastUsedAt?.toIso8601String(),
    };
  }
}

@immutable
class BenefitRecord {
  const BenefitRecord({
    required this.id,
    required this.kind,
    required this.name,
    required this.status,
    required this.remainingUses,
    required this.expiresAt,
    required this.billingDate,
    required this.salonId,
    required this.salonName,
    required this.createdAt,
  });

  final String id;
  final String kind;
  final String name;
  final String status;
  final int? remainingUses;
  final DateTime? expiresAt;
  final DateTime? billingDate;
  final String salonId;
  final String salonName;
  final DateTime createdAt;

  factory BenefitRecord.fromJson(Map<String, dynamic> json) {
    return BenefitRecord(
      id: json['id'] as String,
      kind: json['kind'] as String? ?? 'membership',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      remainingUses: json['remainingUses'] as int?,
      expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? ''),
      billingDate: DateTime.tryParse(json['billingDate'] as String? ?? ''),
      salonId: json['salonId'] as String? ?? '',
      salonName: json['salonName'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

@immutable
class VoucherRecord {
  const VoucherRecord({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountLabel,
    required this.status,
    required this.expiresAt,
    required this.redeemedAt,
    required this.usedAt,
    required this.salonId,
    required this.salonName,
  });

  final String id;
  final String code;
  final String title;
  final String? description;
  final String discountLabel;
  final String status;
  final DateTime? expiresAt;
  final DateTime redeemedAt;
  final DateTime? usedAt;
  final String? salonId;
  final String? salonName;

  factory VoucherRecord.fromJson(Map<String, dynamic> json) {
    return VoucherRecord(
      id: json['id'] as String,
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      discountLabel: json['discountLabel'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? ''),
      redeemedAt:
          DateTime.tryParse(json['redeemedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      usedAt: DateTime.tryParse(json['usedAt'] as String? ?? ''),
      salonId: json['salonId'] as String?,
      salonName: json['salonName'] as String?,
    );
  }
}
