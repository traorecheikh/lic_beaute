// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_media_media_id_approve_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminMediaMediaIdApprovePost200Response
    extends ApiV1AdminMediaMediaIdApprovePost200Response {
  @override
  final bool approved;
  @override
  final String? publicUrl;

  factory _$ApiV1AdminMediaMediaIdApprovePost200Response(
          [void Function(ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder)?
              updates]) =>
      (ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder()..update(updates))
          ._build();

  _$ApiV1AdminMediaMediaIdApprovePost200Response._(
      {required this.approved, this.publicUrl})
      : super._();
  @override
  ApiV1AdminMediaMediaIdApprovePost200Response rebuild(
          void Function(ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder toBuilder() =>
      ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminMediaMediaIdApprovePost200Response &&
        approved == other.approved &&
        publicUrl == other.publicUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, approved.hashCode);
    _$hash = $jc(_$hash, publicUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminMediaMediaIdApprovePost200Response')
          ..add('approved', approved)
          ..add('publicUrl', publicUrl))
        .toString();
  }
}

class ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder
    implements
        Builder<ApiV1AdminMediaMediaIdApprovePost200Response,
            ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder> {
  _$ApiV1AdminMediaMediaIdApprovePost200Response? _$v;

  bool? _approved;
  bool? get approved => _$this._approved;
  set approved(bool? approved) => _$this._approved = approved;

  String? _publicUrl;
  String? get publicUrl => _$this._publicUrl;
  set publicUrl(String? publicUrl) => _$this._publicUrl = publicUrl;

  ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder() {
    ApiV1AdminMediaMediaIdApprovePost200Response._defaults(this);
  }

  ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _approved = $v.approved;
      _publicUrl = $v.publicUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminMediaMediaIdApprovePost200Response other) {
    _$v = other as _$ApiV1AdminMediaMediaIdApprovePost200Response;
  }

  @override
  void update(
      void Function(ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminMediaMediaIdApprovePost200Response build() => _build();

  _$ApiV1AdminMediaMediaIdApprovePost200Response _build() {
    final _$result = _$v ??
        _$ApiV1AdminMediaMediaIdApprovePost200Response._(
          approved: BuiltValueNullFieldError.checkNotNull(approved,
              r'ApiV1AdminMediaMediaIdApprovePost200Response', 'approved'),
          publicUrl: publicUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
