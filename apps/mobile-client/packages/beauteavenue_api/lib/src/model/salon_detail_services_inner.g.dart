// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_detail_services_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalonDetailServicesInner extends SalonDetailServicesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final int durationMinutes;
  @override
  final num priceXof;
  @override
  final num? depositRequiredXof;

  factory _$SalonDetailServicesInner(
          [void Function(SalonDetailServicesInnerBuilder)? updates]) =>
      (SalonDetailServicesInnerBuilder()..update(updates))._build();

  _$SalonDetailServicesInner._(
      {required this.id,
      required this.name,
      required this.category,
      required this.durationMinutes,
      required this.priceXof,
      this.depositRequiredXof})
      : super._();
  @override
  SalonDetailServicesInner rebuild(
          void Function(SalonDetailServicesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalonDetailServicesInnerBuilder toBuilder() =>
      SalonDetailServicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalonDetailServicesInner &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        durationMinutes == other.durationMinutes &&
        priceXof == other.priceXof &&
        depositRequiredXof == other.depositRequiredXof;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, durationMinutes.hashCode);
    _$hash = $jc(_$hash, priceXof.hashCode);
    _$hash = $jc(_$hash, depositRequiredXof.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalonDetailServicesInner')
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('durationMinutes', durationMinutes)
          ..add('priceXof', priceXof)
          ..add('depositRequiredXof', depositRequiredXof))
        .toString();
  }
}

class SalonDetailServicesInnerBuilder
    implements
        Builder<SalonDetailServicesInner, SalonDetailServicesInnerBuilder> {
  _$SalonDetailServicesInner? _$v;

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

  num? _priceXof;
  num? get priceXof => _$this._priceXof;
  set priceXof(num? priceXof) => _$this._priceXof = priceXof;

  num? _depositRequiredXof;
  num? get depositRequiredXof => _$this._depositRequiredXof;
  set depositRequiredXof(num? depositRequiredXof) =>
      _$this._depositRequiredXof = depositRequiredXof;

  SalonDetailServicesInnerBuilder() {
    SalonDetailServicesInner._defaults(this);
  }

  SalonDetailServicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _durationMinutes = $v.durationMinutes;
      _priceXof = $v.priceXof;
      _depositRequiredXof = $v.depositRequiredXof;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalonDetailServicesInner other) {
    _$v = other as _$SalonDetailServicesInner;
  }

  @override
  void update(void Function(SalonDetailServicesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalonDetailServicesInner build() => _build();

  _$SalonDetailServicesInner _build() {
    final _$result = _$v ??
        _$SalonDetailServicesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SalonDetailServicesInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SalonDetailServicesInner', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'SalonDetailServicesInner', 'category'),
          durationMinutes: BuiltValueNullFieldError.checkNotNull(
              durationMinutes, r'SalonDetailServicesInner', 'durationMinutes'),
          priceXof: BuiltValueNullFieldError.checkNotNull(
              priceXof, r'SalonDetailServicesInner', 'priceXof'),
          depositRequiredXof: depositRequiredXof,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
