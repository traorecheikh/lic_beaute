// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_media_upload_intent_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1MediaUploadIntentPostRequestPurposeEnum
    _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonCover =
    const ApiV1MediaUploadIntentPostRequestPurposeEnum._('salonCover');
const ApiV1MediaUploadIntentPostRequestPurposeEnum
    _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonLogo =
    const ApiV1MediaUploadIntentPostRequestPurposeEnum._('salonLogo');
const ApiV1MediaUploadIntentPostRequestPurposeEnum
    _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonGallery =
    const ApiV1MediaUploadIntentPostRequestPurposeEnum._('salonGallery');
const ApiV1MediaUploadIntentPostRequestPurposeEnum
    _$apiV1MediaUploadIntentPostRequestPurposeEnum_kycDocument =
    const ApiV1MediaUploadIntentPostRequestPurposeEnum._('kycDocument');
const ApiV1MediaUploadIntentPostRequestPurposeEnum
    _$apiV1MediaUploadIntentPostRequestPurposeEnum_avatar =
    const ApiV1MediaUploadIntentPostRequestPurposeEnum._('avatar');

ApiV1MediaUploadIntentPostRequestPurposeEnum
    _$apiV1MediaUploadIntentPostRequestPurposeEnumValueOf(String name) {
  switch (name) {
    case 'salonCover':
      return _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonCover;
    case 'salonLogo':
      return _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonLogo;
    case 'salonGallery':
      return _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonGallery;
    case 'kycDocument':
      return _$apiV1MediaUploadIntentPostRequestPurposeEnum_kycDocument;
    case 'avatar':
      return _$apiV1MediaUploadIntentPostRequestPurposeEnum_avatar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1MediaUploadIntentPostRequestPurposeEnum>
    _$apiV1MediaUploadIntentPostRequestPurposeEnumValues = BuiltSet<
        ApiV1MediaUploadIntentPostRequestPurposeEnum>(const <ApiV1MediaUploadIntentPostRequestPurposeEnum>[
  _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonCover,
  _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonLogo,
  _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonGallery,
  _$apiV1MediaUploadIntentPostRequestPurposeEnum_kycDocument,
  _$apiV1MediaUploadIntentPostRequestPurposeEnum_avatar,
]);

Serializer<ApiV1MediaUploadIntentPostRequestPurposeEnum>
    _$apiV1MediaUploadIntentPostRequestPurposeEnumSerializer =
    _$ApiV1MediaUploadIntentPostRequestPurposeEnumSerializer();

class _$ApiV1MediaUploadIntentPostRequestPurposeEnumSerializer
    implements
        PrimitiveSerializer<ApiV1MediaUploadIntentPostRequestPurposeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'salonCover': 'salon_cover',
    'salonLogo': 'salon_logo',
    'salonGallery': 'salon_gallery',
    'kycDocument': 'kyc_document',
    'avatar': 'avatar',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'salon_cover': 'salonCover',
    'salon_logo': 'salonLogo',
    'salon_gallery': 'salonGallery',
    'kyc_document': 'kycDocument',
    'avatar': 'avatar',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApiV1MediaUploadIntentPostRequestPurposeEnum
  ];
  @override
  final String wireName = 'ApiV1MediaUploadIntentPostRequestPurposeEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1MediaUploadIntentPostRequestPurposeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1MediaUploadIntentPostRequestPurposeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1MediaUploadIntentPostRequestPurposeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1MediaUploadIntentPostRequest
    extends ApiV1MediaUploadIntentPostRequest {
  @override
  final String? salonId;
  @override
  final ApiV1MediaUploadIntentPostRequestPurposeEnum purpose;
  @override
  final String mimeType;
  @override
  final String originalFilename;
  @override
  final int sizeBytes;

  factory _$ApiV1MediaUploadIntentPostRequest(
          [void Function(ApiV1MediaUploadIntentPostRequestBuilder)? updates]) =>
      (ApiV1MediaUploadIntentPostRequestBuilder()..update(updates))._build();

  _$ApiV1MediaUploadIntentPostRequest._(
      {this.salonId,
      required this.purpose,
      required this.mimeType,
      required this.originalFilename,
      required this.sizeBytes})
      : super._();
  @override
  ApiV1MediaUploadIntentPostRequest rebuild(
          void Function(ApiV1MediaUploadIntentPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MediaUploadIntentPostRequestBuilder toBuilder() =>
      ApiV1MediaUploadIntentPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MediaUploadIntentPostRequest &&
        salonId == other.salonId &&
        purpose == other.purpose &&
        mimeType == other.mimeType &&
        originalFilename == other.originalFilename &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, originalFilename.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1MediaUploadIntentPostRequest')
          ..add('salonId', salonId)
          ..add('purpose', purpose)
          ..add('mimeType', mimeType)
          ..add('originalFilename', originalFilename)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class ApiV1MediaUploadIntentPostRequestBuilder
    implements
        Builder<ApiV1MediaUploadIntentPostRequest,
            ApiV1MediaUploadIntentPostRequestBuilder> {
  _$ApiV1MediaUploadIntentPostRequest? _$v;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  ApiV1MediaUploadIntentPostRequestPurposeEnum? _purpose;
  ApiV1MediaUploadIntentPostRequestPurposeEnum? get purpose => _$this._purpose;
  set purpose(ApiV1MediaUploadIntentPostRequestPurposeEnum? purpose) =>
      _$this._purpose = purpose;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  String? _originalFilename;
  String? get originalFilename => _$this._originalFilename;
  set originalFilename(String? originalFilename) =>
      _$this._originalFilename = originalFilename;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  ApiV1MediaUploadIntentPostRequestBuilder() {
    ApiV1MediaUploadIntentPostRequest._defaults(this);
  }

  ApiV1MediaUploadIntentPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _salonId = $v.salonId;
      _purpose = $v.purpose;
      _mimeType = $v.mimeType;
      _originalFilename = $v.originalFilename;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MediaUploadIntentPostRequest other) {
    _$v = other as _$ApiV1MediaUploadIntentPostRequest;
  }

  @override
  void update(
      void Function(ApiV1MediaUploadIntentPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MediaUploadIntentPostRequest build() => _build();

  _$ApiV1MediaUploadIntentPostRequest _build() {
    final _$result = _$v ??
        _$ApiV1MediaUploadIntentPostRequest._(
          salonId: salonId,
          purpose: BuiltValueNullFieldError.checkNotNull(
              purpose, r'ApiV1MediaUploadIntentPostRequest', 'purpose'),
          mimeType: BuiltValueNullFieldError.checkNotNull(
              mimeType, r'ApiV1MediaUploadIntentPostRequest', 'mimeType'),
          originalFilename: BuiltValueNullFieldError.checkNotNull(
              originalFilename,
              r'ApiV1MediaUploadIntentPostRequest',
              'originalFilename'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'ApiV1MediaUploadIntentPostRequest', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
