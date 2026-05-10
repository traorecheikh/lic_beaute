// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_media_media_id_signed_view_url_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminMediaMediaIdSignedViewUrlPost200Response
    extends ApiV1AdminMediaMediaIdSignedViewUrlPost200Response {
  @override
  final String signedUrl;
  @override
  final DateTime expiresAt;

  factory _$ApiV1AdminMediaMediaIdSignedViewUrlPost200Response(
          [void Function(
                  ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder)?
              updates]) =>
      (ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder()
            ..update(updates))
          ._build();

  _$ApiV1AdminMediaMediaIdSignedViewUrlPost200Response._(
      {required this.signedUrl, required this.expiresAt})
      : super._();
  @override
  ApiV1AdminMediaMediaIdSignedViewUrlPost200Response rebuild(
          void Function(
                  ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder toBuilder() =>
      ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminMediaMediaIdSignedViewUrlPost200Response &&
        signedUrl == other.signedUrl &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, signedUrl.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminMediaMediaIdSignedViewUrlPost200Response')
          ..add('signedUrl', signedUrl)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder
    implements
        Builder<ApiV1AdminMediaMediaIdSignedViewUrlPost200Response,
            ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder> {
  _$ApiV1AdminMediaMediaIdSignedViewUrlPost200Response? _$v;

  String? _signedUrl;
  String? get signedUrl => _$this._signedUrl;
  set signedUrl(String? signedUrl) => _$this._signedUrl = signedUrl;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder() {
    ApiV1AdminMediaMediaIdSignedViewUrlPost200Response._defaults(this);
  }

  ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _signedUrl = $v.signedUrl;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminMediaMediaIdSignedViewUrlPost200Response other) {
    _$v = other as _$ApiV1AdminMediaMediaIdSignedViewUrlPost200Response;
  }

  @override
  void update(
      void Function(ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminMediaMediaIdSignedViewUrlPost200Response build() => _build();

  _$ApiV1AdminMediaMediaIdSignedViewUrlPost200Response _build() {
    final _$result = _$v ??
        _$ApiV1AdminMediaMediaIdSignedViewUrlPost200Response._(
          signedUrl: BuiltValueNullFieldError.checkNotNull(
              signedUrl,
              r'ApiV1AdminMediaMediaIdSignedViewUrlPost200Response',
              'signedUrl'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt,
              r'ApiV1AdminMediaMediaIdSignedViewUrlPost200Response',
              'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
