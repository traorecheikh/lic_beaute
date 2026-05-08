//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_media_media_id_reject_post_request.g.dart';

/// ApiV1AdminMediaMediaIdRejectPostRequest
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class ApiV1AdminMediaMediaIdRejectPostRequest implements Built<ApiV1AdminMediaMediaIdRejectPostRequest, ApiV1AdminMediaMediaIdRejectPostRequestBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  ApiV1AdminMediaMediaIdRejectPostRequest._();

  factory ApiV1AdminMediaMediaIdRejectPostRequest([void updates(ApiV1AdminMediaMediaIdRejectPostRequestBuilder b)]) = _$ApiV1AdminMediaMediaIdRejectPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminMediaMediaIdRejectPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminMediaMediaIdRejectPostRequest> get serializer => _$ApiV1AdminMediaMediaIdRejectPostRequestSerializer();
}

class _$ApiV1AdminMediaMediaIdRejectPostRequestSerializer implements PrimitiveSerializer<ApiV1AdminMediaMediaIdRejectPostRequest> {
  @override
  final Iterable<Type> types = const [ApiV1AdminMediaMediaIdRejectPostRequest, _$ApiV1AdminMediaMediaIdRejectPostRequest];

  @override
  final String wireName = r'ApiV1AdminMediaMediaIdRejectPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminMediaMediaIdRejectPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminMediaMediaIdRejectPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminMediaMediaIdRejectPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminMediaMediaIdRejectPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminMediaMediaIdRejectPostRequestBuilder();
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

