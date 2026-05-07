// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_me_addresses_address_id_patch_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MeAddressesAddressIdPatchRequest
    extends ApiV1MeAddressesAddressIdPatchRequest {
  @override
  final String? label;
  @override
  final String? addressLine1;
  @override
  final String? addressLine2;
  @override
  final String? city;
  @override
  final String? region;
  @override
  final String? phone;
  @override
  final bool? isDefault;

  factory _$ApiV1MeAddressesAddressIdPatchRequest(
          [void Function(ApiV1MeAddressesAddressIdPatchRequestBuilder)?
              updates]) =>
      (ApiV1MeAddressesAddressIdPatchRequestBuilder()..update(updates))
          ._build();

  _$ApiV1MeAddressesAddressIdPatchRequest._(
      {this.label,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.region,
      this.phone,
      this.isDefault})
      : super._();
  @override
  ApiV1MeAddressesAddressIdPatchRequest rebuild(
          void Function(ApiV1MeAddressesAddressIdPatchRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MeAddressesAddressIdPatchRequestBuilder toBuilder() =>
      ApiV1MeAddressesAddressIdPatchRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MeAddressesAddressIdPatchRequest &&
        label == other.label &&
        addressLine1 == other.addressLine1 &&
        addressLine2 == other.addressLine2 &&
        city == other.city &&
        region == other.region &&
        phone == other.phone &&
        isDefault == other.isDefault;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, addressLine1.hashCode);
    _$hash = $jc(_$hash, addressLine2.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, region.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1MeAddressesAddressIdPatchRequest')
          ..add('label', label)
          ..add('addressLine1', addressLine1)
          ..add('addressLine2', addressLine2)
          ..add('city', city)
          ..add('region', region)
          ..add('phone', phone)
          ..add('isDefault', isDefault))
        .toString();
  }
}

class ApiV1MeAddressesAddressIdPatchRequestBuilder
    implements
        Builder<ApiV1MeAddressesAddressIdPatchRequest,
            ApiV1MeAddressesAddressIdPatchRequestBuilder> {
  _$ApiV1MeAddressesAddressIdPatchRequest? _$v;

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

  ApiV1MeAddressesAddressIdPatchRequestBuilder() {
    ApiV1MeAddressesAddressIdPatchRequest._defaults(this);
  }

  ApiV1MeAddressesAddressIdPatchRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _addressLine1 = $v.addressLine1;
      _addressLine2 = $v.addressLine2;
      _city = $v.city;
      _region = $v.region;
      _phone = $v.phone;
      _isDefault = $v.isDefault;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MeAddressesAddressIdPatchRequest other) {
    _$v = other as _$ApiV1MeAddressesAddressIdPatchRequest;
  }

  @override
  void update(
      void Function(ApiV1MeAddressesAddressIdPatchRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MeAddressesAddressIdPatchRequest build() => _build();

  _$ApiV1MeAddressesAddressIdPatchRequest _build() {
    final _$result = _$v ??
        _$ApiV1MeAddressesAddressIdPatchRequest._(
          label: label,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          city: city,
          region: region,
          phone: phone,
          isDefault: isDefault,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
