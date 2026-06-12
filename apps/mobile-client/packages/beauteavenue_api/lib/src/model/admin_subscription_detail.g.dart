// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSubscriptionDetailTierEnum
    _$adminSubscriptionDetailTierEnum_standard =
    const AdminSubscriptionDetailTierEnum._('standard');
const AdminSubscriptionDetailTierEnum
    _$adminSubscriptionDetailTierEnum_premium =
    const AdminSubscriptionDetailTierEnum._('premium');

AdminSubscriptionDetailTierEnum _$adminSubscriptionDetailTierEnumValueOf(
    String name) {
  switch (name) {
    case 'standard':
      return _$adminSubscriptionDetailTierEnum_standard;
    case 'premium':
      return _$adminSubscriptionDetailTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionDetailTierEnum>
    _$adminSubscriptionDetailTierEnumValues = BuiltSet<
        AdminSubscriptionDetailTierEnum>(const <AdminSubscriptionDetailTierEnum>[
  _$adminSubscriptionDetailTierEnum_standard,
  _$adminSubscriptionDetailTierEnum_premium,
]);

const AdminSubscriptionDetailStatusEnum
    _$adminSubscriptionDetailStatusEnum_inactive =
    const AdminSubscriptionDetailStatusEnum._('inactive');
const AdminSubscriptionDetailStatusEnum
    _$adminSubscriptionDetailStatusEnum_active =
    const AdminSubscriptionDetailStatusEnum._('active');
const AdminSubscriptionDetailStatusEnum
    _$adminSubscriptionDetailStatusEnum_pastDue =
    const AdminSubscriptionDetailStatusEnum._('pastDue');
const AdminSubscriptionDetailStatusEnum
    _$adminSubscriptionDetailStatusEnum_cancelled =
    const AdminSubscriptionDetailStatusEnum._('cancelled');
const AdminSubscriptionDetailStatusEnum
    _$adminSubscriptionDetailStatusEnum_expired =
    const AdminSubscriptionDetailStatusEnum._('expired');
const AdminSubscriptionDetailStatusEnum
    _$adminSubscriptionDetailStatusEnum_paused =
    const AdminSubscriptionDetailStatusEnum._('paused');

AdminSubscriptionDetailStatusEnum _$adminSubscriptionDetailStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'inactive':
      return _$adminSubscriptionDetailStatusEnum_inactive;
    case 'active':
      return _$adminSubscriptionDetailStatusEnum_active;
    case 'pastDue':
      return _$adminSubscriptionDetailStatusEnum_pastDue;
    case 'cancelled':
      return _$adminSubscriptionDetailStatusEnum_cancelled;
    case 'expired':
      return _$adminSubscriptionDetailStatusEnum_expired;
    case 'paused':
      return _$adminSubscriptionDetailStatusEnum_paused;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionDetailStatusEnum>
    _$adminSubscriptionDetailStatusEnumValues = BuiltSet<
        AdminSubscriptionDetailStatusEnum>(const <AdminSubscriptionDetailStatusEnum>[
  _$adminSubscriptionDetailStatusEnum_inactive,
  _$adminSubscriptionDetailStatusEnum_active,
  _$adminSubscriptionDetailStatusEnum_pastDue,
  _$adminSubscriptionDetailStatusEnum_cancelled,
  _$adminSubscriptionDetailStatusEnum_expired,
  _$adminSubscriptionDetailStatusEnum_paused,
]);

const AdminSubscriptionDetailBillingProviderEnum
    _$adminSubscriptionDetailBillingProviderEnum_paydunya =
    const AdminSubscriptionDetailBillingProviderEnum._('paydunya');
const AdminSubscriptionDetailBillingProviderEnum
    _$adminSubscriptionDetailBillingProviderEnum_manual =
    const AdminSubscriptionDetailBillingProviderEnum._('manual');

AdminSubscriptionDetailBillingProviderEnum
    _$adminSubscriptionDetailBillingProviderEnumValueOf(String name) {
  switch (name) {
    case 'paydunya':
      return _$adminSubscriptionDetailBillingProviderEnum_paydunya;
    case 'manual':
      return _$adminSubscriptionDetailBillingProviderEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionDetailBillingProviderEnum>
    _$adminSubscriptionDetailBillingProviderEnumValues = BuiltSet<
        AdminSubscriptionDetailBillingProviderEnum>(const <AdminSubscriptionDetailBillingProviderEnum>[
  _$adminSubscriptionDetailBillingProviderEnum_paydunya,
  _$adminSubscriptionDetailBillingProviderEnum_manual,
]);

Serializer<AdminSubscriptionDetailTierEnum>
    _$adminSubscriptionDetailTierEnumSerializer =
    _$AdminSubscriptionDetailTierEnumSerializer();
Serializer<AdminSubscriptionDetailStatusEnum>
    _$adminSubscriptionDetailStatusEnumSerializer =
    _$AdminSubscriptionDetailStatusEnumSerializer();
Serializer<AdminSubscriptionDetailBillingProviderEnum>
    _$adminSubscriptionDetailBillingProviderEnumSerializer =
    _$AdminSubscriptionDetailBillingProviderEnumSerializer();

class _$AdminSubscriptionDetailTierEnumSerializer
    implements PrimitiveSerializer<AdminSubscriptionDetailTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'standard': 'standard',
    'premium': 'premium',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'standard': 'standard',
    'premium': 'premium',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminSubscriptionDetailTierEnum];
  @override
  final String wireName = 'AdminSubscriptionDetailTierEnum';

  @override
  Object serialize(
          Serializers serializers, AdminSubscriptionDetailTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionDetailTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionDetailTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionDetailStatusEnumSerializer
    implements PrimitiveSerializer<AdminSubscriptionDetailStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AdminSubscriptionDetailStatusEnum];
  @override
  final String wireName = 'AdminSubscriptionDetailStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminSubscriptionDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionDetailStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionDetailBillingProviderEnumSerializer
    implements PrimitiveSerializer<AdminSubscriptionDetailBillingProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'paydunya': 'paydunya',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'paydunya': 'paydunya',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionDetailBillingProviderEnum
  ];
  @override
  final String wireName = 'AdminSubscriptionDetailBillingProviderEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionDetailBillingProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionDetailBillingProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionDetailBillingProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionDetail extends AdminSubscriptionDetail {
  @override
  final String id;
  @override
  final String salonId;
  @override
  final String salonName;
  @override
  final AdminSubscriptionDetailTierEnum tier;
  @override
  final AdminSubscriptionDetailStatusEnum status;
  @override
  final AdminSubscriptionDetailBillingProviderEnum? billingProvider;
  @override
  final DateTime? expiresAt;
  @override
  final bool autoRenew;
  @override
  final bool isComplimentary;
  @override
  final DateTime startedAt;
  @override
  final DateTime? renewedAt;
  @override
  final BuiltList<AdminSubscriptionDetailEntitlementsInner> entitlements;
  @override
  final BuiltList<AdminSubscriptionDetailEventsInner> events;
  @override
  final BuiltList<AdminSubscriptionDetailInvoicesInner> invoices;
  @override
  final BuiltList<AdminSubscriptionDetailPendingChargesInner> pendingCharges;

  factory _$AdminSubscriptionDetail(
          [void Function(AdminSubscriptionDetailBuilder)? updates]) =>
      (AdminSubscriptionDetailBuilder()..update(updates))._build();

  _$AdminSubscriptionDetail._(
      {required this.id,
      required this.salonId,
      required this.salonName,
      required this.tier,
      required this.status,
      this.billingProvider,
      this.expiresAt,
      required this.autoRenew,
      required this.isComplimentary,
      required this.startedAt,
      this.renewedAt,
      required this.entitlements,
      required this.events,
      required this.invoices,
      required this.pendingCharges})
      : super._();
  @override
  AdminSubscriptionDetail rebuild(
          void Function(AdminSubscriptionDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionDetailBuilder toBuilder() =>
      AdminSubscriptionDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionDetail &&
        id == other.id &&
        salonId == other.salonId &&
        salonName == other.salonName &&
        tier == other.tier &&
        status == other.status &&
        billingProvider == other.billingProvider &&
        expiresAt == other.expiresAt &&
        autoRenew == other.autoRenew &&
        isComplimentary == other.isComplimentary &&
        startedAt == other.startedAt &&
        renewedAt == other.renewedAt &&
        entitlements == other.entitlements &&
        events == other.events &&
        invoices == other.invoices &&
        pendingCharges == other.pendingCharges;
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
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, renewedAt.hashCode);
    _$hash = $jc(_$hash, entitlements.hashCode);
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jc(_$hash, invoices.hashCode);
    _$hash = $jc(_$hash, pendingCharges.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSubscriptionDetail')
          ..add('id', id)
          ..add('salonId', salonId)
          ..add('salonName', salonName)
          ..add('tier', tier)
          ..add('status', status)
          ..add('billingProvider', billingProvider)
          ..add('expiresAt', expiresAt)
          ..add('autoRenew', autoRenew)
          ..add('isComplimentary', isComplimentary)
          ..add('startedAt', startedAt)
          ..add('renewedAt', renewedAt)
          ..add('entitlements', entitlements)
          ..add('events', events)
          ..add('invoices', invoices)
          ..add('pendingCharges', pendingCharges))
        .toString();
  }
}

class AdminSubscriptionDetailBuilder
    implements
        Builder<AdminSubscriptionDetail, AdminSubscriptionDetailBuilder> {
  _$AdminSubscriptionDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  AdminSubscriptionDetailTierEnum? _tier;
  AdminSubscriptionDetailTierEnum? get tier => _$this._tier;
  set tier(AdminSubscriptionDetailTierEnum? tier) => _$this._tier = tier;

  AdminSubscriptionDetailStatusEnum? _status;
  AdminSubscriptionDetailStatusEnum? get status => _$this._status;
  set status(AdminSubscriptionDetailStatusEnum? status) =>
      _$this._status = status;

  AdminSubscriptionDetailBillingProviderEnum? _billingProvider;
  AdminSubscriptionDetailBillingProviderEnum? get billingProvider =>
      _$this._billingProvider;
  set billingProvider(
          AdminSubscriptionDetailBillingProviderEnum? billingProvider) =>
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

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _renewedAt;
  DateTime? get renewedAt => _$this._renewedAt;
  set renewedAt(DateTime? renewedAt) => _$this._renewedAt = renewedAt;

  ListBuilder<AdminSubscriptionDetailEntitlementsInner>? _entitlements;
  ListBuilder<AdminSubscriptionDetailEntitlementsInner> get entitlements =>
      _$this._entitlements ??=
          ListBuilder<AdminSubscriptionDetailEntitlementsInner>();
  set entitlements(
          ListBuilder<AdminSubscriptionDetailEntitlementsInner>?
              entitlements) =>
      _$this._entitlements = entitlements;

  ListBuilder<AdminSubscriptionDetailEventsInner>? _events;
  ListBuilder<AdminSubscriptionDetailEventsInner> get events =>
      _$this._events ??= ListBuilder<AdminSubscriptionDetailEventsInner>();
  set events(ListBuilder<AdminSubscriptionDetailEventsInner>? events) =>
      _$this._events = events;

  ListBuilder<AdminSubscriptionDetailInvoicesInner>? _invoices;
  ListBuilder<AdminSubscriptionDetailInvoicesInner> get invoices =>
      _$this._invoices ??= ListBuilder<AdminSubscriptionDetailInvoicesInner>();
  set invoices(ListBuilder<AdminSubscriptionDetailInvoicesInner>? invoices) =>
      _$this._invoices = invoices;

  ListBuilder<AdminSubscriptionDetailPendingChargesInner>? _pendingCharges;
  ListBuilder<AdminSubscriptionDetailPendingChargesInner> get pendingCharges =>
      _$this._pendingCharges ??=
          ListBuilder<AdminSubscriptionDetailPendingChargesInner>();
  set pendingCharges(
          ListBuilder<AdminSubscriptionDetailPendingChargesInner>?
              pendingCharges) =>
      _$this._pendingCharges = pendingCharges;

  AdminSubscriptionDetailBuilder() {
    AdminSubscriptionDetail._defaults(this);
  }

  AdminSubscriptionDetailBuilder get _$this {
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
      _startedAt = $v.startedAt;
      _renewedAt = $v.renewedAt;
      _entitlements = $v.entitlements.toBuilder();
      _events = $v.events.toBuilder();
      _invoices = $v.invoices.toBuilder();
      _pendingCharges = $v.pendingCharges.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionDetail other) {
    _$v = other as _$AdminSubscriptionDetail;
  }

  @override
  void update(void Function(AdminSubscriptionDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionDetail build() => _build();

  _$AdminSubscriptionDetail _build() {
    _$AdminSubscriptionDetail _$result;
    try {
      _$result = _$v ??
          _$AdminSubscriptionDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminSubscriptionDetail', 'id'),
            salonId: BuiltValueNullFieldError.checkNotNull(
                salonId, r'AdminSubscriptionDetail', 'salonId'),
            salonName: BuiltValueNullFieldError.checkNotNull(
                salonName, r'AdminSubscriptionDetail', 'salonName'),
            tier: BuiltValueNullFieldError.checkNotNull(
                tier, r'AdminSubscriptionDetail', 'tier'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminSubscriptionDetail', 'status'),
            billingProvider: billingProvider,
            expiresAt: expiresAt,
            autoRenew: BuiltValueNullFieldError.checkNotNull(
                autoRenew, r'AdminSubscriptionDetail', 'autoRenew'),
            isComplimentary: BuiltValueNullFieldError.checkNotNull(
                isComplimentary, r'AdminSubscriptionDetail', 'isComplimentary'),
            startedAt: BuiltValueNullFieldError.checkNotNull(
                startedAt, r'AdminSubscriptionDetail', 'startedAt'),
            renewedAt: renewedAt,
            entitlements: entitlements.build(),
            events: events.build(),
            invoices: invoices.build(),
            pendingCharges: pendingCharges.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entitlements';
        entitlements.build();
        _$failedField = 'events';
        events.build();
        _$failedField = 'invoices';
        invoices.build();
        _$failedField = 'pendingCharges';
        pendingCharges.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminSubscriptionDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
