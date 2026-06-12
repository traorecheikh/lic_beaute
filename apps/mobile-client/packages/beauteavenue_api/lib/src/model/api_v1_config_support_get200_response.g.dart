// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_config_support_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ConfigSupportGet200Response
    extends ApiV1ConfigSupportGet200Response {
  @override
  final String phone;
  @override
  final String email;

  factory _$ApiV1ConfigSupportGet200Response(
          [void Function(ApiV1ConfigSupportGet200ResponseBuilder)? updates]) =>
      (ApiV1ConfigSupportGet200ResponseBuilder()..update(updates))._build();

  _$ApiV1ConfigSupportGet200Response._(
      {required this.phone, required this.email})
      : super._();
  @override
  ApiV1ConfigSupportGet200Response rebuild(
          void Function(ApiV1ConfigSupportGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1ConfigSupportGet200ResponseBuilder toBuilder() =>
      ApiV1ConfigSupportGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ConfigSupportGet200Response &&
        phone == other.phone &&
        email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1ConfigSupportGet200Response')
          ..add('phone', phone)
          ..add('email', email))
        .toString();
  }
}

class ApiV1ConfigSupportGet200ResponseBuilder
    implements
        Builder<ApiV1ConfigSupportGet200Response,
            ApiV1ConfigSupportGet200ResponseBuilder> {
  _$ApiV1ConfigSupportGet200Response? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ApiV1ConfigSupportGet200ResponseBuilder() {
    ApiV1ConfigSupportGet200Response._defaults(this);
  }

  ApiV1ConfigSupportGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ConfigSupportGet200Response other) {
    _$v = other as _$ApiV1ConfigSupportGet200Response;
  }

  @override
  void update(void Function(ApiV1ConfigSupportGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ConfigSupportGet200Response build() => _build();

  _$ApiV1ConfigSupportGet200Response _build() {
    final _$result = _$v ??
        _$ApiV1ConfigSupportGet200Response._(
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'ApiV1ConfigSupportGet200Response', 'phone'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'ApiV1ConfigSupportGet200Response', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
