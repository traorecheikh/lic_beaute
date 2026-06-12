// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_detail_pending_charges_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum
    _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnum_upgrade =
    const AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum._('upgrade');
const AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum
    _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnum_renewal =
    const AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum._('renewal');

AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum
    _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'upgrade':
      return _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnum_upgrade;
    case 'renewal':
      return _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnum_renewal;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum>
    _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnumValues = BuiltSet<
        AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum>(const <AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum>[
  _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnum_upgrade,
  _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnum_renewal,
]);

const AdminSubscriptionDetailPendingChargesInnerProviderEnum
    _$adminSubscriptionDetailPendingChargesInnerProviderEnum_paydunya =
    const AdminSubscriptionDetailPendingChargesInnerProviderEnum._('paydunya');
const AdminSubscriptionDetailPendingChargesInnerProviderEnum
    _$adminSubscriptionDetailPendingChargesInnerProviderEnum_manual =
    const AdminSubscriptionDetailPendingChargesInnerProviderEnum._('manual');

AdminSubscriptionDetailPendingChargesInnerProviderEnum
    _$adminSubscriptionDetailPendingChargesInnerProviderEnumValueOf(
        String name) {
  switch (name) {
    case 'paydunya':
      return _$adminSubscriptionDetailPendingChargesInnerProviderEnum_paydunya;
    case 'manual':
      return _$adminSubscriptionDetailPendingChargesInnerProviderEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionDetailPendingChargesInnerProviderEnum>
    _$adminSubscriptionDetailPendingChargesInnerProviderEnumValues = BuiltSet<
        AdminSubscriptionDetailPendingChargesInnerProviderEnum>(const <AdminSubscriptionDetailPendingChargesInnerProviderEnum>[
  _$adminSubscriptionDetailPendingChargesInnerProviderEnum_paydunya,
  _$adminSubscriptionDetailPendingChargesInnerProviderEnum_manual,
]);

const AdminSubscriptionDetailPendingChargesInnerStatusEnum
    _$adminSubscriptionDetailPendingChargesInnerStatusEnum_pending =
    const AdminSubscriptionDetailPendingChargesInnerStatusEnum._('pending');
const AdminSubscriptionDetailPendingChargesInnerStatusEnum
    _$adminSubscriptionDetailPendingChargesInnerStatusEnum_authorized =
    const AdminSubscriptionDetailPendingChargesInnerStatusEnum._('authorized');
const AdminSubscriptionDetailPendingChargesInnerStatusEnum
    _$adminSubscriptionDetailPendingChargesInnerStatusEnum_succeeded =
    const AdminSubscriptionDetailPendingChargesInnerStatusEnum._('succeeded');
const AdminSubscriptionDetailPendingChargesInnerStatusEnum
    _$adminSubscriptionDetailPendingChargesInnerStatusEnum_failed =
    const AdminSubscriptionDetailPendingChargesInnerStatusEnum._('failed');
const AdminSubscriptionDetailPendingChargesInnerStatusEnum
    _$adminSubscriptionDetailPendingChargesInnerStatusEnum_refunded =
    const AdminSubscriptionDetailPendingChargesInnerStatusEnum._('refunded');

AdminSubscriptionDetailPendingChargesInnerStatusEnum
    _$adminSubscriptionDetailPendingChargesInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$adminSubscriptionDetailPendingChargesInnerStatusEnum_pending;
    case 'authorized':
      return _$adminSubscriptionDetailPendingChargesInnerStatusEnum_authorized;
    case 'succeeded':
      return _$adminSubscriptionDetailPendingChargesInnerStatusEnum_succeeded;
    case 'failed':
      return _$adminSubscriptionDetailPendingChargesInnerStatusEnum_failed;
    case 'refunded':
      return _$adminSubscriptionDetailPendingChargesInnerStatusEnum_refunded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionDetailPendingChargesInnerStatusEnum>
    _$adminSubscriptionDetailPendingChargesInnerStatusEnumValues = BuiltSet<
        AdminSubscriptionDetailPendingChargesInnerStatusEnum>(const <AdminSubscriptionDetailPendingChargesInnerStatusEnum>[
  _$adminSubscriptionDetailPendingChargesInnerStatusEnum_pending,
  _$adminSubscriptionDetailPendingChargesInnerStatusEnum_authorized,
  _$adminSubscriptionDetailPendingChargesInnerStatusEnum_succeeded,
  _$adminSubscriptionDetailPendingChargesInnerStatusEnum_failed,
  _$adminSubscriptionDetailPendingChargesInnerStatusEnum_refunded,
]);

Serializer<AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum>
    _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnumSerializer =
    _$AdminSubscriptionDetailPendingChargesInnerChargeTypeEnumSerializer();
Serializer<AdminSubscriptionDetailPendingChargesInnerProviderEnum>
    _$adminSubscriptionDetailPendingChargesInnerProviderEnumSerializer =
    _$AdminSubscriptionDetailPendingChargesInnerProviderEnumSerializer();
Serializer<AdminSubscriptionDetailPendingChargesInnerStatusEnum>
    _$adminSubscriptionDetailPendingChargesInnerStatusEnumSerializer =
    _$AdminSubscriptionDetailPendingChargesInnerStatusEnumSerializer();

class _$AdminSubscriptionDetailPendingChargesInnerChargeTypeEnumSerializer
    implements
        PrimitiveSerializer<
            AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'upgrade': 'upgrade',
    'renewal': 'renewal',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'upgrade': 'upgrade',
    'renewal': 'renewal',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum
  ];
  @override
  final String wireName =
      'AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionDetailPendingChargesInnerProviderEnumSerializer
    implements
        PrimitiveSerializer<
            AdminSubscriptionDetailPendingChargesInnerProviderEnum> {
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
    AdminSubscriptionDetailPendingChargesInnerProviderEnum
  ];
  @override
  final String wireName =
      'AdminSubscriptionDetailPendingChargesInnerProviderEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionDetailPendingChargesInnerProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionDetailPendingChargesInnerProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionDetailPendingChargesInnerProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionDetailPendingChargesInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminSubscriptionDetailPendingChargesInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'authorized': 'authorized',
    'succeeded': 'succeeded',
    'failed': 'failed',
    'refunded': 'refunded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'authorized': 'authorized',
    'succeeded': 'succeeded',
    'failed': 'failed',
    'refunded': 'refunded',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionDetailPendingChargesInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminSubscriptionDetailPendingChargesInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionDetailPendingChargesInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionDetailPendingChargesInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionDetailPendingChargesInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionDetailPendingChargesInner
    extends AdminSubscriptionDetailPendingChargesInner {
  @override
  final String id;
  @override
  final int amountXof;
  @override
  final AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum chargeType;
  @override
  final AdminSubscriptionDetailPendingChargesInnerProviderEnum provider;
  @override
  final AdminSubscriptionDetailPendingChargesInnerStatusEnum status;
  @override
  final DateTime createdAt;

  factory _$AdminSubscriptionDetailPendingChargesInner(
          [void Function(AdminSubscriptionDetailPendingChargesInnerBuilder)?
              updates]) =>
      (AdminSubscriptionDetailPendingChargesInnerBuilder()..update(updates))
          ._build();

  _$AdminSubscriptionDetailPendingChargesInner._(
      {required this.id,
      required this.amountXof,
      required this.chargeType,
      required this.provider,
      required this.status,
      required this.createdAt})
      : super._();
  @override
  AdminSubscriptionDetailPendingChargesInner rebuild(
          void Function(AdminSubscriptionDetailPendingChargesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionDetailPendingChargesInnerBuilder toBuilder() =>
      AdminSubscriptionDetailPendingChargesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionDetailPendingChargesInner &&
        id == other.id &&
        amountXof == other.amountXof &&
        chargeType == other.chargeType &&
        provider == other.provider &&
        status == other.status &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, amountXof.hashCode);
    _$hash = $jc(_$hash, chargeType.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSubscriptionDetailPendingChargesInner')
          ..add('id', id)
          ..add('amountXof', amountXof)
          ..add('chargeType', chargeType)
          ..add('provider', provider)
          ..add('status', status)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminSubscriptionDetailPendingChargesInnerBuilder
    implements
        Builder<AdminSubscriptionDetailPendingChargesInner,
            AdminSubscriptionDetailPendingChargesInnerBuilder> {
  _$AdminSubscriptionDetailPendingChargesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _amountXof;
  int? get amountXof => _$this._amountXof;
  set amountXof(int? amountXof) => _$this._amountXof = amountXof;

  AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum? _chargeType;
  AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum? get chargeType =>
      _$this._chargeType;
  set chargeType(
          AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum?
              chargeType) =>
      _$this._chargeType = chargeType;

  AdminSubscriptionDetailPendingChargesInnerProviderEnum? _provider;
  AdminSubscriptionDetailPendingChargesInnerProviderEnum? get provider =>
      _$this._provider;
  set provider(
          AdminSubscriptionDetailPendingChargesInnerProviderEnum? provider) =>
      _$this._provider = provider;

  AdminSubscriptionDetailPendingChargesInnerStatusEnum? _status;
  AdminSubscriptionDetailPendingChargesInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminSubscriptionDetailPendingChargesInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminSubscriptionDetailPendingChargesInnerBuilder() {
    AdminSubscriptionDetailPendingChargesInner._defaults(this);
  }

  AdminSubscriptionDetailPendingChargesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _amountXof = $v.amountXof;
      _chargeType = $v.chargeType;
      _provider = $v.provider;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionDetailPendingChargesInner other) {
    _$v = other as _$AdminSubscriptionDetailPendingChargesInner;
  }

  @override
  void update(
      void Function(AdminSubscriptionDetailPendingChargesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionDetailPendingChargesInner build() => _build();

  _$AdminSubscriptionDetailPendingChargesInner _build() {
    final _$result = _$v ??
        _$AdminSubscriptionDetailPendingChargesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminSubscriptionDetailPendingChargesInner', 'id'),
          amountXof: BuiltValueNullFieldError.checkNotNull(amountXof,
              r'AdminSubscriptionDetailPendingChargesInner', 'amountXof'),
          chargeType: BuiltValueNullFieldError.checkNotNull(chargeType,
              r'AdminSubscriptionDetailPendingChargesInner', 'chargeType'),
          provider: BuiltValueNullFieldError.checkNotNull(provider,
              r'AdminSubscriptionDetailPendingChargesInner', 'provider'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminSubscriptionDetailPendingChargesInner', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'AdminSubscriptionDetailPendingChargesInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
