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
  final String addressLine1;
  @override
  final String? addressLine2;
  @override
  final String city;
  @override
  final String? region;
  @override
  final String? phone;
  @override
  final bool isDefault;
  @override
  final String createdAt;

  factory _$ApiV1MeAddressesGet200ResponseItemsInner(
          [void Function(ApiV1MeAddressesGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (ApiV1MeAddressesGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$ApiV1MeAddressesGet200ResponseItemsInner._(
      {required this.id,
      required this.label,
      required this.addressLine1,
      this.addressLine2,
      required this.city,
      this.region,
      this.phone,
      required this.isDefault,
      required this.createdAt})
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
        addressLine1 == other.addressLine1 &&
        addressLine2 == other.addressLine2 &&
        city == other.city &&
        region == other.region &&
        phone == other.phone &&
        isDefault == other.isDefault &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, addressLine1.hashCode);
    _$hash = $jc(_$hash, addressLine2.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, region.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1MeAddressesGet200ResponseItemsInner')
          ..add('id', id)
          ..add('label', label)
          ..add('addressLine1', addressLine1)
          ..add('addressLine2', addressLine2)
          ..add('city', city)
          ..add('region', region)
          ..add('phone', phone)
          ..add('isDefault', isDefault)
          ..add('createdAt', createdAt))
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

  String? _addressLine1;
  String? get addressLine1 => _$this._addressLine1;
  set addressLine1(String? addressLine1) => _$this._addressLine1 = addressLine1;

  String? _addressLine2;
  String? get addressLine2 => _$this._addressLine2;
  set addressLine2(String? addressLine2) => _$this._addressLine2 = addressLine2;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _region;
  String? get region => _$this._region;
  set region(String? region) => _$this._region = region;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  bool? _isDefault;
  bool? get isDefault => _$this._isDefault;
  set isDefault(bool? isDefault) => _$this._isDefault = isDefault;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  ApiV1MeAddressesGet200ResponseItemsInnerBuilder() {
    ApiV1MeAddressesGet200ResponseItemsInner._defaults(this);
  }

  ApiV1MeAddressesGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _addressLine1 = $v.addressLine1;
      _addressLine2 = $v.addressLine2;
      _city = $v.city;
      _region = $v.region;
      _phone = $v.phone;
      _isDefault = $v.isDefault;
      _createdAt = $v.createdAt;
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
          addressLine1: BuiltValueNullFieldError.checkNotNull(addressLine1,
              r'ApiV1MeAddressesGet200ResponseItemsInner', 'addressLine1'),
          addressLine2: addressLine2,
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'ApiV1MeAddressesGet200ResponseItemsInner', 'city'),
          region: region,
          phone: phone,
          isDefault: BuiltValueNullFieldError.checkNotNull(isDefault,
              r'ApiV1MeAddressesGet200ResponseItemsInner', 'isDefault'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'ApiV1MeAddressesGet200ResponseItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
