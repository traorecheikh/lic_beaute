// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MediaUploadResponse extends MediaUploadResponse {
  @override
  final String id;
  @override
  final String publicUrl;
  @override
  final String filename;
  @override
  final String mimeType;
  @override
  final int sizeBytes;
  @override
  final DateTime createdAt;

  factory _$MediaUploadResponse(
          [void Function(MediaUploadResponseBuilder)? updates]) =>
      (MediaUploadResponseBuilder()..update(updates))._build();

  _$MediaUploadResponse._(
      {required this.id,
      required this.publicUrl,
      required this.filename,
      required this.mimeType,
      required this.sizeBytes,
      required this.createdAt})
      : super._();
  @override
  MediaUploadResponse rebuild(
          void Function(MediaUploadResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaUploadResponseBuilder toBuilder() =>
      MediaUploadResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaUploadResponse &&
        id == other.id &&
        publicUrl == other.publicUrl &&
        filename == other.filename &&
        mimeType == other.mimeType &&
        sizeBytes == other.sizeBytes &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, publicUrl.hashCode);
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaUploadResponse')
          ..add('id', id)
          ..add('publicUrl', publicUrl)
          ..add('filename', filename)
          ..add('mimeType', mimeType)
          ..add('sizeBytes', sizeBytes)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class MediaUploadResponseBuilder
    implements Builder<MediaUploadResponse, MediaUploadResponseBuilder> {
  _$MediaUploadResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _publicUrl;
  String? get publicUrl => _$this._publicUrl;
  set publicUrl(String? publicUrl) => _$this._publicUrl = publicUrl;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MediaUploadResponseBuilder() {
    MediaUploadResponse._defaults(this);
  }

  MediaUploadResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _publicUrl = $v.publicUrl;
      _filename = $v.filename;
      _mimeType = $v.mimeType;
      _sizeBytes = $v.sizeBytes;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaUploadResponse other) {
    _$v = other as _$MediaUploadResponse;
  }

  @override
  void update(void Function(MediaUploadResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaUploadResponse build() => _build();

  _$MediaUploadResponse _build() {
    final _$result = _$v ??
        _$MediaUploadResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'MediaUploadResponse', 'id'),
          publicUrl: BuiltValueNullFieldError.checkNotNull(
              publicUrl, r'MediaUploadResponse', 'publicUrl'),
          filename: BuiltValueNullFieldError.checkNotNull(
              filename, r'MediaUploadResponse', 'filename'),
          mimeType: BuiltValueNullFieldError.checkNotNull(
              mimeType, r'MediaUploadResponse', 'mimeType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'MediaUploadResponse', 'sizeBytes'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'MediaUploadResponse', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
