//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_media_media_id_reject_post200_response.g.dart';

/// ApiV1AdminMediaMediaIdRejectPost200Response
///
/// Properties:
/// * [rejected] 
@BuiltValue()
abstract class ApiV1AdminMediaMediaIdRejectPost200Response implements Built<ApiV1AdminMediaMediaIdRejectPost200Response, ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'rejected')
  bool get rejected;

  ApiV1AdminMediaMediaIdRejectPost200Response._();

  factory ApiV1AdminMediaMediaIdRejectPost200Response([void updates(ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder b)]) = _$ApiV1AdminMediaMediaIdRejectPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminMediaMediaIdRejectPost200Response> get serializer => _$ApiV1AdminMediaMediaIdRejectPost200ResponseSerializer();
}

class _$ApiV1AdminMediaMediaIdRejectPost200ResponseSerializer implements PrimitiveSerializer<ApiV1AdminMediaMediaIdRejectPost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1AdminMediaMediaIdRejectPost200Response, _$ApiV1AdminMediaMediaIdRejectPost200Response];

  @override
  final String wireName = r'ApiV1AdminMediaMediaIdRejectPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminMediaMediaIdRejectPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rejected';
    yield serializers.serialize(
      object.rejected,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminMediaMediaIdRejectPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rejected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.rejected = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminMediaMediaIdRejectPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminMediaMediaIdRejectPost200ResponseBuilder();
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

