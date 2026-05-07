//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_me_addresses_get200_response_items_inner.g.dart';

/// ApiV1MeAddressesGet200ResponseItemsInner
///
/// Properties:
/// * [id] 
/// * [label] 
/// * [addressLine1] 
/// * [addressLine2] 
/// * [city] 
/// * [region] 
/// * [phone] 
/// * [isDefault] 
/// * [createdAt] 
@BuiltValue()
abstract class ApiV1MeAddressesGet200ResponseItemsInner implements Built<ApiV1MeAddressesGet200ResponseItemsInner, ApiV1MeAddressesGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

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
  bool get isDefault;

  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  ApiV1MeAddressesGet200ResponseItemsInner._();

  factory ApiV1MeAddressesGet200ResponseItemsInner([void updates(ApiV1MeAddressesGet200ResponseItemsInnerBuilder b)]) = _$ApiV1MeAddressesGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MeAddressesGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MeAddressesGet200ResponseItemsInner> get serializer => _$ApiV1MeAddressesGet200ResponseItemsInnerSerializer();
}

class _$ApiV1MeAddressesGet200ResponseItemsInnerSerializer implements PrimitiveSerializer<ApiV1MeAddressesGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [ApiV1MeAddressesGet200ResponseItemsInner, _$ApiV1MeAddressesGet200ResponseItemsInner];

  @override
  final String wireName = r'ApiV1MeAddressesGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MeAddressesGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'addressLine2';
    yield object.addressLine2 == null ? null : serializers.serialize(
      object.addressLine2,
      specifiedType: const FullType.nullable(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'region';
    yield object.region == null ? null : serializers.serialize(
      object.region,
      specifiedType: const FullType.nullable(String),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'isDefault';
    yield serializers.serialize(
      object.isDefault,
      specifiedType: const FullType(bool),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MeAddressesGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MeAddressesGet200ResponseItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MeAddressesGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MeAddressesGet200ResponseItemsInnerBuilder();
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

