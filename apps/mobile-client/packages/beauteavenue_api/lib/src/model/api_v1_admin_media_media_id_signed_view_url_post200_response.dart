//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_media_media_id_signed_view_url_post200_response.g.dart';

/// ApiV1AdminMediaMediaIdSignedViewUrlPost200Response
///
/// Properties:
/// * [signedUrl] 
/// * [expiresAt] 
@BuiltValue()
abstract class ApiV1AdminMediaMediaIdSignedViewUrlPost200Response implements Built<ApiV1AdminMediaMediaIdSignedViewUrlPost200Response, ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'signedUrl')
  String get signedUrl;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  ApiV1AdminMediaMediaIdSignedViewUrlPost200Response._();

  factory ApiV1AdminMediaMediaIdSignedViewUrlPost200Response([void updates(ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder b)]) = _$ApiV1AdminMediaMediaIdSignedViewUrlPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminMediaMediaIdSignedViewUrlPost200Response> get serializer => _$ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseSerializer();
}

class _$ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseSerializer implements PrimitiveSerializer<ApiV1AdminMediaMediaIdSignedViewUrlPost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1AdminMediaMediaIdSignedViewUrlPost200Response, _$ApiV1AdminMediaMediaIdSignedViewUrlPost200Response];

  @override
  final String wireName = r'ApiV1AdminMediaMediaIdSignedViewUrlPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminMediaMediaIdSignedViewUrlPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'signedUrl';
    yield serializers.serialize(
      object.signedUrl,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminMediaMediaIdSignedViewUrlPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'signedUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.signedUrl = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
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
  ApiV1AdminMediaMediaIdSignedViewUrlPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminMediaMediaIdSignedViewUrlPost200ResponseBuilder();
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

