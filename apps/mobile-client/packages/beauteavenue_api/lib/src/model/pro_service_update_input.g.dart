// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_service_update_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProServiceUpdateInputDepositModeEnum
    _$proServiceUpdateInputDepositModeEnum_none =
    const ProServiceUpdateInputDepositModeEnum._('none');
const ProServiceUpdateInputDepositModeEnum
    _$proServiceUpdateInputDepositModeEnum_fixed =
    const ProServiceUpdateInputDepositModeEnum._('fixed');
const ProServiceUpdateInputDepositModeEnum
    _$proServiceUpdateInputDepositModeEnum_percent =
    const ProServiceUpdateInputDepositModeEnum._('percent');

ProServiceUpdateInputDepositModeEnum
    _$proServiceUpdateInputDepositModeEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$proServiceUpdateInputDepositModeEnum_none;
    case 'fixed':
      return _$proServiceUpdateInputDepositModeEnum_fixed;
    case 'percent':
      return _$proServiceUpdateInputDepositModeEnum_percent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProServiceUpdateInputDepositModeEnum>
    _$proServiceUpdateInputDepositModeEnumValues = BuiltSet<
        ProServiceUpdateInputDepositModeEnum>(const <ProServiceUpdateInputDepositModeEnum>[
  _$proServiceUpdateInputDepositModeEnum_none,
  _$proServiceUpdateInputDepositModeEnum_fixed,
  _$proServiceUpdateInputDepositModeEnum_percent,
]);

Serializer<ProServiceUpdateInputDepositModeEnum>
    _$proServiceUpdateInputDepositModeEnumSerializer =
    _$ProServiceUpdateInputDepositModeEnumSerializer();

class _$ProServiceUpdateInputDepositModeEnumSerializer
    implements PrimitiveSerializer<ProServiceUpdateInputDepositModeEnum> {
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
    ProServiceUpdateInputDepositModeEnum
  ];
  @override
  final String wireName = 'ProServiceUpdateInputDepositModeEnum';

  @override
  Object serialize(
          Serializers serializers, ProServiceUpdateInputDepositModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProServiceUpdateInputDepositModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProServiceUpdateInputDepositModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProServiceUpdateInput extends ProServiceUpdateInput {
  @override
  final String? name;
  @override
  final String? category;
  @override
  final int? durationMinutes;
  @override
  final int? priceXof;
  @override
  final ProServiceUpdateInputDepositModeEnum? depositMode;
  @override
  final int? depositAmountXof;
  @override
  final int? depositPercent;

  factory _$ProServiceUpdateInput(
          [void Function(ProServiceUpdateInputBuilder)? updates]) =>
      (ProServiceUpdateInputBuilder()..update(updates))._build();

  _$ProServiceUpdateInput._(
      {this.name,
      this.category,
      this.durationMinutes,
      this.priceXof,
      this.depositMode,
      this.depositAmountXof,
      this.depositPercent})
      : super._();
  @override
  ProServiceUpdateInput rebuild(
          void Function(ProServiceUpdateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProServiceUpdateInputBuilder toBuilder() =>
      ProServiceUpdateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProServiceUpdateInput &&
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
    return (newBuiltValueToStringHelper(r'ProServiceUpdateInput')
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

class ProServiceUpdateInputBuilder
    implements Builder<ProServiceUpdateInput, ProServiceUpdateInputBuilder> {
  _$ProServiceUpdateInput? _$v;

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

  ProServiceUpdateInputDepositModeEnum? _depositMode;
  ProServiceUpdateInputDepositModeEnum? get depositMode => _$this._depositMode;
  set depositMode(ProServiceUpdateInputDepositModeEnum? depositMode) =>
      _$this._depositMode = depositMode;

  int? _depositAmountXof;
  int? get depositAmountXof => _$this._depositAmountXof;
  set depositAmountXof(int? depositAmountXof) =>
      _$this._depositAmountXof = depositAmountXof;

  int? _depositPercent;
  int? get depositPercent => _$this._depositPercent;
  set depositPercent(int? depositPercent) =>
      _$this._depositPercent = depositPercent;

  ProServiceUpdateInputBuilder() {
    ProServiceUpdateInput._defaults(this);
  }

  ProServiceUpdateInputBuilder get _$this {
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
  void replace(ProServiceUpdateInput other) {
    _$v = other as _$ProServiceUpdateInput;
  }

  @override
  void update(void Function(ProServiceUpdateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProServiceUpdateInput build() => _build();

  _$ProServiceUpdateInput _build() {
    final _$result = _$v ??
        _$ProServiceUpdateInput._(
          name: name,
          category: category,
          durationMinutes: durationMinutes,
          priceXof: priceXof,
          depositMode: depositMode,
          depositAmountXof: depositAmountXof,
          depositPercent: depositPercent,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
