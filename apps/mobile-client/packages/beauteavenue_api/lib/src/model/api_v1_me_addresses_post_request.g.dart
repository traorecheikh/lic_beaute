// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_me_addresses_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MeAddressesPostRequest extends ApiV1MeAddressesPostRequest {
  @override
  final String label;
  @override
  final String? street;
  @override
  final String? city;

  factory _$ApiV1MeAddressesPostRequest(
          [void Function(ApiV1MeAddressesPostRequestBuilder)? updates]) =>
      (ApiV1MeAddressesPostRequestBuilder()..update(updates))._build();

  _$ApiV1MeAddressesPostRequest._({required this.label, this.street, this.city})
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
        street == other.street &&
        city == other.city;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1MeAddressesPostRequest')
          ..add('label', label)
          ..add('street', street)
          ..add('city', city))
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

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  ApiV1MeAddressesPostRequestBuilder() {
    ApiV1MeAddressesPostRequest._defaults(this);
  }

  ApiV1MeAddressesPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _street = $v.street;
      _city = $v.city;
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
          street: street,
          city: city,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
