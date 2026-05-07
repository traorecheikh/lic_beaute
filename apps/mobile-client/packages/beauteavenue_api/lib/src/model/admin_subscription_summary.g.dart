// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSubscriptionSummaryTierEnum
    _$adminSubscriptionSummaryTierEnum_standard =
    const AdminSubscriptionSummaryTierEnum._('standard');
const AdminSubscriptionSummaryTierEnum
    _$adminSubscriptionSummaryTierEnum_premium =
    const AdminSubscriptionSummaryTierEnum._('premium');

AdminSubscriptionSummaryTierEnum _$adminSubscriptionSummaryTierEnumValueOf(
    String name) {
  switch (name) {
    case 'standard':
      return _$adminSubscriptionSummaryTierEnum_standard;
    case 'premium':
      return _$adminSubscriptionSummaryTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionSummaryTierEnum>
    _$adminSubscriptionSummaryTierEnumValues = BuiltSet<
        AdminSubscriptionSummaryTierEnum>(const <AdminSubscriptionSummaryTierEnum>[
  _$adminSubscriptionSummaryTierEnum_standard,
  _$adminSubscriptionSummaryTierEnum_premium,
]);

const AdminSubscriptionSummaryStatusEnum
    _$adminSubscriptionSummaryStatusEnum_inactive =
    const AdminSubscriptionSummaryStatusEnum._('inactive');
const AdminSubscriptionSummaryStatusEnum
    _$adminSubscriptionSummaryStatusEnum_active =
    const AdminSubscriptionSummaryStatusEnum._('active');
const AdminSubscriptionSummaryStatusEnum
    _$adminSubscriptionSummaryStatusEnum_pastDue =
    const AdminSubscriptionSummaryStatusEnum._('pastDue');
const AdminSubscriptionSummaryStatusEnum
    _$adminSubscriptionSummaryStatusEnum_cancelled =
    const AdminSubscriptionSummaryStatusEnum._('cancelled');
const AdminSubscriptionSummaryStatusEnum
    _$adminSubscriptionSummaryStatusEnum_expired =
    const AdminSubscriptionSummaryStatusEnum._('expired');
const AdminSubscriptionSummaryStatusEnum
    _$adminSubscriptionSummaryStatusEnum_paused =
    const AdminSubscriptionSummaryStatusEnum._('paused');

AdminSubscriptionSummaryStatusEnum _$adminSubscriptionSummaryStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'inactive':
      return _$adminSubscriptionSummaryStatusEnum_inactive;
    case 'active':
      return _$adminSubscriptionSummaryStatusEnum_active;
    case 'pastDue':
      return _$adminSubscriptionSummaryStatusEnum_pastDue;
    case 'cancelled':
      return _$adminSubscriptionSummaryStatusEnum_cancelled;
    case 'expired':
      return _$adminSubscriptionSummaryStatusEnum_expired;
    case 'paused':
      return _$adminSubscriptionSummaryStatusEnum_paused;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionSummaryStatusEnum>
    _$adminSubscriptionSummaryStatusEnumValues = BuiltSet<
        AdminSubscriptionSummaryStatusEnum>(const <AdminSubscriptionSummaryStatusEnum>[
  _$adminSubscriptionSummaryStatusEnum_inactive,
  _$adminSubscriptionSummaryStatusEnum_active,
  _$adminSubscriptionSummaryStatusEnum_pastDue,
  _$adminSubscriptionSummaryStatusEnum_cancelled,
  _$adminSubscriptionSummaryStatusEnum_expired,
  _$adminSubscriptionSummaryStatusEnum_paused,
]);

const AdminSubscriptionSummaryBillingProviderEnum
    _$adminSubscriptionSummaryBillingProviderEnum_intech =
    const AdminSubscriptionSummaryBillingProviderEnum._('intech');
const AdminSubscriptionSummaryBillingProviderEnum
    _$adminSubscriptionSummaryBillingProviderEnum_manual =
    const AdminSubscriptionSummaryBillingProviderEnum._('manual');

AdminSubscriptionSummaryBillingProviderEnum
    _$adminSubscriptionSummaryBillingProviderEnumValueOf(String name) {
  switch (name) {
    case 'intech':
      return _$adminSubscriptionSummaryBillingProviderEnum_intech;
    case 'manual':
      return _$adminSubscriptionSummaryBillingProviderEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionSummaryBillingProviderEnum>
    _$adminSubscriptionSummaryBillingProviderEnumValues = BuiltSet<
        AdminSubscriptionSummaryBillingProviderEnum>(const <AdminSubscriptionSummaryBillingProviderEnum>[
  _$adminSubscriptionSummaryBillingProviderEnum_intech,
  _$adminSubscriptionSummaryBillingProviderEnum_manual,
]);

Serializer<AdminSubscriptionSummaryTierEnum>
    _$adminSubscriptionSummaryTierEnumSerializer =
    _$AdminSubscriptionSummaryTierEnumSerializer();
Serializer<AdminSubscriptionSummaryStatusEnum>
    _$adminSubscriptionSummaryStatusEnumSerializer =
    _$AdminSubscriptionSummaryStatusEnumSerializer();
Serializer<AdminSubscriptionSummaryBillingProviderEnum>
    _$adminSubscriptionSummaryBillingProviderEnumSerializer =
    _$AdminSubscriptionSummaryBillingProviderEnumSerializer();

class _$AdminSubscriptionSummaryTierEnumSerializer
    implements PrimitiveSerializer<AdminSubscriptionSummaryTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'standard': 'standard',
    'premium': 'premium',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'standard': 'standard',
    'premium': 'premium',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminSubscriptionSummaryTierEnum];
  @override
  final String wireName = 'AdminSubscriptionSummaryTierEnum';

  @override
  Object serialize(
          Serializers serializers, AdminSubscriptionSummaryTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionSummaryTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionSummaryTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionSummaryStatusEnumSerializer
    implements PrimitiveSerializer<AdminSubscriptionSummaryStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'inactive': 'inactive',
    'active': 'active',
    'pastDue': 'past_due',
    'cancelled': 'cancelled',
    'expired': 'expired',
    'paused': 'paused',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'inactive': 'inactive',
    'active': 'active',
    'past_due': 'pastDue',
    'cancelled': 'cancelled',
    'expired': 'expired',
    'paused': 'paused',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminSubscriptionSummaryStatusEnum];
  @override
  final String wireName = 'AdminSubscriptionSummaryStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminSubscriptionSummaryStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionSummaryStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionSummaryStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionSummaryBillingProviderEnumSerializer
    implements
        PrimitiveSerializer<AdminSubscriptionSummaryBillingProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionSummaryBillingProviderEnum
  ];
  @override
  final String wireName = 'AdminSubscriptionSummaryBillingProviderEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionSummaryBillingProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionSummaryBillingProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionSummaryBillingProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionSummary extends AdminSubscriptionSummary {
  @override
  final String id;
  @override
  final String salonId;
  @override
  final String salonName;
  @override
  final AdminSubscriptionSummaryTierEnum tier;
  @override
  final AdminSubscriptionSummaryStatusEnum status;
  @override
  final AdminSubscriptionSummaryBillingProviderEnum? billingProvider;
  @override
  final DateTime? expiresAt;
  @override
  final bool autoRenew;
  @override
  final bool isComplimentary;

  factory _$AdminSubscriptionSummary(
          [void Function(AdminSubscriptionSummaryBuilder)? updates]) =>
      (AdminSubscriptionSummaryBuilder()..update(updates))._build();

  _$AdminSubscriptionSummary._(
      {required this.id,
      required this.salonId,
      required this.salonName,
      required this.tier,
      required this.status,
      this.billingProvider,
      this.expiresAt,
      required this.autoRenew,
      required this.isComplimentary})
      : super._();
  @override
  AdminSubscriptionSummary rebuild(
          void Function(AdminSubscriptionSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionSummaryBuilder toBuilder() =>
      AdminSubscriptionSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionSummary &&
        id == other.id &&
        salonId == other.salonId &&
        salonName == other.salonName &&
        tier == other.tier &&
        status == other.status &&
        billingProvider == other.billingProvider &&
        expiresAt == other.expiresAt &&
        autoRenew == other.autoRenew &&
        isComplimentary == other.isComplimentary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, salonName.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, billingProvider.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, autoRenew.hashCode);
    _$hash = $jc(_$hash, isComplimentary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSubscriptionSummary')
          ..add('id', id)
          ..add('salonId', salonId)
          ..add('salonName', salonName)
          ..add('tier', tier)
          ..add('status', status)
          ..add('billingProvider', billingProvider)
          ..add('expiresAt', expiresAt)
          ..add('autoRenew', autoRenew)
          ..add('isComplimentary', isComplimentary))
        .toString();
  }
}

class AdminSubscriptionSummaryBuilder
    implements
        Builder<AdminSubscriptionSummary, AdminSubscriptionSummaryBuilder> {
  _$AdminSubscriptionSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  AdminSubscriptionSummaryTierEnum? _tier;
  AdminSubscriptionSummaryTierEnum? get tier => _$this._tier;
  set tier(AdminSubscriptionSummaryTierEnum? tier) => _$this._tier = tier;

  AdminSubscriptionSummaryStatusEnum? _status;
  AdminSubscriptionSummaryStatusEnum? get status => _$this._status;
  set status(AdminSubscriptionSummaryStatusEnum? status) =>
      _$this._status = status;

  AdminSubscriptionSummaryBillingProviderEnum? _billingProvider;
  AdminSubscriptionSummaryBillingProviderEnum? get billingProvider =>
      _$this._billingProvider;
  set billingProvider(
          AdminSubscriptionSummaryBillingProviderEnum? billingProvider) =>
      _$this._billingProvider = billingProvider;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  bool? _autoRenew;
  bool? get autoRenew => _$this._autoRenew;
  set autoRenew(bool? autoRenew) => _$this._autoRenew = autoRenew;

  bool? _isComplimentary;
  bool? get isComplimentary => _$this._isComplimentary;
  set isComplimentary(bool? isComplimentary) =>
      _$this._isComplimentary = isComplimentary;

  AdminSubscriptionSummaryBuilder() {
    AdminSubscriptionSummary._defaults(this);
  }

  AdminSubscriptionSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _salonId = $v.salonId;
      _salonName = $v.salonName;
      _tier = $v.tier;
      _status = $v.status;
      _billingProvider = $v.billingProvider;
      _expiresAt = $v.expiresAt;
      _autoRenew = $v.autoRenew;
      _isComplimentary = $v.isComplimentary;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionSummary other) {
    _$v = other as _$AdminSubscriptionSummary;
  }

  @override
  void update(void Function(AdminSubscriptionSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionSummary build() => _build();

  _$AdminSubscriptionSummary _build() {
    final _$result = _$v ??
        _$AdminSubscriptionSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminSubscriptionSummary', 'id'),
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'AdminSubscriptionSummary', 'salonId'),
          salonName: BuiltValueNullFieldError.checkNotNull(
              salonName, r'AdminSubscriptionSummary', 'salonName'),
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'AdminSubscriptionSummary', 'tier'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminSubscriptionSummary', 'status'),
          billingProvider: billingProvider,
          expiresAt: expiresAt,
          autoRenew: BuiltValueNullFieldError.checkNotNull(
              autoRenew, r'AdminSubscriptionSummary', 'autoRenew'),
          isComplimentary: BuiltValueNullFieldError.checkNotNull(
              isComplimentary, r'AdminSubscriptionSummary', 'isComplimentary'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
