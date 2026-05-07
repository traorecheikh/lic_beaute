// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_media_upload_intent_post201_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MediaUploadIntentPost201Response
    extends ApiV1MediaUploadIntentPost201Response {
  @override
  final String assetId;
  @override
  final String uploadUrl;
  @override
  final String expiresAt;

  factory _$ApiV1MediaUploadIntentPost201Response(
          [void Function(ApiV1MediaUploadIntentPost201ResponseBuilder)?
              updates]) =>
      (ApiV1MediaUploadIntentPost201ResponseBuilder()..update(updates))
          ._build();

  _$ApiV1MediaUploadIntentPost201Response._(
      {required this.assetId, required this.uploadUrl, required this.expiresAt})
      : super._();
  @override
  ApiV1MediaUploadIntentPost201Response rebuild(
          void Function(ApiV1MediaUploadIntentPost201ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MediaUploadIntentPost201ResponseBuilder toBuilder() =>
      ApiV1MediaUploadIntentPost201ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MediaUploadIntentPost201Response &&
        assetId == other.assetId &&
        uploadUrl == other.uploadUrl &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, uploadUrl.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1MediaUploadIntentPost201Response')
          ..add('assetId', assetId)
          ..add('uploadUrl', uploadUrl)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class ApiV1MediaUploadIntentPost201ResponseBuilder
    implements
        Builder<ApiV1MediaUploadIntentPost201Response,
            ApiV1MediaUploadIntentPost201ResponseBuilder> {
  _$ApiV1MediaUploadIntentPost201Response? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  ApiV1MediaUploadIntentPost201ResponseBuilder() {
    ApiV1MediaUploadIntentPost201Response._defaults(this);
  }

  ApiV1MediaUploadIntentPost201ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _uploadUrl = $v.uploadUrl;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MediaUploadIntentPost201Response other) {
    _$v = other as _$ApiV1MediaUploadIntentPost201Response;
  }

  @override
  void update(
      void Function(ApiV1MediaUploadIntentPost201ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MediaUploadIntentPost201Response build() => _build();

  _$ApiV1MediaUploadIntentPost201Response _build() {
    final _$result = _$v ??
        _$ApiV1MediaUploadIntentPost201Response._(
          assetId: BuiltValueNullFieldError.checkNotNull(
              assetId, r'ApiV1MediaUploadIntentPost201Response', 'assetId'),
          uploadUrl: BuiltValueNullFieldError.checkNotNull(
              uploadUrl, r'ApiV1MediaUploadIntentPost201Response', 'uploadUrl'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'ApiV1MediaUploadIntentPost201Response', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
