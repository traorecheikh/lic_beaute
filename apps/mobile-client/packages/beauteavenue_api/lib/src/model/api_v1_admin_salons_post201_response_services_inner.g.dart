// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_salons_post201_response_services_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum
    _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_none =
    const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum._('none');
const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum
    _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_fixed =
    const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum._(
        'fixed');
const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum
    _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_percent =
    const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum._(
        'percent');

ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum
    _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnumValueOf(
        String name) {
  switch (name) {
    case 'none':
      return _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_none;
    case 'fixed':
      return _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_fixed;
    case 'percent':
      return _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_percent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum>
    _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnumValues =
    BuiltSet<
        ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum>(const <ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum>[
  _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_none,
  _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_fixed,
  _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_percent,
]);

Serializer<ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum>
    _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnumSerializer =
    _$ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnumSerializer();

class _$ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnumSerializer
    implements
        PrimitiveSerializer<
            ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'none': 'none',
    'fixed': 'fixed',
    'percent': 'percent',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'none': 'none',
    'fixed': 'fixed',
    'percent': 'percent',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum
  ];
  @override
  final String wireName =
      'ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1AdminSalonsPost201ResponseServicesInner
    extends ApiV1AdminSalonsPost201ResponseServicesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final int durationMinutes;
  @override
  final int priceXof;
  @override
  final ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum depositMode;
  @override
  final int? depositAmountXof;
  @override
  final int? depositPercent;

  factory _$ApiV1AdminSalonsPost201ResponseServicesInner(
          [void Function(ApiV1AdminSalonsPost201ResponseServicesInnerBuilder)?
              updates]) =>
      (ApiV1AdminSalonsPost201ResponseServicesInnerBuilder()..update(updates))
          ._build();

  _$ApiV1AdminSalonsPost201ResponseServicesInner._(
      {required this.id,
      required this.name,
      required this.durationMinutes,
      required this.priceXof,
      required this.depositMode,
      this.depositAmountXof,
      this.depositPercent})
      : super._();
  @override
  ApiV1AdminSalonsPost201ResponseServicesInner rebuild(
          void Function(ApiV1AdminSalonsPost201ResponseServicesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminSalonsPost201ResponseServicesInnerBuilder toBuilder() =>
      ApiV1AdminSalonsPost201ResponseServicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminSalonsPost201ResponseServicesInner &&
        id == other.id &&
        name == other.name &&
        durationMinutes == other.durationMinutes &&
        priceXof == other.priceXof &&
        depositMode == other.depositMode &&
        depositAmountXof == other.depositAmountXof &&
        depositPercent == other.depositPercent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, durationMinutes.hashCode);
    _$hash = $jc(_$hash, priceXof.hashCode);
    _$hash = $jc(_$hash, depositMode.hashCode);
    _$hash = $jc(_$hash, depositAmountXof.hashCode);
    _$hash = $jc(_$hash, depositPercent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminSalonsPost201ResponseServicesInner')
          ..add('id', id)
          ..add('name', name)
          ..add('durationMinutes', durationMinutes)
          ..add('priceXof', priceXof)
          ..add('depositMode', depositMode)
          ..add('depositAmountXof', depositAmountXof)
          ..add('depositPercent', depositPercent))
        .toString();
  }
}

class ApiV1AdminSalonsPost201ResponseServicesInnerBuilder
    implements
        Builder<ApiV1AdminSalonsPost201ResponseServicesInner,
            ApiV1AdminSalonsPost201ResponseServicesInnerBuilder> {
  _$ApiV1AdminSalonsPost201ResponseServicesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _durationMinutes;
  int? get durationMinutes => _$this._durationMinutes;
  set durationMinutes(int? durationMinutes) =>
      _$this._durationMinutes = durationMinutes;

  int? _priceXof;
  int? get priceXof => _$this._priceXof;
  set priceXof(int? priceXof) => _$this._priceXof = priceXof;

  ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum? _depositMode;
  ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum?
      get depositMode => _$this._depositMode;
  set depositMode(
          ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum?
              depositMode) =>
      _$this._depositMode = depositMode;

  int? _depositAmountXof;
  int? get depositAmountXof => _$this._depositAmountXof;
  set depositAmountXof(int? depositAmountXof) =>
      _$this._depositAmountXof = depositAmountXof;

  int? _depositPercent;
  int? get depositPercent => _$this._depositPercent;
  set depositPercent(int? depositPercent) =>
      _$this._depositPercent = depositPercent;

  ApiV1AdminSalonsPost201ResponseServicesInnerBuilder() {
    ApiV1AdminSalonsPost201ResponseServicesInner._defaults(this);
  }

  ApiV1AdminSalonsPost201ResponseServicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _durationMinutes = $v.durationMinutes;
      _priceXof = $v.priceXof;
      _depositMode = $v.depositMode;
      _depositAmountXof = $v.depositAmountXof;
      _depositPercent = $v.depositPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminSalonsPost201ResponseServicesInner other) {
    _$v = other as _$ApiV1AdminSalonsPost201ResponseServicesInner;
  }

  @override
  void update(
      void Function(ApiV1AdminSalonsPost201ResponseServicesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminSalonsPost201ResponseServicesInner build() => _build();

  _$ApiV1AdminSalonsPost201ResponseServicesInner _build() {
    final _$result = _$v ??
        _$ApiV1AdminSalonsPost201ResponseServicesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1AdminSalonsPost201ResponseServicesInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ApiV1AdminSalonsPost201ResponseServicesInner', 'name'),
          durationMinutes: BuiltValueNullFieldError.checkNotNull(
              durationMinutes,
              r'ApiV1AdminSalonsPost201ResponseServicesInner',
              'durationMinutes'),
          priceXof: BuiltValueNullFieldError.checkNotNull(priceXof,
              r'ApiV1AdminSalonsPost201ResponseServicesInner', 'priceXof'),
          depositMode: BuiltValueNullFieldError.checkNotNull(depositMode,
              r'ApiV1AdminSalonsPost201ResponseServicesInner', 'depositMode'),
          depositAmountXof: depositAmountXof,
          depositPercent: depositPercent,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
