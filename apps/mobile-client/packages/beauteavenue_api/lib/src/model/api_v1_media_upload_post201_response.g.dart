// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_media_upload_post201_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MediaUploadPost201Response
    extends ApiV1MediaUploadPost201Response {
  @override
  final String assetId;
  @override
  final String uploadStatus;
  @override
  final String reviewStatus;

  factory _$ApiV1MediaUploadPost201Response(
          [void Function(ApiV1MediaUploadPost201ResponseBuilder)? updates]) =>
      (ApiV1MediaUploadPost201ResponseBuilder()..update(updates))._build();

  _$ApiV1MediaUploadPost201Response._(
      {required this.assetId,
      required this.uploadStatus,
      required this.reviewStatus})
      : super._();
  @override
  ApiV1MediaUploadPost201Response rebuild(
          void Function(ApiV1MediaUploadPost201ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MediaUploadPost201ResponseBuilder toBuilder() =>
      ApiV1MediaUploadPost201ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MediaUploadPost201Response &&
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
    return (newBuiltValueToStringHelper(r'ApiV1MediaUploadPost201Response')
          ..add('assetId', assetId)
          ..add('uploadStatus', uploadStatus)
          ..add('reviewStatus', reviewStatus))
        .toString();
  }
}

class ApiV1MediaUploadPost201ResponseBuilder
    implements
        Builder<ApiV1MediaUploadPost201Response,
            ApiV1MediaUploadPost201ResponseBuilder> {
  _$ApiV1MediaUploadPost201Response? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  String? _uploadStatus;
  String? get uploadStatus => _$this._uploadStatus;
  set uploadStatus(String? uploadStatus) => _$this._uploadStatus = uploadStatus;

  String? _reviewStatus;
  String? get reviewStatus => _$this._reviewStatus;
  set reviewStatus(String? reviewStatus) => _$this._reviewStatus = reviewStatus;

  ApiV1MediaUploadPost201ResponseBuilder() {
    ApiV1MediaUploadPost201Response._defaults(this);
  }

  ApiV1MediaUploadPost201ResponseBuilder get _$this {
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
  void replace(ApiV1MediaUploadPost201Response other) {
    _$v = other as _$ApiV1MediaUploadPost201Response;
  }

  @override
  void update(void Function(ApiV1MediaUploadPost201ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MediaUploadPost201Response build() => _build();

  _$ApiV1MediaUploadPost201Response _build() {
    final _$result = _$v ??
        _$ApiV1MediaUploadPost201Response._(
          assetId: BuiltValueNullFieldError.checkNotNull(
              assetId, r'ApiV1MediaUploadPost201Response', 'assetId'),
          uploadStatus: BuiltValueNullFieldError.checkNotNull(
              uploadStatus, r'ApiV1MediaUploadPost201Response', 'uploadStatus'),
          reviewStatus: BuiltValueNullFieldError.checkNotNull(
              reviewStatus, r'ApiV1MediaUploadPost201Response', 'reviewStatus'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
