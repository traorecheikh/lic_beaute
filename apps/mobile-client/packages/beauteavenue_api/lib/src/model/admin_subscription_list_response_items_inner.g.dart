// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_list_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSubscriptionListResponseItemsInnerTierEnum
    _$adminSubscriptionListResponseItemsInnerTierEnum_standard =
    const AdminSubscriptionListResponseItemsInnerTierEnum._('standard');
const AdminSubscriptionListResponseItemsInnerTierEnum
    _$adminSubscriptionListResponseItemsInnerTierEnum_premium =
    const AdminSubscriptionListResponseItemsInnerTierEnum._('premium');

AdminSubscriptionListResponseItemsInnerTierEnum
    _$adminSubscriptionListResponseItemsInnerTierEnumValueOf(String name) {
  switch (name) {
    case 'standard':
      return _$adminSubscriptionListResponseItemsInnerTierEnum_standard;
    case 'premium':
      return _$adminSubscriptionListResponseItemsInnerTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionListResponseItemsInnerTierEnum>
    _$adminSubscriptionListResponseItemsInnerTierEnumValues = BuiltSet<
        AdminSubscriptionListResponseItemsInnerTierEnum>(const <AdminSubscriptionListResponseItemsInnerTierEnum>[
  _$adminSubscriptionListResponseItemsInnerTierEnum_standard,
  _$adminSubscriptionListResponseItemsInnerTierEnum_premium,
]);

const AdminSubscriptionListResponseItemsInnerStatusEnum
    _$adminSubscriptionListResponseItemsInnerStatusEnum_inactive =
    const AdminSubscriptionListResponseItemsInnerStatusEnum._('inactive');
const AdminSubscriptionListResponseItemsInnerStatusEnum
    _$adminSubscriptionListResponseItemsInnerStatusEnum_active =
    const AdminSubscriptionListResponseItemsInnerStatusEnum._('active');
const AdminSubscriptionListResponseItemsInnerStatusEnum
    _$adminSubscriptionListResponseItemsInnerStatusEnum_pastDue =
    const AdminSubscriptionListResponseItemsInnerStatusEnum._('pastDue');
const AdminSubscriptionListResponseItemsInnerStatusEnum
    _$adminSubscriptionListResponseItemsInnerStatusEnum_cancelled =
    const AdminSubscriptionListResponseItemsInnerStatusEnum._('cancelled');
const AdminSubscriptionListResponseItemsInnerStatusEnum
    _$adminSubscriptionListResponseItemsInnerStatusEnum_expired =
    const AdminSubscriptionListResponseItemsInnerStatusEnum._('expired');
const AdminSubscriptionListResponseItemsInnerStatusEnum
    _$adminSubscriptionListResponseItemsInnerStatusEnum_paused =
    const AdminSubscriptionListResponseItemsInnerStatusEnum._('paused');

AdminSubscriptionListResponseItemsInnerStatusEnum
    _$adminSubscriptionListResponseItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'inactive':
      return _$adminSubscriptionListResponseItemsInnerStatusEnum_inactive;
    case 'active':
      return _$adminSubscriptionListResponseItemsInnerStatusEnum_active;
    case 'pastDue':
      return _$adminSubscriptionListResponseItemsInnerStatusEnum_pastDue;
    case 'cancelled':
      return _$adminSubscriptionListResponseItemsInnerStatusEnum_cancelled;
    case 'expired':
      return _$adminSubscriptionListResponseItemsInnerStatusEnum_expired;
    case 'paused':
      return _$adminSubscriptionListResponseItemsInnerStatusEnum_paused;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionListResponseItemsInnerStatusEnum>
    _$adminSubscriptionListResponseItemsInnerStatusEnumValues = BuiltSet<
        AdminSubscriptionListResponseItemsInnerStatusEnum>(const <AdminSubscriptionListResponseItemsInnerStatusEnum>[
  _$adminSubscriptionListResponseItemsInnerStatusEnum_inactive,
  _$adminSubscriptionListResponseItemsInnerStatusEnum_active,
  _$adminSubscriptionListResponseItemsInnerStatusEnum_pastDue,
  _$adminSubscriptionListResponseItemsInnerStatusEnum_cancelled,
  _$adminSubscriptionListResponseItemsInnerStatusEnum_expired,
  _$adminSubscriptionListResponseItemsInnerStatusEnum_paused,
]);

const AdminSubscriptionListResponseItemsInnerBillingProviderEnum
    _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_paydunya =
    const AdminSubscriptionListResponseItemsInnerBillingProviderEnum._(
        'paydunya');
const AdminSubscriptionListResponseItemsInnerBillingProviderEnum
    _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_intech =
    const AdminSubscriptionListResponseItemsInnerBillingProviderEnum._(
        'intech');
const AdminSubscriptionListResponseItemsInnerBillingProviderEnum
    _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_manual =
    const AdminSubscriptionListResponseItemsInnerBillingProviderEnum._(
        'manual');

AdminSubscriptionListResponseItemsInnerBillingProviderEnum
    _$adminSubscriptionListResponseItemsInnerBillingProviderEnumValueOf(
        String name) {
  switch (name) {
    case 'paydunya':
      return _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_paydunya;
    case 'intech':
      return _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_intech;
    case 'manual':
      return _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionListResponseItemsInnerBillingProviderEnum>
    _$adminSubscriptionListResponseItemsInnerBillingProviderEnumValues =
    BuiltSet<
        AdminSubscriptionListResponseItemsInnerBillingProviderEnum>(const <AdminSubscriptionListResponseItemsInnerBillingProviderEnum>[
  _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_paydunya,
  _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_intech,
  _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_manual,
]);

Serializer<AdminSubscriptionListResponseItemsInnerTierEnum>
    _$adminSubscriptionListResponseItemsInnerTierEnumSerializer =
    _$AdminSubscriptionListResponseItemsInnerTierEnumSerializer();
Serializer<AdminSubscriptionListResponseItemsInnerStatusEnum>
    _$adminSubscriptionListResponseItemsInnerStatusEnumSerializer =
    _$AdminSubscriptionListResponseItemsInnerStatusEnumSerializer();
Serializer<AdminSubscriptionListResponseItemsInnerBillingProviderEnum>
    _$adminSubscriptionListResponseItemsInnerBillingProviderEnumSerializer =
    _$AdminSubscriptionListResponseItemsInnerBillingProviderEnumSerializer();

class _$AdminSubscriptionListResponseItemsInnerTierEnumSerializer
    implements
        PrimitiveSerializer<AdminSubscriptionListResponseItemsInnerTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'standard': 'standard',
    'premium': 'premium',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'standard': 'standard',
    'premium': 'premium',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionListResponseItemsInnerTierEnum
  ];
  @override
  final String wireName = 'AdminSubscriptionListResponseItemsInnerTierEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionListResponseItemsInnerTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionListResponseItemsInnerTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionListResponseItemsInnerTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionListResponseItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminSubscriptionListResponseItemsInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionListResponseItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminSubscriptionListResponseItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionListResponseItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionListResponseItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionListResponseItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionListResponseItemsInnerBillingProviderEnumSerializer
    implements
        PrimitiveSerializer<
            AdminSubscriptionListResponseItemsInnerBillingProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'paydunya': 'paydunya',
    'intech': 'intech',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'paydunya': 'paydunya',
    'intech': 'intech',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionListResponseItemsInnerBillingProviderEnum
  ];
  @override
  final String wireName =
      'AdminSubscriptionListResponseItemsInnerBillingProviderEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionListResponseItemsInnerBillingProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionListResponseItemsInnerBillingProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionListResponseItemsInnerBillingProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionListResponseItemsInner
    extends AdminSubscriptionListResponseItemsInner {
  @override
  final String id;
  @override
  final String salonId;
  @override
  final String salonName;
  @override
  final AdminSubscriptionListResponseItemsInnerTierEnum tier;
  @override
  final AdminSubscriptionListResponseItemsInnerStatusEnum status;
  @override
  final AdminSubscriptionListResponseItemsInnerBillingProviderEnum?
      billingProvider;
  @override
  final DateTime? expiresAt;
  @override
  final bool autoRenew;
  @override
  final bool isComplimentary;

  factory _$AdminSubscriptionListResponseItemsInner(
          [void Function(AdminSubscriptionListResponseItemsInnerBuilder)?
              updates]) =>
      (AdminSubscriptionListResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminSubscriptionListResponseItemsInner._(
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
  AdminSubscriptionListResponseItemsInner rebuild(
          void Function(AdminSubscriptionListResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionListResponseItemsInnerBuilder toBuilder() =>
      AdminSubscriptionListResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionListResponseItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminSubscriptionListResponseItemsInner')
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

class AdminSubscriptionListResponseItemsInnerBuilder
    implements
        Builder<AdminSubscriptionListResponseItemsInner,
            AdminSubscriptionListResponseItemsInnerBuilder> {
  _$AdminSubscriptionListResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  AdminSubscriptionListResponseItemsInnerTierEnum? _tier;
  AdminSubscriptionListResponseItemsInnerTierEnum? get tier => _$this._tier;
  set tier(AdminSubscriptionListResponseItemsInnerTierEnum? tier) =>
      _$this._tier = tier;

  AdminSubscriptionListResponseItemsInnerStatusEnum? _status;
  AdminSubscriptionListResponseItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminSubscriptionListResponseItemsInnerStatusEnum? status) =>
      _$this._status = status;

  AdminSubscriptionListResponseItemsInnerBillingProviderEnum? _billingProvider;
  AdminSubscriptionListResponseItemsInnerBillingProviderEnum?
      get billingProvider => _$this._billingProvider;
  set billingProvider(
          AdminSubscriptionListResponseItemsInnerBillingProviderEnum?
              billingProvider) =>
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

  AdminSubscriptionListResponseItemsInnerBuilder() {
    AdminSubscriptionListResponseItemsInner._defaults(this);
  }

  AdminSubscriptionListResponseItemsInnerBuilder get _$this {
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
  void replace(AdminSubscriptionListResponseItemsInner other) {
    _$v = other as _$AdminSubscriptionListResponseItemsInner;
  }

  @override
  void update(
      void Function(AdminSubscriptionListResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionListResponseItemsInner build() => _build();

  _$AdminSubscriptionListResponseItemsInner _build() {
    final _$result = _$v ??
        _$AdminSubscriptionListResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminSubscriptionListResponseItemsInner', 'id'),
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'AdminSubscriptionListResponseItemsInner', 'salonId'),
          salonName: BuiltValueNullFieldError.checkNotNull(salonName,
              r'AdminSubscriptionListResponseItemsInner', 'salonName'),
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'AdminSubscriptionListResponseItemsInner', 'tier'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminSubscriptionListResponseItemsInner', 'status'),
          billingProvider: billingProvider,
          expiresAt: expiresAt,
          autoRenew: BuiltValueNullFieldError.checkNotNull(autoRenew,
              r'AdminSubscriptionListResponseItemsInner', 'autoRenew'),
          isComplimentary: BuiltValueNullFieldError.checkNotNull(
              isComplimentary,
              r'AdminSubscriptionListResponseItemsInner',
              'isComplimentary'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
