//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_notifications_id_read_post200_response.g.dart';

/// ApiV1NotificationsIdReadPost200Response
///
/// Properties:
/// * [read] 
@BuiltValue()
abstract class ApiV1NotificationsIdReadPost200Response implements Built<ApiV1NotificationsIdReadPost200Response, ApiV1NotificationsIdReadPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'read')
  bool get read;

  ApiV1NotificationsIdReadPost200Response._();

  factory ApiV1NotificationsIdReadPost200Response([void updates(ApiV1NotificationsIdReadPost200ResponseBuilder b)]) = _$ApiV1NotificationsIdReadPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1NotificationsIdReadPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1NotificationsIdReadPost200Response> get serializer => _$ApiV1NotificationsIdReadPost200ResponseSerializer();
}

class _$ApiV1NotificationsIdReadPost200ResponseSerializer implements PrimitiveSerializer<ApiV1NotificationsIdReadPost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1NotificationsIdReadPost200Response, _$ApiV1NotificationsIdReadPost200Response];

  @override
  final String wireName = r'ApiV1NotificationsIdReadPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1NotificationsIdReadPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'read';
    yield serializers.serialize(
      object.read,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1NotificationsIdReadPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1NotificationsIdReadPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'read':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.read = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1NotificationsIdReadPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1NotificationsIdReadPost200ResponseBuilder();
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

