//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_media_upload_intent_post201_response.g.dart';

/// ApiV1MediaUploadIntentPost201Response
///
/// Properties:
/// * [assetId] 
/// * [uploadUrl] 
/// * [expiresAt] 
@BuiltValue()
abstract class ApiV1MediaUploadIntentPost201Response implements Built<ApiV1MediaUploadIntentPost201Response, ApiV1MediaUploadIntentPost201ResponseBuilder> {
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  @BuiltValueField(wireName: r'uploadUrl')
  String get uploadUrl;

  @BuiltValueField(wireName: r'expiresAt')
  String get expiresAt;

  ApiV1MediaUploadIntentPost201Response._();

  factory ApiV1MediaUploadIntentPost201Response([void updates(ApiV1MediaUploadIntentPost201ResponseBuilder b)]) = _$ApiV1MediaUploadIntentPost201Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MediaUploadIntentPost201ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MediaUploadIntentPost201Response> get serializer => _$ApiV1MediaUploadIntentPost201ResponseSerializer();
}

class _$ApiV1MediaUploadIntentPost201ResponseSerializer implements PrimitiveSerializer<ApiV1MediaUploadIntentPost201Response> {
  @override
  final Iterable<Type> types = const [ApiV1MediaUploadIntentPost201Response, _$ApiV1MediaUploadIntentPost201Response];

  @override
  final String wireName = r'ApiV1MediaUploadIntentPost201Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MediaUploadIntentPost201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'uploadUrl';
    yield serializers.serialize(
      object.uploadUrl,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MediaUploadIntentPost201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MediaUploadIntentPost201ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'uploadUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadUrl = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MediaUploadIntentPost201Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MediaUploadIntentPost201ResponseBuilder();
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

