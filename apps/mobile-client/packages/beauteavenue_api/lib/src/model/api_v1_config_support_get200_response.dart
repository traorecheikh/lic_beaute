//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_config_support_get200_response.g.dart';

/// ApiV1ConfigSupportGet200Response
///
/// Properties:
/// * [phone] 
/// * [email] 
@BuiltValue()
abstract class ApiV1ConfigSupportGet200Response implements Built<ApiV1ConfigSupportGet200Response, ApiV1ConfigSupportGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'email')
  String get email;

  ApiV1ConfigSupportGet200Response._();

  factory ApiV1ConfigSupportGet200Response([void updates(ApiV1ConfigSupportGet200ResponseBuilder b)]) = _$ApiV1ConfigSupportGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ConfigSupportGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ConfigSupportGet200Response> get serializer => _$ApiV1ConfigSupportGet200ResponseSerializer();
}

class _$ApiV1ConfigSupportGet200ResponseSerializer implements PrimitiveSerializer<ApiV1ConfigSupportGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1ConfigSupportGet200Response, _$ApiV1ConfigSupportGet200Response];

  @override
  final String wireName = r'ApiV1ConfigSupportGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ConfigSupportGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ConfigSupportGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ConfigSupportGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ConfigSupportGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ConfigSupportGet200ResponseBuilder();
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

