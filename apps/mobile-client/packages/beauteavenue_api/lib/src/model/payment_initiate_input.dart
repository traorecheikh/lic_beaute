//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_initiate_input.g.dart';

/// PaymentInitiateInput
///
/// Properties:
/// * [bookingId] 
/// * [provider] 
/// * [channel] 
@BuiltValue()
abstract class PaymentInitiateInput implements Built<PaymentInitiateInput, PaymentInitiateInputBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'provider')
  PaymentInitiateInputProviderEnum get provider;
  // enum providerEnum {  intech,  };

  @BuiltValueField(wireName: r'channel')
  PaymentInitiateInputChannelEnum? get channel;
  // enum channelEnum {  wave,  orange_money,  free_money,  };

  PaymentInitiateInput._();

  factory PaymentInitiateInput([void updates(PaymentInitiateInputBuilder b)]) = _$PaymentInitiateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentInitiateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentInitiateInput> get serializer => _$PaymentInitiateInputSerializer();
}

class _$PaymentInitiateInputSerializer implements PrimitiveSerializer<PaymentInitiateInput> {
  @override
  final Iterable<Type> types = const [PaymentInitiateInput, _$PaymentInitiateInput];

  @override
  final String wireName = r'PaymentInitiateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentInitiateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(PaymentInitiateInputProviderEnum),
    );
    if (object.channel != null) {
      yield r'channel';
      yield serializers.serialize(
        object.channel,
        specifiedType: const FullType(PaymentInitiateInputChannelEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentInitiateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentInitiateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentInitiateInputProviderEnum),
          ) as PaymentInitiateInputProviderEnum;
          result.provider = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentInitiateInputChannelEnum),
          ) as PaymentInitiateInputChannelEnum;
          result.channel = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentInitiateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentInitiateInputBuilder();
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

class PaymentInitiateInputProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'intech')
  static const PaymentInitiateInputProviderEnum intech = _$paymentInitiateInputProviderEnum_intech;

  static Serializer<PaymentInitiateInputProviderEnum> get serializer => _$paymentInitiateInputProviderEnumSerializer;

  const PaymentInitiateInputProviderEnum._(String name): super(name);

  static BuiltSet<PaymentInitiateInputProviderEnum> get values => _$paymentInitiateInputProviderEnumValues;
  static PaymentInitiateInputProviderEnum valueOf(String name) => _$paymentInitiateInputProviderEnumValueOf(name);
}

class PaymentInitiateInputChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'wave')
  static const PaymentInitiateInputChannelEnum wave = _$paymentInitiateInputChannelEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const PaymentInitiateInputChannelEnum orangeMoney = _$paymentInitiateInputChannelEnum_orangeMoney;
  @BuiltValueEnumConst(wireName: r'free_money')
  static const PaymentInitiateInputChannelEnum freeMoney = _$paymentInitiateInputChannelEnum_freeMoney;

  static Serializer<PaymentInitiateInputChannelEnum> get serializer => _$paymentInitiateInputChannelEnumSerializer;

  const PaymentInitiateInputChannelEnum._(String name): super(name);

  static BuiltSet<PaymentInitiateInputChannelEnum> get values => _$paymentInitiateInputChannelEnumValues;
  static PaymentInitiateInputChannelEnum valueOf(String name) => _$paymentInitiateInputChannelEnumValueOf(name);
}

