// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_benefit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClientBenefitKindEnum _$clientBenefitKindEnum_membership =
    const ClientBenefitKindEnum._('membership');
const ClientBenefitKindEnum _$clientBenefitKindEnum_package =
    const ClientBenefitKindEnum._('package');

ClientBenefitKindEnum _$clientBenefitKindEnumValueOf(String name) {
  switch (name) {
    case 'membership':
      return _$clientBenefitKindEnum_membership;
    case 'package':
      return _$clientBenefitKindEnum_package;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClientBenefitKindEnum> _$clientBenefitKindEnumValues =
    BuiltSet<ClientBenefitKindEnum>(const <ClientBenefitKindEnum>[
  _$clientBenefitKindEnum_membership,
  _$clientBenefitKindEnum_package,
]);

const ClientBenefitStatusEnum _$clientBenefitStatusEnum_active =
    const ClientBenefitStatusEnum._('active');
const ClientBenefitStatusEnum _$clientBenefitStatusEnum_paused =
    const ClientBenefitStatusEnum._('paused');
const ClientBenefitStatusEnum _$clientBenefitStatusEnum_expired =
    const ClientBenefitStatusEnum._('expired');
const ClientBenefitStatusEnum _$clientBenefitStatusEnum_exhausted =
    const ClientBenefitStatusEnum._('exhausted');
const ClientBenefitStatusEnum _$clientBenefitStatusEnum_cancelled =
    const ClientBenefitStatusEnum._('cancelled');

ClientBenefitStatusEnum _$clientBenefitStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$clientBenefitStatusEnum_active;
    case 'paused':
      return _$clientBenefitStatusEnum_paused;
    case 'expired':
      return _$clientBenefitStatusEnum_expired;
    case 'exhausted':
      return _$clientBenefitStatusEnum_exhausted;
    case 'cancelled':
      return _$clientBenefitStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClientBenefitStatusEnum> _$clientBenefitStatusEnumValues =
    BuiltSet<ClientBenefitStatusEnum>(const <ClientBenefitStatusEnum>[
  _$clientBenefitStatusEnum_active,
  _$clientBenefitStatusEnum_paused,
  _$clientBenefitStatusEnum_expired,
  _$clientBenefitStatusEnum_exhausted,
  _$clientBenefitStatusEnum_cancelled,
]);

Serializer<ClientBenefitKindEnum> _$clientBenefitKindEnumSerializer =
    _$ClientBenefitKindEnumSerializer();
Serializer<ClientBenefitStatusEnum> _$clientBenefitStatusEnumSerializer =
    _$ClientBenefitStatusEnumSerializer();

class _$ClientBenefitKindEnumSerializer
    implements PrimitiveSerializer<ClientBenefitKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'membership': 'membership',
    'package': 'package',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'membership': 'membership',
    'package': 'package',
  };

  @override
  final Iterable<Type> types = const <Type>[ClientBenefitKindEnum];
  @override
  final String wireName = 'ClientBenefitKindEnum';

  @override
  Object serialize(Serializers serializers, ClientBenefitKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClientBenefitKindEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClientBenefitKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClientBenefitStatusEnumSerializer
    implements PrimitiveSerializer<ClientBenefitStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'paused': 'paused',
    'expired': 'expired',
    'exhausted': 'exhausted',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'paused': 'paused',
    'expired': 'expired',
    'exhausted': 'exhausted',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[ClientBenefitStatusEnum];
  @override
  final String wireName = 'ClientBenefitStatusEnum';

  @override
  Object serialize(Serializers serializers, ClientBenefitStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClientBenefitStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClientBenefitStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClientBenefit extends ClientBenefit {
  @override
  final String id;
  @override
  final ClientBenefitKindEnum kind;
  @override
  final String name;
  @override
  final ClientBenefitStatusEnum status;
  @override
  final int? remainingUses;
  @override
  final String? expiresAt;
  @override
  final String? billingDate;
  @override
  final String salonId;
  @override
  final String salonName;
  @override
  final String createdAt;

  factory _$ClientBenefit([void Function(ClientBenefitBuilder)? updates]) =>
      (ClientBenefitBuilder()..update(updates))._build();

  _$ClientBenefit._(
      {required this.id,
      required this.kind,
      required this.name,
      required this.status,
      this.remainingUses,
      this.expiresAt,
      this.billingDate,
      required this.salonId,
      required this.salonName,
      required this.createdAt})
      : super._();
  @override
  ClientBenefit rebuild(void Function(ClientBenefitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientBenefitBuilder toBuilder() => ClientBenefitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientBenefit &&
        id == other.id &&
        kind == other.kind &&
        name == other.name &&
        status == other.status &&
        remainingUses == other.remainingUses &&
        expiresAt == other.expiresAt &&
        billingDate == other.billingDate &&
        salonId == other.salonId &&
        salonName == other.salonName &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, remainingUses.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, billingDate.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, salonName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClientBenefit')
          ..add('id', id)
          ..add('kind', kind)
          ..add('name', name)
          ..add('status', status)
          ..add('remainingUses', remainingUses)
          ..add('expiresAt', expiresAt)
          ..add('billingDate', billingDate)
          ..add('salonId', salonId)
          ..add('salonName', salonName)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ClientBenefitBuilder
    implements Builder<ClientBenefit, ClientBenefitBuilder> {
  _$ClientBenefit? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ClientBenefitKindEnum? _kind;
  ClientBenefitKindEnum? get kind => _$this._kind;
  set kind(ClientBenefitKindEnum? kind) => _$this._kind = kind;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ClientBenefitStatusEnum? _status;
  ClientBenefitStatusEnum? get status => _$this._status;
  set status(ClientBenefitStatusEnum? status) => _$this._status = status;

  int? _remainingUses;
  int? get remainingUses => _$this._remainingUses;
  set remainingUses(int? remainingUses) =>
      _$this._remainingUses = remainingUses;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  String? _billingDate;
  String? get billingDate => _$this._billingDate;
  set billingDate(String? billingDate) => _$this._billingDate = billingDate;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  ClientBenefitBuilder() {
    ClientBenefit._defaults(this);
  }

  ClientBenefitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _name = $v.name;
      _status = $v.status;
      _remainingUses = $v.remainingUses;
      _expiresAt = $v.expiresAt;
      _billingDate = $v.billingDate;
      _salonId = $v.salonId;
      _salonName = $v.salonName;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientBenefit other) {
    _$v = other as _$ClientBenefit;
  }

  @override
  void update(void Function(ClientBenefitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClientBenefit build() => _build();

  _$ClientBenefit _build() {
    final _$result = _$v ??
        _$ClientBenefit._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ClientBenefit', 'id'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'ClientBenefit', 'kind'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ClientBenefit', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ClientBenefit', 'status'),
          remainingUses: remainingUses,
          expiresAt: expiresAt,
          billingDate: billingDate,
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'ClientBenefit', 'salonId'),
          salonName: BuiltValueNullFieldError.checkNotNull(
              salonName, r'ClientBenefit', 'salonName'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ClientBenefit', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
