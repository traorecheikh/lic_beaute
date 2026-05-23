//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_payment_method.g.dart';

/// ClientPaymentMethod
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
abstract class ClientPaymentMethod implements Built<ClientPaymentMethod, ClientPaymentMethodBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'provider')
  ClientPaymentMethodProviderEnum get provider;
  // enum providerEnum {  intech,  paydunya,  };

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

  ClientPaymentMethod._();

  factory ClientPaymentMethod([void updates(ClientPaymentMethodBuilder b)]) = _$ClientPaymentMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientPaymentMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientPaymentMethod> get serializer => _$ClientPaymentMethodSerializer();
}

class _$ClientPaymentMethodSerializer implements PrimitiveSerializer<ClientPaymentMethod> {
  @override
  final Iterable<Type> types = const [ClientPaymentMethod, _$ClientPaymentMethod];

  @override
  final String wireName = r'ClientPaymentMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientPaymentMethod object, {
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
      specifiedType: const FullType(ClientPaymentMethodProviderEnum),
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
    ClientPaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientPaymentMethodBuilder result,
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
            specifiedType: const FullType(ClientPaymentMethodProviderEnum),
          ) as ClientPaymentMethodProviderEnum;
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
  ClientPaymentMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientPaymentMethodBuilder();
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

class ClientPaymentMethodProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'intech')
  static const ClientPaymentMethodProviderEnum intech = _$clientPaymentMethodProviderEnum_intech;
  @BuiltValueEnumConst(wireName: r'paydunya')
  static const ClientPaymentMethodProviderEnum paydunya = _$clientPaymentMethodProviderEnum_paydunya;

  static Serializer<ClientPaymentMethodProviderEnum> get serializer => _$clientPaymentMethodProviderEnumSerializer;

  const ClientPaymentMethodProviderEnum._(String name): super(name);

  static BuiltSet<ClientPaymentMethodProviderEnum> get values => _$clientPaymentMethodProviderEnumValues;
  static ClientPaymentMethodProviderEnum valueOf(String name) => _$clientPaymentMethodProviderEnumValueOf(name);
}

