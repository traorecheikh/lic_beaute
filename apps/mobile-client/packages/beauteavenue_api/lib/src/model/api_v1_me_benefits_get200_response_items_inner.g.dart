// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_me_benefits_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum
    _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnum_membership =
    const ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum._('membership');
const ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum
    _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnum_package =
    const ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum._('package');

ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum
    _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'membership':
      return _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnum_membership;
    case 'package':
      return _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnum_package;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum>
    _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnumValues = BuiltSet<
        ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum>(const <ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum>[
  _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnum_membership,
  _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnum_package,
]);

const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum
    _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_active =
    const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum._('active');
const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum
    _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_paused =
    const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum._('paused');
const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum
    _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_expired =
    const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum._('expired');
const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum
    _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_exhausted =
    const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum._('exhausted');
const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum
    _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_cancelled =
    const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum._('cancelled');

ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum
    _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_active;
    case 'paused':
      return _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_paused;
    case 'expired':
      return _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_expired;
    case 'exhausted':
      return _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_exhausted;
    case 'cancelled':
      return _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum>
    _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnumValues = BuiltSet<
        ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum>(const <ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum>[
  _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_active,
  _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_paused,
  _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_expired,
  _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_exhausted,
  _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_cancelled,
]);

Serializer<ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum>
    _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnumSerializer =
    _$ApiV1MeBenefitsGet200ResponseItemsInnerKindEnumSerializer();
Serializer<ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum>
    _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnumSerializer =
    _$ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnumSerializer();

class _$ApiV1MeBenefitsGet200ResponseItemsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'membership': 'membership',
    'package': 'package',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'membership': 'membership',
    'package': 'package',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum
  ];
  @override
  final String wireName = 'ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1MeBenefitsGet200ResponseItemsInner
    extends ApiV1MeBenefitsGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum kind;
  @override
  final String name;
  @override
  final ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum status;
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

  factory _$ApiV1MeBenefitsGet200ResponseItemsInner(
          [void Function(ApiV1MeBenefitsGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (ApiV1MeBenefitsGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$ApiV1MeBenefitsGet200ResponseItemsInner._(
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
  ApiV1MeBenefitsGet200ResponseItemsInner rebuild(
          void Function(ApiV1MeBenefitsGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MeBenefitsGet200ResponseItemsInnerBuilder toBuilder() =>
      ApiV1MeBenefitsGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MeBenefitsGet200ResponseItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'ApiV1MeBenefitsGet200ResponseItemsInner')
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

class ApiV1MeBenefitsGet200ResponseItemsInnerBuilder
    implements
        Builder<ApiV1MeBenefitsGet200ResponseItemsInner,
            ApiV1MeBenefitsGet200ResponseItemsInnerBuilder> {
  _$ApiV1MeBenefitsGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum? _kind;
  ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum? get kind => _$this._kind;
  set kind(ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum? _status;
  ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum? status) =>
      _$this._status = status;

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

  ApiV1MeBenefitsGet200ResponseItemsInnerBuilder() {
    ApiV1MeBenefitsGet200ResponseItemsInner._defaults(this);
  }

  ApiV1MeBenefitsGet200ResponseItemsInnerBuilder get _$this {
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
  void replace(ApiV1MeBenefitsGet200ResponseItemsInner other) {
    _$v = other as _$ApiV1MeBenefitsGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(ApiV1MeBenefitsGet200ResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MeBenefitsGet200ResponseItemsInner build() => _build();

  _$ApiV1MeBenefitsGet200ResponseItemsInner _build() {
    final _$result = _$v ??
        _$ApiV1MeBenefitsGet200ResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1MeBenefitsGet200ResponseItemsInner', 'id'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'ApiV1MeBenefitsGet200ResponseItemsInner', 'kind'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ApiV1MeBenefitsGet200ResponseItemsInner', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ApiV1MeBenefitsGet200ResponseItemsInner', 'status'),
          remainingUses: remainingUses,
          expiresAt: expiresAt,
          billingDate: billingDate,
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'ApiV1MeBenefitsGet200ResponseItemsInner', 'salonId'),
          salonName: BuiltValueNullFieldError.checkNotNull(salonName,
              r'ApiV1MeBenefitsGet200ResponseItemsInner', 'salonName'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'ApiV1MeBenefitsGet200ResponseItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
