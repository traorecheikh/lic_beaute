// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_subscription.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProSubscriptionTierEnum _$proSubscriptionTierEnum_standard =
    const ProSubscriptionTierEnum._('standard');
const ProSubscriptionTierEnum _$proSubscriptionTierEnum_premium =
    const ProSubscriptionTierEnum._('premium');

ProSubscriptionTierEnum _$proSubscriptionTierEnumValueOf(String name) {
  switch (name) {
    case 'standard':
      return _$proSubscriptionTierEnum_standard;
    case 'premium':
      return _$proSubscriptionTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProSubscriptionTierEnum> _$proSubscriptionTierEnumValues =
    BuiltSet<ProSubscriptionTierEnum>(const <ProSubscriptionTierEnum>[
  _$proSubscriptionTierEnum_standard,
  _$proSubscriptionTierEnum_premium,
]);

const ProSubscriptionPendingTierEnum _$proSubscriptionPendingTierEnum_standard =
    const ProSubscriptionPendingTierEnum._('standard');
const ProSubscriptionPendingTierEnum _$proSubscriptionPendingTierEnum_premium =
    const ProSubscriptionPendingTierEnum._('premium');

ProSubscriptionPendingTierEnum _$proSubscriptionPendingTierEnumValueOf(
    String name) {
  switch (name) {
    case 'standard':
      return _$proSubscriptionPendingTierEnum_standard;
    case 'premium':
      return _$proSubscriptionPendingTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProSubscriptionPendingTierEnum>
    _$proSubscriptionPendingTierEnumValues = BuiltSet<
        ProSubscriptionPendingTierEnum>(const <ProSubscriptionPendingTierEnum>[
  _$proSubscriptionPendingTierEnum_standard,
  _$proSubscriptionPendingTierEnum_premium,
]);

const ProSubscriptionStatusEnum _$proSubscriptionStatusEnum_inactive =
    const ProSubscriptionStatusEnum._('inactive');
const ProSubscriptionStatusEnum _$proSubscriptionStatusEnum_active =
    const ProSubscriptionStatusEnum._('active');
const ProSubscriptionStatusEnum _$proSubscriptionStatusEnum_pastDue =
    const ProSubscriptionStatusEnum._('pastDue');
const ProSubscriptionStatusEnum _$proSubscriptionStatusEnum_cancelled =
    const ProSubscriptionStatusEnum._('cancelled');
const ProSubscriptionStatusEnum _$proSubscriptionStatusEnum_expired =
    const ProSubscriptionStatusEnum._('expired');
const ProSubscriptionStatusEnum _$proSubscriptionStatusEnum_paused =
    const ProSubscriptionStatusEnum._('paused');

ProSubscriptionStatusEnum _$proSubscriptionStatusEnumValueOf(String name) {
  switch (name) {
    case 'inactive':
      return _$proSubscriptionStatusEnum_inactive;
    case 'active':
      return _$proSubscriptionStatusEnum_active;
    case 'pastDue':
      return _$proSubscriptionStatusEnum_pastDue;
    case 'cancelled':
      return _$proSubscriptionStatusEnum_cancelled;
    case 'expired':
      return _$proSubscriptionStatusEnum_expired;
    case 'paused':
      return _$proSubscriptionStatusEnum_paused;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProSubscriptionStatusEnum> _$proSubscriptionStatusEnumValues =
    BuiltSet<ProSubscriptionStatusEnum>(const <ProSubscriptionStatusEnum>[
  _$proSubscriptionStatusEnum_inactive,
  _$proSubscriptionStatusEnum_active,
  _$proSubscriptionStatusEnum_pastDue,
  _$proSubscriptionStatusEnum_cancelled,
  _$proSubscriptionStatusEnum_expired,
  _$proSubscriptionStatusEnum_paused,
]);

Serializer<ProSubscriptionTierEnum> _$proSubscriptionTierEnumSerializer =
    _$ProSubscriptionTierEnumSerializer();
Serializer<ProSubscriptionPendingTierEnum>
    _$proSubscriptionPendingTierEnumSerializer =
    _$ProSubscriptionPendingTierEnumSerializer();
Serializer<ProSubscriptionStatusEnum> _$proSubscriptionStatusEnumSerializer =
    _$ProSubscriptionStatusEnumSerializer();

class _$ProSubscriptionTierEnumSerializer
    implements PrimitiveSerializer<ProSubscriptionTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'standard': 'standard',
    'premium': 'premium',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'standard': 'standard',
    'premium': 'premium',
  };

  @override
  final Iterable<Type> types = const <Type>[ProSubscriptionTierEnum];
  @override
  final String wireName = 'ProSubscriptionTierEnum';

  @override
  Object serialize(Serializers serializers, ProSubscriptionTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProSubscriptionTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProSubscriptionTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProSubscriptionPendingTierEnumSerializer
    implements PrimitiveSerializer<ProSubscriptionPendingTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'standard': 'standard',
    'premium': 'premium',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'standard': 'standard',
    'premium': 'premium',
  };

  @override
  final Iterable<Type> types = const <Type>[ProSubscriptionPendingTierEnum];
  @override
  final String wireName = 'ProSubscriptionPendingTierEnum';

  @override
  Object serialize(
          Serializers serializers, ProSubscriptionPendingTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProSubscriptionPendingTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProSubscriptionPendingTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProSubscriptionStatusEnumSerializer
    implements PrimitiveSerializer<ProSubscriptionStatusEnum> {
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
  final Iterable<Type> types = const <Type>[ProSubscriptionStatusEnum];
  @override
  final String wireName = 'ProSubscriptionStatusEnum';

  @override
  Object serialize(Serializers serializers, ProSubscriptionStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProSubscriptionStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProSubscriptionStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProSubscription extends ProSubscription {
  @override
  final String id;
  @override
  final ProSubscriptionTierEnum tier;
  @override
  final ProSubscriptionPendingTierEnum? pendingTier;
  @override
  final ProSubscriptionStatusEnum status;
  @override
  final DateTime? renewsAt;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? gracePeriodEndsAt;
  @override
  final bool isComplimentary;
  @override
  final bool autoRenew;
  @override
  final ProSubscriptionBillingMethod? billingMethod;

  factory _$ProSubscription([void Function(ProSubscriptionBuilder)? updates]) =>
      (ProSubscriptionBuilder()..update(updates))._build();

  _$ProSubscription._(
      {required this.id,
      required this.tier,
      this.pendingTier,
      required this.status,
      this.renewsAt,
      this.expiresAt,
      this.gracePeriodEndsAt,
      required this.isComplimentary,
      required this.autoRenew,
      this.billingMethod})
      : super._();
  @override
  ProSubscription rebuild(void Function(ProSubscriptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSubscriptionBuilder toBuilder() => ProSubscriptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSubscription &&
        id == other.id &&
        tier == other.tier &&
        pendingTier == other.pendingTier &&
        status == other.status &&
        renewsAt == other.renewsAt &&
        expiresAt == other.expiresAt &&
        gracePeriodEndsAt == other.gracePeriodEndsAt &&
        isComplimentary == other.isComplimentary &&
        autoRenew == other.autoRenew &&
        billingMethod == other.billingMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, pendingTier.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, renewsAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, gracePeriodEndsAt.hashCode);
    _$hash = $jc(_$hash, isComplimentary.hashCode);
    _$hash = $jc(_$hash, autoRenew.hashCode);
    _$hash = $jc(_$hash, billingMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSubscription')
          ..add('id', id)
          ..add('tier', tier)
          ..add('pendingTier', pendingTier)
          ..add('status', status)
          ..add('renewsAt', renewsAt)
          ..add('expiresAt', expiresAt)
          ..add('gracePeriodEndsAt', gracePeriodEndsAt)
          ..add('isComplimentary', isComplimentary)
          ..add('autoRenew', autoRenew)
          ..add('billingMethod', billingMethod))
        .toString();
  }
}

class ProSubscriptionBuilder
    implements Builder<ProSubscription, ProSubscriptionBuilder> {
  _$ProSubscription? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ProSubscriptionTierEnum? _tier;
  ProSubscriptionTierEnum? get tier => _$this._tier;
  set tier(ProSubscriptionTierEnum? tier) => _$this._tier = tier;

  ProSubscriptionPendingTierEnum? _pendingTier;
  ProSubscriptionPendingTierEnum? get pendingTier => _$this._pendingTier;
  set pendingTier(ProSubscriptionPendingTierEnum? pendingTier) =>
      _$this._pendingTier = pendingTier;

  ProSubscriptionStatusEnum? _status;
  ProSubscriptionStatusEnum? get status => _$this._status;
  set status(ProSubscriptionStatusEnum? status) => _$this._status = status;

  DateTime? _renewsAt;
  DateTime? get renewsAt => _$this._renewsAt;
  set renewsAt(DateTime? renewsAt) => _$this._renewsAt = renewsAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _gracePeriodEndsAt;
  DateTime? get gracePeriodEndsAt => _$this._gracePeriodEndsAt;
  set gracePeriodEndsAt(DateTime? gracePeriodEndsAt) =>
      _$this._gracePeriodEndsAt = gracePeriodEndsAt;

  bool? _isComplimentary;
  bool? get isComplimentary => _$this._isComplimentary;
  set isComplimentary(bool? isComplimentary) =>
      _$this._isComplimentary = isComplimentary;

  bool? _autoRenew;
  bool? get autoRenew => _$this._autoRenew;
  set autoRenew(bool? autoRenew) => _$this._autoRenew = autoRenew;

  ProSubscriptionBillingMethodBuilder? _billingMethod;
  ProSubscriptionBillingMethodBuilder get billingMethod =>
      _$this._billingMethod ??= ProSubscriptionBillingMethodBuilder();
  set billingMethod(ProSubscriptionBillingMethodBuilder? billingMethod) =>
      _$this._billingMethod = billingMethod;

  ProSubscriptionBuilder() {
    ProSubscription._defaults(this);
  }

  ProSubscriptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _tier = $v.tier;
      _pendingTier = $v.pendingTier;
      _status = $v.status;
      _renewsAt = $v.renewsAt;
      _expiresAt = $v.expiresAt;
      _gracePeriodEndsAt = $v.gracePeriodEndsAt;
      _isComplimentary = $v.isComplimentary;
      _autoRenew = $v.autoRenew;
      _billingMethod = $v.billingMethod?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSubscription other) {
    _$v = other as _$ProSubscription;
  }

  @override
  void update(void Function(ProSubscriptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSubscription build() => _build();

  _$ProSubscription _build() {
    _$ProSubscription _$result;
    try {
      _$result = _$v ??
          _$ProSubscription._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProSubscription', 'id'),
            tier: BuiltValueNullFieldError.checkNotNull(
                tier, r'ProSubscription', 'tier'),
            pendingTier: pendingTier,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProSubscription', 'status'),
            renewsAt: renewsAt,
            expiresAt: expiresAt,
            gracePeriodEndsAt: gracePeriodEndsAt,
            isComplimentary: BuiltValueNullFieldError.checkNotNull(
                isComplimentary, r'ProSubscription', 'isComplimentary'),
            autoRenew: BuiltValueNullFieldError.checkNotNull(
                autoRenew, r'ProSubscription', 'autoRenew'),
            billingMethod: _billingMethod?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'billingMethod';
        _billingMethod?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProSubscription', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
