// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_media_pending_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminMediaPendingGet200ResponseItemsInner
    extends ApiV1AdminMediaPendingGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final String salonId;
  @override
  final String uploadedBy;
  @override
  final String objectKey;
  @override
  final String mimeType;
  @override
  final int sizeBytes;
  @override
  final String purpose;
  @override
  final String uploadStatus;
  @override
  final String reviewStatus;
  @override
  final String originalFilename;
  @override
  final DateTime createdAt;

  factory _$ApiV1AdminMediaPendingGet200ResponseItemsInner(
          [void Function(ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$ApiV1AdminMediaPendingGet200ResponseItemsInner._(
      {required this.id,
      required this.salonId,
      required this.uploadedBy,
      required this.objectKey,
      required this.mimeType,
      required this.sizeBytes,
      required this.purpose,
      required this.uploadStatus,
      required this.reviewStatus,
      required this.originalFilename,
      required this.createdAt})
      : super._();
  @override
  ApiV1AdminMediaPendingGet200ResponseItemsInner rebuild(
          void Function(ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder toBuilder() =>
      ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminMediaPendingGet200ResponseItemsInner &&
        id == other.id &&
        salonId == other.salonId &&
        uploadedBy == other.uploadedBy &&
        objectKey == other.objectKey &&
        mimeType == other.mimeType &&
        sizeBytes == other.sizeBytes &&
        purpose == other.purpose &&
        uploadStatus == other.uploadStatus &&
        reviewStatus == other.reviewStatus &&
        originalFilename == other.originalFilename &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, uploadedBy.hashCode);
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, uploadStatus.hashCode);
    _$hash = $jc(_$hash, reviewStatus.hashCode);
    _$hash = $jc(_$hash, originalFilename.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminMediaPendingGet200ResponseItemsInner')
          ..add('id', id)
          ..add('salonId', salonId)
          ..add('uploadedBy', uploadedBy)
          ..add('objectKey', objectKey)
          ..add('mimeType', mimeType)
          ..add('sizeBytes', sizeBytes)
          ..add('purpose', purpose)
          ..add('uploadStatus', uploadStatus)
          ..add('reviewStatus', reviewStatus)
          ..add('originalFilename', originalFilename)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder
    implements
        Builder<ApiV1AdminMediaPendingGet200ResponseItemsInner,
            ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder> {
  _$ApiV1AdminMediaPendingGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _uploadedBy;
  String? get uploadedBy => _$this._uploadedBy;
  set uploadedBy(String? uploadedBy) => _$this._uploadedBy = uploadedBy;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  String? _uploadStatus;
  String? get uploadStatus => _$this._uploadStatus;
  set uploadStatus(String? uploadStatus) => _$this._uploadStatus = uploadStatus;

  String? _reviewStatus;
  String? get reviewStatus => _$this._reviewStatus;
  set reviewStatus(String? reviewStatus) => _$this._reviewStatus = reviewStatus;

  String? _originalFilename;
  String? get originalFilename => _$this._originalFilename;
  set originalFilename(String? originalFilename) =>
      _$this._originalFilename = originalFilename;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder() {
    ApiV1AdminMediaPendingGet200ResponseItemsInner._defaults(this);
  }

  ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _salonId = $v.salonId;
      _uploadedBy = $v.uploadedBy;
      _objectKey = $v.objectKey;
      _mimeType = $v.mimeType;
      _sizeBytes = $v.sizeBytes;
      _purpose = $v.purpose;
      _uploadStatus = $v.uploadStatus;
      _reviewStatus = $v.reviewStatus;
      _originalFilename = $v.originalFilename;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminMediaPendingGet200ResponseItemsInner other) {
    _$v = other as _$ApiV1AdminMediaPendingGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminMediaPendingGet200ResponseItemsInner build() => _build();

  _$ApiV1AdminMediaPendingGet200ResponseItemsInner _build() {
    final _$result = _$v ??
        _$ApiV1AdminMediaPendingGet200ResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1AdminMediaPendingGet200ResponseItemsInner', 'id'),
          salonId: BuiltValueNullFieldError.checkNotNull(salonId,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner', 'salonId'),
          uploadedBy: BuiltValueNullFieldError.checkNotNull(uploadedBy,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner', 'uploadedBy'),
          objectKey: BuiltValueNullFieldError.checkNotNull(objectKey,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner', 'objectKey'),
          mimeType: BuiltValueNullFieldError.checkNotNull(mimeType,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner', 'mimeType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(sizeBytes,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner', 'sizeBytes'),
          purpose: BuiltValueNullFieldError.checkNotNull(purpose,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner', 'purpose'),
          uploadStatus: BuiltValueNullFieldError.checkNotNull(
              uploadStatus,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner',
              'uploadStatus'),
          reviewStatus: BuiltValueNullFieldError.checkNotNull(
              reviewStatus,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner',
              'reviewStatus'),
          originalFilename: BuiltValueNullFieldError.checkNotNull(
              originalFilename,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner',
              'originalFilename'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'ApiV1AdminMediaPendingGet200ResponseItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
