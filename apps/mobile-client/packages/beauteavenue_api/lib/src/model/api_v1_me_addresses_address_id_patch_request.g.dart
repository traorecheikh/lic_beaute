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
  final String? street;
  @override
  final String? city;
  @override
  final bool? isDefault;

  factory _$ApiV1MeAddressesAddressIdPatchRequest(
          [void Function(ApiV1MeAddressesAddressIdPatchRequestBuilder)?
              updates]) =>
      (ApiV1MeAddressesAddressIdPatchRequestBuilder()..update(updates))
          ._build();

  _$ApiV1MeAddressesAddressIdPatchRequest._(
      {this.label, this.street, this.city, this.isDefault})
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
        street == other.street &&
        city == other.city &&
        isDefault == other.isDefault;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1MeAddressesAddressIdPatchRequest')
          ..add('label', label)
          ..add('street', street)
          ..add('city', city)
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

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

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
      _street = $v.street;
      _city = $v.city;
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
          street: street,
          city: city,
          isDefault: isDefault,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
