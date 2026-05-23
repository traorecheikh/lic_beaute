//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_payments_webhooks_paydunya_post200_response.g.dart';

/// ApiV1PaymentsWebhooksPaydunyaPost200Response
///
/// Properties:
/// * [received] 
@BuiltValue()
abstract class ApiV1PaymentsWebhooksPaydunyaPost200Response implements Built<ApiV1PaymentsWebhooksPaydunyaPost200Response, ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'received')
  bool get received;

  ApiV1PaymentsWebhooksPaydunyaPost200Response._();

  factory ApiV1PaymentsWebhooksPaydunyaPost200Response([void updates(ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder b)]) = _$ApiV1PaymentsWebhooksPaydunyaPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1PaymentsWebhooksPaydunyaPost200Response> get serializer => _$ApiV1PaymentsWebhooksPaydunyaPost200ResponseSerializer();
}

class _$ApiV1PaymentsWebhooksPaydunyaPost200ResponseSerializer implements PrimitiveSerializer<ApiV1PaymentsWebhooksPaydunyaPost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1PaymentsWebhooksPaydunyaPost200Response, _$ApiV1PaymentsWebhooksPaydunyaPost200Response];

  @override
  final String wireName = r'ApiV1PaymentsWebhooksPaydunyaPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1PaymentsWebhooksPaydunyaPost200Response object, {
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
    ApiV1PaymentsWebhooksPaydunyaPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder result,
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
  ApiV1PaymentsWebhooksPaydunyaPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder();
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

