//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_payment_method_update_input.g.dart';

/// ClientPaymentMethodUpdateInput
///
/// Properties:
/// * [phoneNumber] 
/// * [label] 
@BuiltValue()
abstract class ClientPaymentMethodUpdateInput implements Built<ClientPaymentMethodUpdateInput, ClientPaymentMethodUpdateInputBuilder> {
  @BuiltValueField(wireName: r'phoneNumber')
  String? get phoneNumber;

  @BuiltValueField(wireName: r'label')
  String? get label;

  ClientPaymentMethodUpdateInput._();

  factory ClientPaymentMethodUpdateInput([void updates(ClientPaymentMethodUpdateInputBuilder b)]) = _$ClientPaymentMethodUpdateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientPaymentMethodUpdateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientPaymentMethodUpdateInput> get serializer => _$ClientPaymentMethodUpdateInputSerializer();
}

class _$ClientPaymentMethodUpdateInputSerializer implements PrimitiveSerializer<ClientPaymentMethodUpdateInput> {
  @override
  final Iterable<Type> types = const [ClientPaymentMethodUpdateInput, _$ClientPaymentMethodUpdateInput];

  @override
  final String wireName = r'ClientPaymentMethodUpdateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientPaymentMethodUpdateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.phoneNumber != null) {
      yield r'phoneNumber';
      yield serializers.serialize(
        object.phoneNumber,
        specifiedType: const FullType(String),
      );
    }
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
    ClientPaymentMethodUpdateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientPaymentMethodUpdateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  ClientPaymentMethodUpdateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientPaymentMethodUpdateInputBuilder();
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

