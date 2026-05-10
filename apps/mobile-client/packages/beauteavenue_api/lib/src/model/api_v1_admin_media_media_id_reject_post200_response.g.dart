// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_media_media_id_reject_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminMediaMediaIdRejectPost200Response
    extends ApiV1AdminMediaMediaIdRejectPost200Response {
  @override
  final bool rejected;

  factory _$ApiV1AdminMediaMediaIdRejectPost200Response(
          [void Function(ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder)?
              updates]) =>
      (ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder()..update(updates))
          ._build();

  _$ApiV1AdminMediaMediaIdRejectPost200Response._({required this.rejected})
      : super._();
  @override
  ApiV1AdminMediaMediaIdRejectPost200Response rebuild(
          void Function(ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder toBuilder() =>
      ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminMediaMediaIdRejectPost200Response &&
        rejected == other.rejected;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rejected.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminMediaMediaIdRejectPost200Response')
          ..add('rejected', rejected))
        .toString();
  }
}

class ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder
    implements
        Builder<ApiV1AdminMediaMediaIdRejectPost200Response,
            ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder> {
  _$ApiV1AdminMediaMediaIdRejectPost200Response? _$v;

  bool? _rejected;
  bool? get rejected => _$this._rejected;
  set rejected(bool? rejected) => _$this._rejected = rejected;

  ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder() {
    ApiV1AdminMediaMediaIdRejectPost200Response._defaults(this);
  }

  ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rejected = $v.rejected;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminMediaMediaIdRejectPost200Response other) {
    _$v = other as _$ApiV1AdminMediaMediaIdRejectPost200Response;
  }

  @override
  void update(
      void Function(ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminMediaMediaIdRejectPost200Response build() => _build();

  _$ApiV1AdminMediaMediaIdRejectPost200Response _build() {
    final _$result = _$v ??
        _$ApiV1AdminMediaMediaIdRejectPost200Response._(
          rejected: BuiltValueNullFieldError.checkNotNull(rejected,
              r'ApiV1AdminMediaMediaIdRejectPost200Response', 'rejected'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
