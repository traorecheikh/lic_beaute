//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_salons_post_request.g.dart';

/// ApiV1AdminSalonsPostRequest
///
/// Properties:
/// * [name] 
/// * [category] 
/// * [city] 
/// * [address] 
/// * [description] 
/// * [ownerEmail] 
/// * [ownerPhone] 
/// * [ownerName] 
@BuiltValue()
abstract class ApiV1AdminSalonsPostRequest implements Built<ApiV1AdminSalonsPostRequest, ApiV1AdminSalonsPostRequestBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'ownerEmail')
  String get ownerEmail;

  @BuiltValueField(wireName: r'ownerPhone')
  String get ownerPhone;

  @BuiltValueField(wireName: r'ownerName')
  String get ownerName;

  ApiV1AdminSalonsPostRequest._();

  factory ApiV1AdminSalonsPostRequest([void updates(ApiV1AdminSalonsPostRequestBuilder b)]) = _$ApiV1AdminSalonsPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminSalonsPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminSalonsPostRequest> get serializer => _$ApiV1AdminSalonsPostRequestSerializer();
}

class _$ApiV1AdminSalonsPostRequestSerializer implements PrimitiveSerializer<ApiV1AdminSalonsPostRequest> {
  @override
  final Iterable<Type> types = const [ApiV1AdminSalonsPostRequest, _$ApiV1AdminSalonsPostRequest];

  @override
  final String wireName = r'ApiV1AdminSalonsPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminSalonsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'ownerEmail';
    yield serializers.serialize(
      object.ownerEmail,
      specifiedType: const FullType(String),
    );
    yield r'ownerPhone';
    yield serializers.serialize(
      object.ownerPhone,
      specifiedType: const FullType(String),
    );
    yield r'ownerName';
    yield serializers.serialize(
      object.ownerName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminSalonsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminSalonsPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'ownerEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerEmail = valueDes;
          break;
        case r'ownerPhone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerPhone = valueDes;
          break;
        case r'ownerName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminSalonsPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminSalonsPostRequestBuilder();
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

