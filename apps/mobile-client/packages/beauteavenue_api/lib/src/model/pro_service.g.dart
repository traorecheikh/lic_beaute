// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_service.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProServiceDepositModeEnum _$proServiceDepositModeEnum_none =
    const ProServiceDepositModeEnum._('none');
const ProServiceDepositModeEnum _$proServiceDepositModeEnum_fixed =
    const ProServiceDepositModeEnum._('fixed');
const ProServiceDepositModeEnum _$proServiceDepositModeEnum_percent =
    const ProServiceDepositModeEnum._('percent');

ProServiceDepositModeEnum _$proServiceDepositModeEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$proServiceDepositModeEnum_none;
    case 'fixed':
      return _$proServiceDepositModeEnum_fixed;
    case 'percent':
      return _$proServiceDepositModeEnum_percent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProServiceDepositModeEnum> _$proServiceDepositModeEnumValues =
    BuiltSet<ProServiceDepositModeEnum>(const <ProServiceDepositModeEnum>[
  _$proServiceDepositModeEnum_none,
  _$proServiceDepositModeEnum_fixed,
  _$proServiceDepositModeEnum_percent,
]);

Serializer<ProServiceDepositModeEnum> _$proServiceDepositModeEnumSerializer =
    _$ProServiceDepositModeEnumSerializer();

class _$ProServiceDepositModeEnumSerializer
    implements PrimitiveSerializer<ProServiceDepositModeEnum> {
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
  final Iterable<Type> types = const <Type>[ProServiceDepositModeEnum];
  @override
  final String wireName = 'ProServiceDepositModeEnum';

  @override
  Object serialize(Serializers serializers, ProServiceDepositModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProServiceDepositModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProServiceDepositModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProService extends ProService {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final int durationMinutes;
  @override
  final int priceXof;
  @override
  final ProServiceDepositModeEnum depositMode;
  @override
  final int? depositAmountXof;
  @override
  final int? depositPercent;
  @override
  final bool isActive;
  @override
  final int displayOrder;

  factory _$ProService([void Function(ProServiceBuilder)? updates]) =>
      (ProServiceBuilder()..update(updates))._build();

  _$ProService._(
      {required this.id,
      required this.name,
      required this.category,
      required this.durationMinutes,
      required this.priceXof,
      required this.depositMode,
      this.depositAmountXof,
      this.depositPercent,
      required this.isActive,
      required this.displayOrder})
      : super._();
  @override
  ProService rebuild(void Function(ProServiceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProServiceBuilder toBuilder() => ProServiceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProService &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        durationMinutes == other.durationMinutes &&
        priceXof == other.priceXof &&
        depositMode == other.depositMode &&
        depositAmountXof == other.depositAmountXof &&
        depositPercent == other.depositPercent &&
        isActive == other.isActive &&
        displayOrder == other.displayOrder;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, durationMinutes.hashCode);
    _$hash = $jc(_$hash, priceXof.hashCode);
    _$hash = $jc(_$hash, depositMode.hashCode);
    _$hash = $jc(_$hash, depositAmountXof.hashCode);
    _$hash = $jc(_$hash, depositPercent.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProService')
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('durationMinutes', durationMinutes)
          ..add('priceXof', priceXof)
          ..add('depositMode', depositMode)
          ..add('depositAmountXof', depositAmountXof)
          ..add('depositPercent', depositPercent)
          ..add('isActive', isActive)
          ..add('displayOrder', displayOrder))
        .toString();
  }
}

class ProServiceBuilder implements Builder<ProService, ProServiceBuilder> {
  _$ProService? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  ProServiceDepositModeEnum? _depositMode;
  ProServiceDepositModeEnum? get depositMode => _$this._depositMode;
  set depositMode(ProServiceDepositModeEnum? depositMode) =>
      _$this._depositMode = depositMode;

  int? _depositAmountXof;
  int? get depositAmountXof => _$this._depositAmountXof;
  set depositAmountXof(int? depositAmountXof) =>
      _$this._depositAmountXof = depositAmountXof;

  int? _depositPercent;
  int? get depositPercent => _$this._depositPercent;
  set depositPercent(int? depositPercent) =>
      _$this._depositPercent = depositPercent;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  ProServiceBuilder() {
    ProService._defaults(this);
  }

  ProServiceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _durationMinutes = $v.durationMinutes;
      _priceXof = $v.priceXof;
      _depositMode = $v.depositMode;
      _depositAmountXof = $v.depositAmountXof;
      _depositPercent = $v.depositPercent;
      _isActive = $v.isActive;
      _displayOrder = $v.displayOrder;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProService other) {
    _$v = other as _$ProService;
  }

  @override
  void update(void Function(ProServiceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProService build() => _build();

  _$ProService _build() {
    final _$result = _$v ??
        _$ProService._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ProService', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProService', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'ProService', 'category'),
          durationMinutes: BuiltValueNullFieldError.checkNotNull(
              durationMinutes, r'ProService', 'durationMinutes'),
          priceXof: BuiltValueNullFieldError.checkNotNull(
              priceXof, r'ProService', 'priceXof'),
          depositMode: BuiltValueNullFieldError.checkNotNull(
              depositMode, r'ProService', 'depositMode'),
          depositAmountXof: depositAmountXof,
          depositPercent: depositPercent,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'ProService', 'isActive'),
          displayOrder: BuiltValueNullFieldError.checkNotNull(
              displayOrder, r'ProService', 'displayOrder'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
