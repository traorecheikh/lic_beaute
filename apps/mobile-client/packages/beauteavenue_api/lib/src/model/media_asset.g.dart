// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_asset.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MediaAsset extends MediaAsset {
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
  @override
  final String ownerType;
  @override
  final String ownerId;
  @override
  final DateTime? deletedAt;

  factory _$MediaAsset([void Function(MediaAssetBuilder)? updates]) =>
      (MediaAssetBuilder()..update(updates))._build();

  _$MediaAsset._(
      {required this.id,
      required this.publicUrl,
      required this.filename,
      required this.mimeType,
      required this.sizeBytes,
      required this.createdAt,
      required this.ownerType,
      required this.ownerId,
      this.deletedAt})
      : super._();
  @override
  MediaAsset rebuild(void Function(MediaAssetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaAssetBuilder toBuilder() => MediaAssetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaAsset &&
        id == other.id &&
        publicUrl == other.publicUrl &&
        filename == other.filename &&
        mimeType == other.mimeType &&
        sizeBytes == other.sizeBytes &&
        createdAt == other.createdAt &&
        ownerType == other.ownerType &&
        ownerId == other.ownerId &&
        deletedAt == other.deletedAt;
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
    _$hash = $jc(_$hash, ownerType.hashCode);
    _$hash = $jc(_$hash, ownerId.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaAsset')
          ..add('id', id)
          ..add('publicUrl', publicUrl)
          ..add('filename', filename)
          ..add('mimeType', mimeType)
          ..add('sizeBytes', sizeBytes)
          ..add('createdAt', createdAt)
          ..add('ownerType', ownerType)
          ..add('ownerId', ownerId)
          ..add('deletedAt', deletedAt))
        .toString();
  }
}

class MediaAssetBuilder implements Builder<MediaAsset, MediaAssetBuilder> {
  _$MediaAsset? _$v;

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

  String? _ownerType;
  String? get ownerType => _$this._ownerType;
  set ownerType(String? ownerType) => _$this._ownerType = ownerType;

  String? _ownerId;
  String? get ownerId => _$this._ownerId;
  set ownerId(String? ownerId) => _$this._ownerId = ownerId;

  DateTime? _deletedAt;
  DateTime? get deletedAt => _$this._deletedAt;
  set deletedAt(DateTime? deletedAt) => _$this._deletedAt = deletedAt;

  MediaAssetBuilder() {
    MediaAsset._defaults(this);
  }

  MediaAssetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _publicUrl = $v.publicUrl;
      _filename = $v.filename;
      _mimeType = $v.mimeType;
      _sizeBytes = $v.sizeBytes;
      _createdAt = $v.createdAt;
      _ownerType = $v.ownerType;
      _ownerId = $v.ownerId;
      _deletedAt = $v.deletedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaAsset other) {
    _$v = other as _$MediaAsset;
  }

  @override
  void update(void Function(MediaAssetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaAsset build() => _build();

  _$MediaAsset _build() {
    final _$result = _$v ??
        _$MediaAsset._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'MediaAsset', 'id'),
          publicUrl: BuiltValueNullFieldError.checkNotNull(
              publicUrl, r'MediaAsset', 'publicUrl'),
          filename: BuiltValueNullFieldError.checkNotNull(
              filename, r'MediaAsset', 'filename'),
          mimeType: BuiltValueNullFieldError.checkNotNull(
              mimeType, r'MediaAsset', 'mimeType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'MediaAsset', 'sizeBytes'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'MediaAsset', 'createdAt'),
          ownerType: BuiltValueNullFieldError.checkNotNull(
              ownerType, r'MediaAsset', 'ownerType'),
          ownerId: BuiltValueNullFieldError.checkNotNull(
              ownerId, r'MediaAsset', 'ownerId'),
          deletedAt: deletedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
