//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_me_addresses_post_request.g.dart';

/// ApiV1MeAddressesPostRequest
///
/// Properties:
/// * [label] 
/// * [street] 
/// * [city] 
@BuiltValue()
abstract class ApiV1MeAddressesPostRequest implements Built<ApiV1MeAddressesPostRequest, ApiV1MeAddressesPostRequestBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'street')
  String? get street;

  @BuiltValueField(wireName: r'city')
  String? get city;

  ApiV1MeAddressesPostRequest._();

  factory ApiV1MeAddressesPostRequest([void updates(ApiV1MeAddressesPostRequestBuilder b)]) = _$ApiV1MeAddressesPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MeAddressesPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MeAddressesPostRequest> get serializer => _$ApiV1MeAddressesPostRequestSerializer();
}

class _$ApiV1MeAddressesPostRequestSerializer implements PrimitiveSerializer<ApiV1MeAddressesPostRequest> {
  @override
  final Iterable<Type> types = const [ApiV1MeAddressesPostRequest, _$ApiV1MeAddressesPostRequest];

  @override
  final String wireName = r'ApiV1MeAddressesPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MeAddressesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    if (object.street != null) {
      yield r'street';
      yield serializers.serialize(
        object.street,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MeAddressesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MeAddressesPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'street':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.street = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.city = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MeAddressesPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MeAddressesPostRequestBuilder();
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

