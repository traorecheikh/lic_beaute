// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_config_settings_key_patch_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminConfigSettingsKeyPatchRequest
    extends ApiV1AdminConfigSettingsKeyPatchRequest {
  @override
  final String value;

  factory _$ApiV1AdminConfigSettingsKeyPatchRequest(
          [void Function(ApiV1AdminConfigSettingsKeyPatchRequestBuilder)?
              updates]) =>
      (ApiV1AdminConfigSettingsKeyPatchRequestBuilder()..update(updates))
          ._build();

  _$ApiV1AdminConfigSettingsKeyPatchRequest._({required this.value})
      : super._();
  @override
  ApiV1AdminConfigSettingsKeyPatchRequest rebuild(
          void Function(ApiV1AdminConfigSettingsKeyPatchRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminConfigSettingsKeyPatchRequestBuilder toBuilder() =>
      ApiV1AdminConfigSettingsKeyPatchRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminConfigSettingsKeyPatchRequest &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminConfigSettingsKeyPatchRequest')
          ..add('value', value))
        .toString();
  }
}

class ApiV1AdminConfigSettingsKeyPatchRequestBuilder
    implements
        Builder<ApiV1AdminConfigSettingsKeyPatchRequest,
            ApiV1AdminConfigSettingsKeyPatchRequestBuilder> {
  _$ApiV1AdminConfigSettingsKeyPatchRequest? _$v;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  ApiV1AdminConfigSettingsKeyPatchRequestBuilder() {
    ApiV1AdminConfigSettingsKeyPatchRequest._defaults(this);
  }

  ApiV1AdminConfigSettingsKeyPatchRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminConfigSettingsKeyPatchRequest other) {
    _$v = other as _$ApiV1AdminConfigSettingsKeyPatchRequest;
  }

  @override
  void update(
      void Function(ApiV1AdminConfigSettingsKeyPatchRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminConfigSettingsKeyPatchRequest build() => _build();

  _$ApiV1AdminConfigSettingsKeyPatchRequest _build() {
    final _$result = _$v ??
        _$ApiV1AdminConfigSettingsKeyPatchRequest._(
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'ApiV1AdminConfigSettingsKeyPatchRequest', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
