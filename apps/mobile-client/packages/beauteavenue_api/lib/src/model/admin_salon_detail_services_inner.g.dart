// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salon_detail_services_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSalonDetailServicesInnerDepositModeEnum
    _$adminSalonDetailServicesInnerDepositModeEnum_none =
    const AdminSalonDetailServicesInnerDepositModeEnum._('none');
const AdminSalonDetailServicesInnerDepositModeEnum
    _$adminSalonDetailServicesInnerDepositModeEnum_fixed =
    const AdminSalonDetailServicesInnerDepositModeEnum._('fixed');
const AdminSalonDetailServicesInnerDepositModeEnum
    _$adminSalonDetailServicesInnerDepositModeEnum_percentage =
    const AdminSalonDetailServicesInnerDepositModeEnum._('percentage');

AdminSalonDetailServicesInnerDepositModeEnum
    _$adminSalonDetailServicesInnerDepositModeEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$adminSalonDetailServicesInnerDepositModeEnum_none;
    case 'fixed':
      return _$adminSalonDetailServicesInnerDepositModeEnum_fixed;
    case 'percentage':
      return _$adminSalonDetailServicesInnerDepositModeEnum_percentage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSalonDetailServicesInnerDepositModeEnum>
    _$adminSalonDetailServicesInnerDepositModeEnumValues = BuiltSet<
        AdminSalonDetailServicesInnerDepositModeEnum>(const <AdminSalonDetailServicesInnerDepositModeEnum>[
  _$adminSalonDetailServicesInnerDepositModeEnum_none,
  _$adminSalonDetailServicesInnerDepositModeEnum_fixed,
  _$adminSalonDetailServicesInnerDepositModeEnum_percentage,
]);

Serializer<AdminSalonDetailServicesInnerDepositModeEnum>
    _$adminSalonDetailServicesInnerDepositModeEnumSerializer =
    _$AdminSalonDetailServicesInnerDepositModeEnumSerializer();

class _$AdminSalonDetailServicesInnerDepositModeEnumSerializer
    implements
        PrimitiveSerializer<AdminSalonDetailServicesInnerDepositModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'none': 'none',
    'fixed': 'fixed',
    'percentage': 'percentage',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'none': 'none',
    'fixed': 'fixed',
    'percentage': 'percentage',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSalonDetailServicesInnerDepositModeEnum
  ];
  @override
  final String wireName = 'AdminSalonDetailServicesInnerDepositModeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSalonDetailServicesInnerDepositModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSalonDetailServicesInnerDepositModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSalonDetailServicesInnerDepositModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSalonDetailServicesInner extends AdminSalonDetailServicesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final int durationMinutes;
  @override
  final int priceXof;
  @override
  final AdminSalonDetailServicesInnerDepositModeEnum depositMode;
  @override
  final int? depositAmountXof;
  @override
  final int? depositPercent;

  factory _$AdminSalonDetailServicesInner(
          [void Function(AdminSalonDetailServicesInnerBuilder)? updates]) =>
      (AdminSalonDetailServicesInnerBuilder()..update(updates))._build();

  _$AdminSalonDetailServicesInner._(
      {required this.id,
      required this.name,
      required this.durationMinutes,
      required this.priceXof,
      required this.depositMode,
      this.depositAmountXof,
      this.depositPercent})
      : super._();
  @override
  AdminSalonDetailServicesInner rebuild(
          void Function(AdminSalonDetailServicesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSalonDetailServicesInnerBuilder toBuilder() =>
      AdminSalonDetailServicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSalonDetailServicesInner &&
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
    return (newBuiltValueToStringHelper(r'AdminSalonDetailServicesInner')
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

class AdminSalonDetailServicesInnerBuilder
    implements
        Builder<AdminSalonDetailServicesInner,
            AdminSalonDetailServicesInnerBuilder> {
  _$AdminSalonDetailServicesInner? _$v;

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

  AdminSalonDetailServicesInnerDepositModeEnum? _depositMode;
  AdminSalonDetailServicesInnerDepositModeEnum? get depositMode =>
      _$this._depositMode;
  set depositMode(AdminSalonDetailServicesInnerDepositModeEnum? depositMode) =>
      _$this._depositMode = depositMode;

  int? _depositAmountXof;
  int? get depositAmountXof => _$this._depositAmountXof;
  set depositAmountXof(int? depositAmountXof) =>
      _$this._depositAmountXof = depositAmountXof;

  int? _depositPercent;
  int? get depositPercent => _$this._depositPercent;
  set depositPercent(int? depositPercent) =>
      _$this._depositPercent = depositPercent;

  AdminSalonDetailServicesInnerBuilder() {
    AdminSalonDetailServicesInner._defaults(this);
  }

  AdminSalonDetailServicesInnerBuilder get _$this {
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
  void replace(AdminSalonDetailServicesInner other) {
    _$v = other as _$AdminSalonDetailServicesInner;
  }

  @override
  void update(void Function(AdminSalonDetailServicesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSalonDetailServicesInner build() => _build();

  _$AdminSalonDetailServicesInner _build() {
    final _$result = _$v ??
        _$AdminSalonDetailServicesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminSalonDetailServicesInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminSalonDetailServicesInner', 'name'),
          durationMinutes: BuiltValueNullFieldError.checkNotNull(
              durationMinutes,
              r'AdminSalonDetailServicesInner',
              'durationMinutes'),
          priceXof: BuiltValueNullFieldError.checkNotNull(
              priceXof, r'AdminSalonDetailServicesInner', 'priceXof'),
          depositMode: BuiltValueNullFieldError.checkNotNull(
              depositMode, r'AdminSalonDetailServicesInner', 'depositMode'),
          depositAmountXof: depositAmountXof,
          depositPercent: depositPercent,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
