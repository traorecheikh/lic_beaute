// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_media_media_id_complete_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MediaMediaIdCompletePost200Response
    extends ApiV1MediaMediaIdCompletePost200Response {
  @override
  final String assetId;
  @override
  final String uploadStatus;
  @override
  final String reviewStatus;

  factory _$ApiV1MediaMediaIdCompletePost200Response(
          [void Function(ApiV1MediaMediaIdCompletePost200ResponseBuilder)?
              updates]) =>
      (ApiV1MediaMediaIdCompletePost200ResponseBuilder()..update(updates))
          ._build();

  _$ApiV1MediaMediaIdCompletePost200Response._(
      {required this.assetId,
      required this.uploadStatus,
      required this.reviewStatus})
      : super._();
  @override
  ApiV1MediaMediaIdCompletePost200Response rebuild(
          void Function(ApiV1MediaMediaIdCompletePost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MediaMediaIdCompletePost200ResponseBuilder toBuilder() =>
      ApiV1MediaMediaIdCompletePost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MediaMediaIdCompletePost200Response &&
        assetId == other.assetId &&
        uploadStatus == other.uploadStatus &&
        reviewStatus == other.reviewStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, uploadStatus.hashCode);
    _$hash = $jc(_$hash, reviewStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1MediaMediaIdCompletePost200Response')
          ..add('assetId', assetId)
          ..add('uploadStatus', uploadStatus)
          ..add('reviewStatus', reviewStatus))
        .toString();
  }
}

class ApiV1MediaMediaIdCompletePost200ResponseBuilder
    implements
        Builder<ApiV1MediaMediaIdCompletePost200Response,
            ApiV1MediaMediaIdCompletePost200ResponseBuilder> {
  _$ApiV1MediaMediaIdCompletePost200Response? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  String? _uploadStatus;
  String? get uploadStatus => _$this._uploadStatus;
  set uploadStatus(String? uploadStatus) => _$this._uploadStatus = uploadStatus;

  String? _reviewStatus;
  String? get reviewStatus => _$this._reviewStatus;
  set reviewStatus(String? reviewStatus) => _$this._reviewStatus = reviewStatus;

  ApiV1MediaMediaIdCompletePost200ResponseBuilder() {
    ApiV1MediaMediaIdCompletePost200Response._defaults(this);
  }

  ApiV1MediaMediaIdCompletePost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _uploadStatus = $v.uploadStatus;
      _reviewStatus = $v.reviewStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MediaMediaIdCompletePost200Response other) {
    _$v = other as _$ApiV1MediaMediaIdCompletePost200Response;
  }

  @override
  void update(
      void Function(ApiV1MediaMediaIdCompletePost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MediaMediaIdCompletePost200Response build() => _build();

  _$ApiV1MediaMediaIdCompletePost200Response _build() {
    final _$result = _$v ??
        _$ApiV1MediaMediaIdCompletePost200Response._(
          assetId: BuiltValueNullFieldError.checkNotNull(
              assetId, r'ApiV1MediaMediaIdCompletePost200Response', 'assetId'),
          uploadStatus: BuiltValueNullFieldError.checkNotNull(uploadStatus,
              r'ApiV1MediaMediaIdCompletePost200Response', 'uploadStatus'),
          reviewStatus: BuiltValueNullFieldError.checkNotNull(reviewStatus,
              r'ApiV1MediaMediaIdCompletePost200Response', 'reviewStatus'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
