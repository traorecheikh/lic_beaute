//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_payments_webhooks_intech_post200_response.g.dart';

/// ApiV1PaymentsWebhooksIntechPost200Response
///
/// Properties:
/// * [received] 
@BuiltValue()
abstract class ApiV1PaymentsWebhooksIntechPost200Response implements Built<ApiV1PaymentsWebhooksIntechPost200Response, ApiV1PaymentsWebhooksIntechPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'received')
  bool get received;

  ApiV1PaymentsWebhooksIntechPost200Response._();

  factory ApiV1PaymentsWebhooksIntechPost200Response([void updates(ApiV1PaymentsWebhooksIntechPost200ResponseBuilder b)]) = _$ApiV1PaymentsWebhooksIntechPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1PaymentsWebhooksIntechPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1PaymentsWebhooksIntechPost200Response> get serializer => _$ApiV1PaymentsWebhooksIntechPost200ResponseSerializer();
}

class _$ApiV1PaymentsWebhooksIntechPost200ResponseSerializer implements PrimitiveSerializer<ApiV1PaymentsWebhooksIntechPost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1PaymentsWebhooksIntechPost200Response, _$ApiV1PaymentsWebhooksIntechPost200Response];

  @override
  final String wireName = r'ApiV1PaymentsWebhooksIntechPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1PaymentsWebhooksIntechPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1PaymentsWebhooksIntechPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1PaymentsWebhooksIntechPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'received':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.received = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1PaymentsWebhooksIntechPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1PaymentsWebhooksIntechPost200ResponseBuilder();
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

