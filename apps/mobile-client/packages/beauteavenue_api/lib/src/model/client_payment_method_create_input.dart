//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_payment_method_create_input.g.dart';

/// ClientPaymentMethodCreateInput
///
/// Properties:
/// * [provider] 
/// * [phoneNumber] 
/// * [label] 
@BuiltValue()
abstract class ClientPaymentMethodCreateInput implements Built<ClientPaymentMethodCreateInput, ClientPaymentMethodCreateInputBuilder> {
  @BuiltValueField(wireName: r'provider')
  ClientPaymentMethodCreateInputProviderEnum get provider;
  // enum providerEnum {  intech,  paydunya,  };

  @BuiltValueField(wireName: r'phoneNumber')
  String get phoneNumber;

  @BuiltValueField(wireName: r'label')
  String? get label;

  ClientPaymentMethodCreateInput._();

  factory ClientPaymentMethodCreateInput([void updates(ClientPaymentMethodCreateInputBuilder b)]) = _$ClientPaymentMethodCreateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientPaymentMethodCreateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientPaymentMethodCreateInput> get serializer => _$ClientPaymentMethodCreateInputSerializer();
}

class _$ClientPaymentMethodCreateInputSerializer implements PrimitiveSerializer<ClientPaymentMethodCreateInput> {
  @override
  final Iterable<Type> types = const [ClientPaymentMethodCreateInput, _$ClientPaymentMethodCreateInput];

  @override
  final String wireName = r'ClientPaymentMethodCreateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientPaymentMethodCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(ClientPaymentMethodCreateInputProviderEnum),
    );
    yield r'phoneNumber';
    yield serializers.serialize(
      object.phoneNumber,
      specifiedType: const FullType(String),
    );
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientPaymentMethodCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientPaymentMethodCreateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClientPaymentMethodCreateInputProviderEnum),
          ) as ClientPaymentMethodCreateInputProviderEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClientPaymentMethodCreateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientPaymentMethodCreateInputBuilder();
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

class ClientPaymentMethodCreateInputProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'intech')
  static const ClientPaymentMethodCreateInputProviderEnum intech = _$clientPaymentMethodCreateInputProviderEnum_intech;
  @BuiltValueEnumConst(wireName: r'paydunya')
  static const ClientPaymentMethodCreateInputProviderEnum paydunya = _$clientPaymentMethodCreateInputProviderEnum_paydunya;

  static Serializer<ClientPaymentMethodCreateInputProviderEnum> get serializer => _$clientPaymentMethodCreateInputProviderEnumSerializer;

  const ClientPaymentMethodCreateInputProviderEnum._(String name): super(name);

  static BuiltSet<ClientPaymentMethodCreateInputProviderEnum> get values => _$clientPaymentMethodCreateInputProviderEnumValues;
  static ClientPaymentMethodCreateInputProviderEnum valueOf(String name) => _$clientPaymentMethodCreateInputProviderEnumValueOf(name);
}

