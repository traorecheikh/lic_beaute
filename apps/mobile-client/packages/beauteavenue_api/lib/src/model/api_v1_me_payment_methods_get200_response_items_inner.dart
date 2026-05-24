//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_me_payment_methods_get200_response_items_inner.g.dart';

/// ApiV1MePaymentMethodsGet200ResponseItemsInner
///
/// Properties:
/// * [id] 
/// * [provider] 
/// * [phoneNumber] 
/// * [label] 
/// * [isDefault] 
/// * [lastUsedAt] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class ApiV1MePaymentMethodsGet200ResponseItemsInner implements Built<ApiV1MePaymentMethodsGet200ResponseItemsInner, ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'provider')
  ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum get provider;
  // enum providerEnum {  intech,  paydunya,  manual,  };

  @BuiltValueField(wireName: r'phoneNumber')
  String get phoneNumber;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'isDefault')
  bool get isDefault;

  @BuiltValueField(wireName: r'lastUsedAt')
  String? get lastUsedAt;

  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  String get updatedAt;

  ApiV1MePaymentMethodsGet200ResponseItemsInner._();

  factory ApiV1MePaymentMethodsGet200ResponseItemsInner([void updates(ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder b)]) = _$ApiV1MePaymentMethodsGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MePaymentMethodsGet200ResponseItemsInner> get serializer => _$ApiV1MePaymentMethodsGet200ResponseItemsInnerSerializer();
}

class _$ApiV1MePaymentMethodsGet200ResponseItemsInnerSerializer implements PrimitiveSerializer<ApiV1MePaymentMethodsGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [ApiV1MePaymentMethodsGet200ResponseItemsInner, _$ApiV1MePaymentMethodsGet200ResponseItemsInner];

  @override
  final String wireName = r'ApiV1MePaymentMethodsGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MePaymentMethodsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum),
    );
    yield r'phoneNumber';
    yield serializers.serialize(
      object.phoneNumber,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield object.label == null ? null : serializers.serialize(
      object.label,
      specifiedType: const FullType.nullable(String),
    );
    yield r'isDefault';
    yield serializers.serialize(
      object.isDefault,
      specifiedType: const FullType(bool),
    );
    yield r'lastUsedAt';
    yield object.lastUsedAt == null ? null : serializers.serialize(
      object.lastUsedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MePaymentMethodsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder result,
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
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum),
          ) as ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum;
          result.provider = valueDes;
          break;
        case r'phoneNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phoneNumber = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'isDefault':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isDefault = valueDes;
          break;
        case r'lastUsedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastUsedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MePaymentMethodsGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder();
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

class ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'intech')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum intech = _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum_intech;
  @BuiltValueEnumConst(wireName: r'paydunya')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum paydunya = _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum manual = _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum_manual;

  static Serializer<ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum> get serializer => _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumSerializer;

  const ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum._(String name): super(name);

  static BuiltSet<ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum> get values => _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumValues;
  static ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum valueOf(String name) => _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumValueOf(name);
}

