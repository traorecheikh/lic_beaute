// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_me_addresses_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MeAddressesGet200ResponseItemsInner
    extends ApiV1MeAddressesGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final String label;
  @override
  final String? street;
  @override
  final String? city;
  @override
  final bool isDefault;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  factory _$ApiV1MeAddressesGet200ResponseItemsInner(
          [void Function(ApiV1MeAddressesGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (ApiV1MeAddressesGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$ApiV1MeAddressesGet200ResponseItemsInner._(
      {required this.id,
      required this.label,
      this.street,
      this.city,
      required this.isDefault,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  ApiV1MeAddressesGet200ResponseItemsInner rebuild(
          void Function(ApiV1MeAddressesGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MeAddressesGet200ResponseItemsInnerBuilder toBuilder() =>
      ApiV1MeAddressesGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MeAddressesGet200ResponseItemsInner &&
        id == other.id &&
        label == other.label &&
        street == other.street &&
        city == other.city &&
        isDefault == other.isDefault &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1MeAddressesGet200ResponseItemsInner')
          ..add('id', id)
          ..add('label', label)
          ..add('street', street)
          ..add('city', city)
          ..add('isDefault', isDefault)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ApiV1MeAddressesGet200ResponseItemsInnerBuilder
    implements
        Builder<ApiV1MeAddressesGet200ResponseItemsInner,
            ApiV1MeAddressesGet200ResponseItemsInnerBuilder> {
  _$ApiV1MeAddressesGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  bool? _isDefault;
  bool? get isDefault => _$this._isDefault;
  set isDefault(bool? isDefault) => _$this._isDefault = isDefault;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  ApiV1MeAddressesGet200ResponseItemsInnerBuilder() {
    ApiV1MeAddressesGet200ResponseItemsInner._defaults(this);
  }

  ApiV1MeAddressesGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _street = $v.street;
      _city = $v.city;
      _isDefault = $v.isDefault;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MeAddressesGet200ResponseItemsInner other) {
    _$v = other as _$ApiV1MeAddressesGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(ApiV1MeAddressesGet200ResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MeAddressesGet200ResponseItemsInner build() => _build();

  _$ApiV1MeAddressesGet200ResponseItemsInner _build() {
    final _$result = _$v ??
        _$ApiV1MeAddressesGet200ResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1MeAddressesGet200ResponseItemsInner', 'id'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ApiV1MeAddressesGet200ResponseItemsInner', 'label'),
          street: street,
          city: city,
          isDefault: BuiltValueNullFieldError.checkNotNull(isDefault,
              r'ApiV1MeAddressesGet200ResponseItemsInner', 'isDefault'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'ApiV1MeAddressesGet200ResponseItemsInner', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
              r'ApiV1MeAddressesGet200ResponseItemsInner', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
