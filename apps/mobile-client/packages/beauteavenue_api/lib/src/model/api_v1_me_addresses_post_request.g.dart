// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_me_addresses_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MeAddressesPostRequest extends ApiV1MeAddressesPostRequest {
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
  final bool? isDefault;

  factory _$ApiV1MeAddressesPostRequest(
          [void Function(ApiV1MeAddressesPostRequestBuilder)? updates]) =>
      (ApiV1MeAddressesPostRequestBuilder()..update(updates))._build();

  _$ApiV1MeAddressesPostRequest._(
      {required this.label,
      required this.addressLine1,
      this.addressLine2,
      required this.city,
      this.region,
      this.phone,
      this.isDefault})
      : super._();
  @override
  ApiV1MeAddressesPostRequest rebuild(
          void Function(ApiV1MeAddressesPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MeAddressesPostRequestBuilder toBuilder() =>
      ApiV1MeAddressesPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MeAddressesPostRequest &&
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
    return (newBuiltValueToStringHelper(r'ApiV1MeAddressesPostRequest')
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

class ApiV1MeAddressesPostRequestBuilder
    implements
        Builder<ApiV1MeAddressesPostRequest,
            ApiV1MeAddressesPostRequestBuilder> {
  _$ApiV1MeAddressesPostRequest? _$v;

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

  ApiV1MeAddressesPostRequestBuilder() {
    ApiV1MeAddressesPostRequest._defaults(this);
  }

  ApiV1MeAddressesPostRequestBuilder get _$this {
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
  void replace(ApiV1MeAddressesPostRequest other) {
    _$v = other as _$ApiV1MeAddressesPostRequest;
  }

  @override
  void update(void Function(ApiV1MeAddressesPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MeAddressesPostRequest build() => _build();

  _$ApiV1MeAddressesPostRequest _build() {
    final _$result = _$v ??
        _$ApiV1MeAddressesPostRequest._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ApiV1MeAddressesPostRequest', 'label'),
          addressLine1: BuiltValueNullFieldError.checkNotNull(
              addressLine1, r'ApiV1MeAddressesPostRequest', 'addressLine1'),
          addressLine2: addressLine2,
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'ApiV1MeAddressesPostRequest', 'city'),
          region: region,
          phone: phone,
          isDefault: isDefault,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
