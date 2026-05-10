// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_media_media_id_reject_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminMediaMediaIdRejectPostRequest
    extends ApiV1AdminMediaMediaIdRejectPostRequest {
  @override
  final String reason;

  factory _$ApiV1AdminMediaMediaIdRejectPostRequest(
          [void Function(ApiV1AdminMediaMediaIdRejectPostRequestBuilder)?
              updates]) =>
      (ApiV1AdminMediaMediaIdRejectPostRequestBuilder()..update(updates))
          ._build();

  _$ApiV1AdminMediaMediaIdRejectPostRequest._({required this.reason})
      : super._();
  @override
  ApiV1AdminMediaMediaIdRejectPostRequest rebuild(
          void Function(ApiV1AdminMediaMediaIdRejectPostRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminMediaMediaIdRejectPostRequestBuilder toBuilder() =>
      ApiV1AdminMediaMediaIdRejectPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminMediaMediaIdRejectPostRequest &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminMediaMediaIdRejectPostRequest')
          ..add('reason', reason))
        .toString();
  }
}

class ApiV1AdminMediaMediaIdRejectPostRequestBuilder
    implements
        Builder<ApiV1AdminMediaMediaIdRejectPostRequest,
            ApiV1AdminMediaMediaIdRejectPostRequestBuilder> {
  _$ApiV1AdminMediaMediaIdRejectPostRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ApiV1AdminMediaMediaIdRejectPostRequestBuilder() {
    ApiV1AdminMediaMediaIdRejectPostRequest._defaults(this);
  }

  ApiV1AdminMediaMediaIdRejectPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminMediaMediaIdRejectPostRequest other) {
    _$v = other as _$ApiV1AdminMediaMediaIdRejectPostRequest;
  }

  @override
  void update(
      void Function(ApiV1AdminMediaMediaIdRejectPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminMediaMediaIdRejectPostRequest build() => _build();

  _$ApiV1AdminMediaMediaIdRejectPostRequest _build() {
    final _$result = _$v ??
        _$ApiV1AdminMediaMediaIdRejectPostRequest._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ApiV1AdminMediaMediaIdRejectPostRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
