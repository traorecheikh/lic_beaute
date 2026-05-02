// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_service_create_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProServiceCreateInputDepositModeEnum
    _$proServiceCreateInputDepositModeEnum_none =
    const ProServiceCreateInputDepositModeEnum._('none');
const ProServiceCreateInputDepositModeEnum
    _$proServiceCreateInputDepositModeEnum_fixed =
    const ProServiceCreateInputDepositModeEnum._('fixed');
const ProServiceCreateInputDepositModeEnum
    _$proServiceCreateInputDepositModeEnum_percent =
    const ProServiceCreateInputDepositModeEnum._('percent');

ProServiceCreateInputDepositModeEnum
    _$proServiceCreateInputDepositModeEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$proServiceCreateInputDepositModeEnum_none;
    case 'fixed':
      return _$proServiceCreateInputDepositModeEnum_fixed;
    case 'percent':
      return _$proServiceCreateInputDepositModeEnum_percent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProServiceCreateInputDepositModeEnum>
    _$proServiceCreateInputDepositModeEnumValues = BuiltSet<
        ProServiceCreateInputDepositModeEnum>(const <ProServiceCreateInputDepositModeEnum>[
  _$proServiceCreateInputDepositModeEnum_none,
  _$proServiceCreateInputDepositModeEnum_fixed,
  _$proServiceCreateInputDepositModeEnum_percent,
]);

Serializer<ProServiceCreateInputDepositModeEnum>
    _$proServiceCreateInputDepositModeEnumSerializer =
    _$ProServiceCreateInputDepositModeEnumSerializer();

class _$ProServiceCreateInputDepositModeEnumSerializer
    implements PrimitiveSerializer<ProServiceCreateInputDepositModeEnum> {
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
    ProServiceCreateInputDepositModeEnum
  ];
  @override
  final String wireName = 'ProServiceCreateInputDepositModeEnum';

  @override
  Object serialize(
          Serializers serializers, ProServiceCreateInputDepositModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProServiceCreateInputDepositModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProServiceCreateInputDepositModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProServiceCreateInput extends ProServiceCreateInput {
  @override
  final String name;
  @override
  final String? category;
  @override
  final int durationMinutes;
  @override
  final int priceXof;
  @override
  final ProServiceCreateInputDepositModeEnum depositMode;
  @override
  final int? depositAmountXof;
  @override
  final int? depositPercent;

  factory _$ProServiceCreateInput(
          [void Function(ProServiceCreateInputBuilder)? updates]) =>
      (ProServiceCreateInputBuilder()..update(updates))._build();

  _$ProServiceCreateInput._(
      {required this.name,
      this.category,
      required this.durationMinutes,
      required this.priceXof,
      required this.depositMode,
      this.depositAmountXof,
      this.depositPercent})
      : super._();
  @override
  ProServiceCreateInput rebuild(
          void Function(ProServiceCreateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProServiceCreateInputBuilder toBuilder() =>
      ProServiceCreateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProServiceCreateInput &&
        name == other.name &&
        category == other.category &&
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
    _$hash = $jc(_$hash, category.hashCode);
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
    return (newBuiltValueToStringHelper(r'ProServiceCreateInput')
          ..add('name', name)
          ..add('category', category)
          ..add('durationMinutes', durationMinutes)
          ..add('priceXof', priceXof)
          ..add('depositMode', depositMode)
          ..add('depositAmountXof', depositAmountXof)
          ..add('depositPercent', depositPercent))
        .toString();
  }
}

class ProServiceCreateInputBuilder
    implements Builder<ProServiceCreateInput, ProServiceCreateInputBuilder> {
  _$ProServiceCreateInput? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _durationMinutes;
  int? get durationMinutes => _$this._durationMinutes;
  set durationMinutes(int? durationMinutes) =>
      _$this._durationMinutes = durationMinutes;

  int? _priceXof;
  int? get priceXof => _$this._priceXof;
  set priceXof(int? priceXof) => _$this._priceXof = priceXof;

  ProServiceCreateInputDepositModeEnum? _depositMode;
  ProServiceCreateInputDepositModeEnum? get depositMode => _$this._depositMode;
  set depositMode(ProServiceCreateInputDepositModeEnum? depositMode) =>
      _$this._depositMode = depositMode;

  int? _depositAmountXof;
  int? get depositAmountXof => _$this._depositAmountXof;
  set depositAmountXof(int? depositAmountXof) =>
      _$this._depositAmountXof = depositAmountXof;

  int? _depositPercent;
  int? get depositPercent => _$this._depositPercent;
  set depositPercent(int? depositPercent) =>
      _$this._depositPercent = depositPercent;

  ProServiceCreateInputBuilder() {
    ProServiceCreateInput._defaults(this);
  }

  ProServiceCreateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _category = $v.category;
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
  void replace(ProServiceCreateInput other) {
    _$v = other as _$ProServiceCreateInput;
  }

  @override
  void update(void Function(ProServiceCreateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProServiceCreateInput build() => _build();

  _$ProServiceCreateInput _build() {
    final _$result = _$v ??
        _$ProServiceCreateInput._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProServiceCreateInput', 'name'),
          category: category,
          durationMinutes: BuiltValueNullFieldError.checkNotNull(
              durationMinutes, r'ProServiceCreateInput', 'durationMinutes'),
          priceXof: BuiltValueNullFieldError.checkNotNull(
              priceXof, r'ProServiceCreateInput', 'priceXof'),
          depositMode: BuiltValueNullFieldError.checkNotNull(
              depositMode, r'ProServiceCreateInput', 'depositMode'),
          depositAmountXof: depositAmountXof,
          depositPercent: depositPercent,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
