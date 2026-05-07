// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_me_vouchers_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum
    _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_active =
    const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum._('active');
const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum
    _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_used =
    const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum._('used');
const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum
    _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_expired =
    const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum._('expired');

ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum
    _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_active;
    case 'used':
      return _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_used;
    case 'expired':
      return _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_expired;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum>
    _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnumValues = BuiltSet<
        ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum>(const <ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum>[
  _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_active,
  _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_used,
  _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_expired,
]);

Serializer<ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum>
    _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnumSerializer =
    _$ApiV1MeVouchersGet200ResponseItemsInnerStatusEnumSerializer();

class _$ApiV1MeVouchersGet200ResponseItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'used': 'used',
    'expired': 'expired',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'used': 'used',
    'expired': 'expired',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1MeVouchersGet200ResponseItemsInner
    extends ApiV1MeVouchersGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String discountLabel;
  @override
  final ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum status;
  @override
  final String? expiresAt;
  @override
  final String redeemedAt;
  @override
  final String? usedAt;
  @override
  final String? salonId;
  @override
  final String? salonName;

  factory _$ApiV1MeVouchersGet200ResponseItemsInner(
          [void Function(ApiV1MeVouchersGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (ApiV1MeVouchersGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$ApiV1MeVouchersGet200ResponseItemsInner._(
      {required this.id,
      required this.code,
      required this.title,
      this.description,
      required this.discountLabel,
      required this.status,
      this.expiresAt,
      required this.redeemedAt,
      this.usedAt,
      this.salonId,
      this.salonName})
      : super._();
  @override
  ApiV1MeVouchersGet200ResponseItemsInner rebuild(
          void Function(ApiV1MeVouchersGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MeVouchersGet200ResponseItemsInnerBuilder toBuilder() =>
      ApiV1MeVouchersGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MeVouchersGet200ResponseItemsInner &&
        id == other.id &&
        code == other.code &&
        title == other.title &&
        description == other.description &&
        discountLabel == other.discountLabel &&
        status == other.status &&
        expiresAt == other.expiresAt &&
        redeemedAt == other.redeemedAt &&
        usedAt == other.usedAt &&
        salonId == other.salonId &&
        salonName == other.salonName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, discountLabel.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, redeemedAt.hashCode);
    _$hash = $jc(_$hash, usedAt.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, salonName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1MeVouchersGet200ResponseItemsInner')
          ..add('id', id)
          ..add('code', code)
          ..add('title', title)
          ..add('description', description)
          ..add('discountLabel', discountLabel)
          ..add('status', status)
          ..add('expiresAt', expiresAt)
          ..add('redeemedAt', redeemedAt)
          ..add('usedAt', usedAt)
          ..add('salonId', salonId)
          ..add('salonName', salonName))
        .toString();
  }
}

class ApiV1MeVouchersGet200ResponseItemsInnerBuilder
    implements
        Builder<ApiV1MeVouchersGet200ResponseItemsInner,
            ApiV1MeVouchersGet200ResponseItemsInnerBuilder> {
  _$ApiV1MeVouchersGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _discountLabel;
  String? get discountLabel => _$this._discountLabel;
  set discountLabel(String? discountLabel) =>
      _$this._discountLabel = discountLabel;

  ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum? _status;
  ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  String? _redeemedAt;
  String? get redeemedAt => _$this._redeemedAt;
  set redeemedAt(String? redeemedAt) => _$this._redeemedAt = redeemedAt;

  String? _usedAt;
  String? get usedAt => _$this._usedAt;
  set usedAt(String? usedAt) => _$this._usedAt = usedAt;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  ApiV1MeVouchersGet200ResponseItemsInnerBuilder() {
    ApiV1MeVouchersGet200ResponseItemsInner._defaults(this);
  }

  ApiV1MeVouchersGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _title = $v.title;
      _description = $v.description;
      _discountLabel = $v.discountLabel;
      _status = $v.status;
      _expiresAt = $v.expiresAt;
      _redeemedAt = $v.redeemedAt;
      _usedAt = $v.usedAt;
      _salonId = $v.salonId;
      _salonName = $v.salonName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MeVouchersGet200ResponseItemsInner other) {
    _$v = other as _$ApiV1MeVouchersGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(ApiV1MeVouchersGet200ResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MeVouchersGet200ResponseItemsInner build() => _build();

  _$ApiV1MeVouchersGet200ResponseItemsInner _build() {
    final _$result = _$v ??
        _$ApiV1MeVouchersGet200ResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1MeVouchersGet200ResponseItemsInner', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ApiV1MeVouchersGet200ResponseItemsInner', 'code'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ApiV1MeVouchersGet200ResponseItemsInner', 'title'),
          description: description,
          discountLabel: BuiltValueNullFieldError.checkNotNull(discountLabel,
              r'ApiV1MeVouchersGet200ResponseItemsInner', 'discountLabel'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ApiV1MeVouchersGet200ResponseItemsInner', 'status'),
          expiresAt: expiresAt,
          redeemedAt: BuiltValueNullFieldError.checkNotNull(redeemedAt,
              r'ApiV1MeVouchersGet200ResponseItemsInner', 'redeemedAt'),
          usedAt: usedAt,
          salonId: salonId,
          salonName: salonName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
