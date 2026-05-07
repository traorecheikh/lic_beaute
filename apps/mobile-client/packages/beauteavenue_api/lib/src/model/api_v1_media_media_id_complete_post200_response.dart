//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_media_media_id_complete_post200_response.g.dart';

/// ApiV1MediaMediaIdCompletePost200Response
///
/// Properties:
/// * [assetId] 
/// * [uploadStatus] 
/// * [reviewStatus] 
@BuiltValue()
abstract class ApiV1MediaMediaIdCompletePost200Response implements Built<ApiV1MediaMediaIdCompletePost200Response, ApiV1MediaMediaIdCompletePost200ResponseBuilder> {
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  @BuiltValueField(wireName: r'uploadStatus')
  String get uploadStatus;

  @BuiltValueField(wireName: r'reviewStatus')
  String get reviewStatus;

  ApiV1MediaMediaIdCompletePost200Response._();

  factory ApiV1MediaMediaIdCompletePost200Response([void updates(ApiV1MediaMediaIdCompletePost200ResponseBuilder b)]) = _$ApiV1MediaMediaIdCompletePost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MediaMediaIdCompletePost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MediaMediaIdCompletePost200Response> get serializer => _$ApiV1MediaMediaIdCompletePost200ResponseSerializer();
}

class _$ApiV1MediaMediaIdCompletePost200ResponseSerializer implements PrimitiveSerializer<ApiV1MediaMediaIdCompletePost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1MediaMediaIdCompletePost200Response, _$ApiV1MediaMediaIdCompletePost200Response];

  @override
  final String wireName = r'ApiV1MediaMediaIdCompletePost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MediaMediaIdCompletePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'uploadStatus';
    yield serializers.serialize(
      object.uploadStatus,
      specifiedType: const FullType(String),
    );
    yield r'reviewStatus';
    yield serializers.serialize(
      object.reviewStatus,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MediaMediaIdCompletePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MediaMediaIdCompletePost200ResponseBuilder result,
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
        case r'uploadStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadStatus = valueDes;
          break;
        case r'reviewStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reviewStatus = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MediaMediaIdCompletePost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MediaMediaIdCompletePost200ResponseBuilder();
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

