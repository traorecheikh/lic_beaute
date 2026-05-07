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
/// * [addressLine1] 
/// * [addressLine2] 
/// * [city] 
/// * [region] 
/// * [phone] 
/// * [isDefault] 
@BuiltValue()
abstract class ApiV1MeAddressesPostRequest implements Built<ApiV1MeAddressesPostRequest, ApiV1MeAddressesPostRequestBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'addressLine1')
  String get addressLine1;

  @BuiltValueField(wireName: r'addressLine2')
  String? get addressLine2;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'region')
  String? get region;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'isDefault')
  bool? get isDefault;

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
    yield r'addressLine1';
    yield serializers.serialize(
      object.addressLine1,
      specifiedType: const FullType(String),
    );
    if (object.addressLine2 != null) {
      yield r'addressLine2';
      yield serializers.serialize(
        object.addressLine2,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    if (object.region != null) {
      yield r'region';
      yield serializers.serialize(
        object.region,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.isDefault != null) {
      yield r'isDefault';
      yield serializers.serialize(
        object.isDefault,
        specifiedType: const FullType(bool),
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
        case r'addressLine1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.addressLine1 = valueDes;
          break;
        case r'addressLine2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.addressLine2 = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'region':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.region = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'isDefault':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isDefault = valueDes;
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

