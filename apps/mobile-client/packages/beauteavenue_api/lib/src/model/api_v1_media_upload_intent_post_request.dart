//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_media_upload_intent_post_request.g.dart';

/// ApiV1MediaUploadIntentPostRequest
///
/// Properties:
/// * [salonId] 
/// * [purpose] 
/// * [mimeType] 
/// * [originalFilename] 
/// * [sizeBytes] 
@BuiltValue()
abstract class ApiV1MediaUploadIntentPostRequest implements Built<ApiV1MediaUploadIntentPostRequest, ApiV1MediaUploadIntentPostRequestBuilder> {
  @BuiltValueField(wireName: r'salonId')
  String? get salonId;

  @BuiltValueField(wireName: r'purpose')
  ApiV1MediaUploadIntentPostRequestPurposeEnum get purpose;
  // enum purposeEnum {  salon_cover,  salon_logo,  salon_gallery,  kyc_document,  avatar,  };

  @BuiltValueField(wireName: r'mimeType')
  String get mimeType;

  @BuiltValueField(wireName: r'originalFilename')
  String get originalFilename;

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  ApiV1MediaUploadIntentPostRequest._();

  factory ApiV1MediaUploadIntentPostRequest([void updates(ApiV1MediaUploadIntentPostRequestBuilder b)]) = _$ApiV1MediaUploadIntentPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MediaUploadIntentPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MediaUploadIntentPostRequest> get serializer => _$ApiV1MediaUploadIntentPostRequestSerializer();
}

class _$ApiV1MediaUploadIntentPostRequestSerializer implements PrimitiveSerializer<ApiV1MediaUploadIntentPostRequest> {
  @override
  final Iterable<Type> types = const [ApiV1MediaUploadIntentPostRequest, _$ApiV1MediaUploadIntentPostRequest];

  @override
  final String wireName = r'ApiV1MediaUploadIntentPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MediaUploadIntentPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.salonId != null) {
      yield r'salonId';
      yield serializers.serialize(
        object.salonId,
        specifiedType: const FullType(String),
      );
    }
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(ApiV1MediaUploadIntentPostRequestPurposeEnum),
    );
    yield r'mimeType';
    yield serializers.serialize(
      object.mimeType,
      specifiedType: const FullType(String),
    );
    yield r'originalFilename';
    yield serializers.serialize(
      object.originalFilename,
      specifiedType: const FullType(String),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MediaUploadIntentPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MediaUploadIntentPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonId = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1MediaUploadIntentPostRequestPurposeEnum),
          ) as ApiV1MediaUploadIntentPostRequestPurposeEnum;
          result.purpose = valueDes;
          break;
        case r'mimeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mimeType = valueDes;
          break;
        case r'originalFilename':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originalFilename = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MediaUploadIntentPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MediaUploadIntentPostRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class ApiV1MediaUploadIntentPostRequestPurposeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'salon_cover')
  static const ApiV1MediaUploadIntentPostRequestPurposeEnum salonCover = _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonCover;
  @BuiltValueEnumConst(wireName: r'salon_logo')
  static const ApiV1MediaUploadIntentPostRequestPurposeEnum salonLogo = _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonLogo;
  @BuiltValueEnumConst(wireName: r'salon_gallery')
  static const ApiV1MediaUploadIntentPostRequestPurposeEnum salonGallery = _$apiV1MediaUploadIntentPostRequestPurposeEnum_salonGallery;
  @BuiltValueEnumConst(wireName: r'kyc_document')
  static const ApiV1MediaUploadIntentPostRequestPurposeEnum kycDocument = _$apiV1MediaUploadIntentPostRequestPurposeEnum_kycDocument;
  @BuiltValueEnumConst(wireName: r'avatar')
  static const ApiV1MediaUploadIntentPostRequestPurposeEnum avatar = _$apiV1MediaUploadIntentPostRequestPurposeEnum_avatar;

  static Serializer<ApiV1MediaUploadIntentPostRequestPurposeEnum> get serializer => _$apiV1MediaUploadIntentPostRequestPurposeEnumSerializer;

  const ApiV1MediaUploadIntentPostRequestPurposeEnum._(String name): super(name);

  static BuiltSet<ApiV1MediaUploadIntentPostRequestPurposeEnum> get values => _$apiV1MediaUploadIntentPostRequestPurposeEnumValues;
  static ApiV1MediaUploadIntentPostRequestPurposeEnum valueOf(String name) => _$apiV1MediaUploadIntentPostRequestPurposeEnumValueOf(name);
}

