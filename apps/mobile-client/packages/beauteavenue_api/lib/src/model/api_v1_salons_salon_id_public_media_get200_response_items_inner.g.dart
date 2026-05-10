// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_salons_salon_id_public_media_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner
    extends ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final String publicUrl;
  @override
  final String purpose;
  @override
  final String mimeType;
  @override
  final int displayOrder;
  @override
  final DateTime createdAt;

  factory _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner(
          [void Function(
                  ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder()
            ..update(updates))
          ._build();

  _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner._(
      {required this.id,
      required this.publicUrl,
      required this.purpose,
      required this.mimeType,
      required this.displayOrder,
      required this.createdAt})
      : super._();
  @override
  ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner rebuild(
          void Function(
                  ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder toBuilder() =>
      ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner &&
        id == other.id &&
        publicUrl == other.publicUrl &&
        purpose == other.purpose &&
        mimeType == other.mimeType &&
        displayOrder == other.displayOrder &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, publicUrl.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner')
          ..add('id', id)
          ..add('publicUrl', publicUrl)
          ..add('purpose', purpose)
          ..add('mimeType', mimeType)
          ..add('displayOrder', displayOrder)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder
    implements
        Builder<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner,
            ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder> {
  _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _publicUrl;
  String? get publicUrl => _$this._publicUrl;
  set publicUrl(String? publicUrl) => _$this._publicUrl = publicUrl;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder() {
    ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner._defaults(this);
  }

  ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _publicUrl = $v.publicUrl;
      _purpose = $v.purpose;
      _mimeType = $v.mimeType;
      _displayOrder = $v.displayOrder;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner other) {
    _$v = other as _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(
              ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner build() => _build();

  _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner _build() {
    final _$result = _$v ??
        _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(id,
              r'ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner', 'id'),
          publicUrl: BuiltValueNullFieldError.checkNotNull(
              publicUrl,
              r'ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner',
              'publicUrl'),
          purpose: BuiltValueNullFieldError.checkNotNull(
              purpose,
              r'ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner',
              'purpose'),
          mimeType: BuiltValueNullFieldError.checkNotNull(
              mimeType,
              r'ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner',
              'mimeType'),
          displayOrder: BuiltValueNullFieldError.checkNotNull(
              displayOrder,
              r'ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner',
              'displayOrder'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner',
              'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
