// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_input_any_of1_services_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegisterInputAnyOf1ServicesInnerDepositModeEnum
    _$registerInputAnyOf1ServicesInnerDepositModeEnum_none =
    const RegisterInputAnyOf1ServicesInnerDepositModeEnum._('none');
const RegisterInputAnyOf1ServicesInnerDepositModeEnum
    _$registerInputAnyOf1ServicesInnerDepositModeEnum_fixed =
    const RegisterInputAnyOf1ServicesInnerDepositModeEnum._('fixed');
const RegisterInputAnyOf1ServicesInnerDepositModeEnum
    _$registerInputAnyOf1ServicesInnerDepositModeEnum_percent =
    const RegisterInputAnyOf1ServicesInnerDepositModeEnum._('percent');

RegisterInputAnyOf1ServicesInnerDepositModeEnum
    _$registerInputAnyOf1ServicesInnerDepositModeEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$registerInputAnyOf1ServicesInnerDepositModeEnum_none;
    case 'fixed':
      return _$registerInputAnyOf1ServicesInnerDepositModeEnum_fixed;
    case 'percent':
      return _$registerInputAnyOf1ServicesInnerDepositModeEnum_percent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegisterInputAnyOf1ServicesInnerDepositModeEnum>
    _$registerInputAnyOf1ServicesInnerDepositModeEnumValues = BuiltSet<
        RegisterInputAnyOf1ServicesInnerDepositModeEnum>(const <RegisterInputAnyOf1ServicesInnerDepositModeEnum>[
  _$registerInputAnyOf1ServicesInnerDepositModeEnum_none,
  _$registerInputAnyOf1ServicesInnerDepositModeEnum_fixed,
  _$registerInputAnyOf1ServicesInnerDepositModeEnum_percent,
]);

Serializer<RegisterInputAnyOf1ServicesInnerDepositModeEnum>
    _$registerInputAnyOf1ServicesInnerDepositModeEnumSerializer =
    _$RegisterInputAnyOf1ServicesInnerDepositModeEnumSerializer();

class _$RegisterInputAnyOf1ServicesInnerDepositModeEnumSerializer
    implements
        PrimitiveSerializer<RegisterInputAnyOf1ServicesInnerDepositModeEnum> {
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
    RegisterInputAnyOf1ServicesInnerDepositModeEnum
  ];
  @override
  final String wireName = 'RegisterInputAnyOf1ServicesInnerDepositModeEnum';

  @override
  Object serialize(Serializers serializers,
          RegisterInputAnyOf1ServicesInnerDepositModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterInputAnyOf1ServicesInnerDepositModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterInputAnyOf1ServicesInnerDepositModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterInputAnyOf1ServicesInner
    extends RegisterInputAnyOf1ServicesInner {
  @override
  final String name;
  @override
  final int durationMinutes;
  @override
  final int priceXof;
  @override
  final RegisterInputAnyOf1ServicesInnerDepositModeEnum depositMode;
  @override
  final int? depositAmountXof;
  @override
  final int? depositPercent;

  factory _$RegisterInputAnyOf1ServicesInner(
          [void Function(RegisterInputAnyOf1ServicesInnerBuilder)? updates]) =>
      (RegisterInputAnyOf1ServicesInnerBuilder()..update(updates))._build();

  _$RegisterInputAnyOf1ServicesInner._(
      {required this.name,
      required this.durationMinutes,
      required this.priceXof,
      required this.depositMode,
      this.depositAmountXof,
      this.depositPercent})
      : super._();
  @override
  RegisterInputAnyOf1ServicesInner rebuild(
          void Function(RegisterInputAnyOf1ServicesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterInputAnyOf1ServicesInnerBuilder toBuilder() =>
      RegisterInputAnyOf1ServicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterInputAnyOf1ServicesInner &&
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
    return (newBuiltValueToStringHelper(r'RegisterInputAnyOf1ServicesInner')
          ..add('name', name)
          ..add('durationMinutes', durationMinutes)
          ..add('priceXof', priceXof)
          ..add('depositMode', depositMode)
          ..add('depositAmountXof', depositAmountXof)
          ..add('depositPercent', depositPercent))
        .toString();
  }
}

class RegisterInputAnyOf1ServicesInnerBuilder
    implements
        Builder<RegisterInputAnyOf1ServicesInner,
            RegisterInputAnyOf1ServicesInnerBuilder> {
  _$RegisterInputAnyOf1ServicesInner? _$v;

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

  RegisterInputAnyOf1ServicesInnerDepositModeEnum? _depositMode;
  RegisterInputAnyOf1ServicesInnerDepositModeEnum? get depositMode =>
      _$this._depositMode;
  set depositMode(
          RegisterInputAnyOf1ServicesInnerDepositModeEnum? depositMode) =>
      _$this._depositMode = depositMode;

  int? _depositAmountXof;
  int? get depositAmountXof => _$this._depositAmountXof;
  set depositAmountXof(int? depositAmountXof) =>
      _$this._depositAmountXof = depositAmountXof;

  int? _depositPercent;
  int? get depositPercent => _$this._depositPercent;
  set depositPercent(int? depositPercent) =>
      _$this._depositPercent = depositPercent;

  RegisterInputAnyOf1ServicesInnerBuilder() {
    RegisterInputAnyOf1ServicesInner._defaults(this);
  }

  RegisterInputAnyOf1ServicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(RegisterInputAnyOf1ServicesInner other) {
    _$v = other as _$RegisterInputAnyOf1ServicesInner;
  }

  @override
  void update(void Function(RegisterInputAnyOf1ServicesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterInputAnyOf1ServicesInner build() => _build();

  _$RegisterInputAnyOf1ServicesInner _build() {
    final _$result = _$v ??
        _$RegisterInputAnyOf1ServicesInner._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'RegisterInputAnyOf1ServicesInner', 'name'),
          durationMinutes: BuiltValueNullFieldError.checkNotNull(
              durationMinutes,
              r'RegisterInputAnyOf1ServicesInner',
              'durationMinutes'),
          priceXof: BuiltValueNullFieldError.checkNotNull(
              priceXof, r'RegisterInputAnyOf1ServicesInner', 'priceXof'),
          depositMode: BuiltValueNullFieldError.checkNotNull(
              depositMode, r'RegisterInputAnyOf1ServicesInner', 'depositMode'),
          depositAmountXof: depositAmountXof,
          depositPercent: depositPercent,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
