//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paydunya_execute_payment_input.g.dart';

/// PaydunyaExecutePaymentInput
///
/// Properties:
/// * [paymentId] 
/// * [method] 
/// * [details] 
@BuiltValue()
abstract class PaydunyaExecutePaymentInput implements Built<PaydunyaExecutePaymentInput, PaydunyaExecutePaymentInputBuilder> {
  @BuiltValueField(wireName: r'paymentId')
  String get paymentId;

  @BuiltValueField(wireName: r'method')
  String get method;

  @BuiltValueField(wireName: r'details')
  BuiltMap<String, JsonObject?>? get details;

  PaydunyaExecutePaymentInput._();

  factory PaydunyaExecutePaymentInput([void updates(PaydunyaExecutePaymentInputBuilder b)]) = _$PaydunyaExecutePaymentInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaydunyaExecutePaymentInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaydunyaExecutePaymentInput> get serializer => _$PaydunyaExecutePaymentInputSerializer();
}

class _$PaydunyaExecutePaymentInputSerializer implements PrimitiveSerializer<PaydunyaExecutePaymentInput> {
  @override
  final Iterable<Type> types = const [PaydunyaExecutePaymentInput, _$PaydunyaExecutePaymentInput];

  @override
  final String wireName = r'PaydunyaExecutePaymentInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaydunyaExecutePaymentInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'paymentId';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(String),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(String),
    );
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaydunyaExecutePaymentInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaydunyaExecutePaymentInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'paymentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentId = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.method = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.details.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaydunyaExecutePaymentInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaydunyaExecutePaymentInputBuilder();
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

