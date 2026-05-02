//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_subscription_checkout_input.g.dart';

/// ProSubscriptionCheckoutInput
///
/// Properties:
/// * [action]
/// * [provider]
@BuiltValue()
abstract class ProSubscriptionCheckoutInput
    implements
        Built<ProSubscriptionCheckoutInput,
            ProSubscriptionCheckoutInputBuilder> {
  @BuiltValueField(wireName: r'action')
  ProSubscriptionCheckoutInputActionEnum get action;
  // enum actionEnum {  upgrade,  renewal,  };

  @BuiltValueField(wireName: r'provider')
  ProSubscriptionCheckoutInputProviderEnum? get provider;
  // enum providerEnum {  wave,  orange_money,  };

  ProSubscriptionCheckoutInput._();

  factory ProSubscriptionCheckoutInput(
          [void updates(ProSubscriptionCheckoutInputBuilder b)]) =
      _$ProSubscriptionCheckoutInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSubscriptionCheckoutInputBuilder b) =>
      b..provider = ProSubscriptionCheckoutInputProviderEnum.valueOf('wave');

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSubscriptionCheckoutInput> get serializer =>
      _$ProSubscriptionCheckoutInputSerializer();
}

class _$ProSubscriptionCheckoutInputSerializer
    implements PrimitiveSerializer<ProSubscriptionCheckoutInput> {
  @override
  final Iterable<Type> types = const [
    ProSubscriptionCheckoutInput,
    _$ProSubscriptionCheckoutInput
  ];

  @override
  final String wireName = r'ProSubscriptionCheckoutInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSubscriptionCheckoutInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(ProSubscriptionCheckoutInputActionEnum),
    );
    if (object.provider != null) {
      yield r'provider';
      yield serializers.serialize(
        object.provider,
        specifiedType: const FullType(ProSubscriptionCheckoutInputProviderEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSubscriptionCheckoutInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProSubscriptionCheckoutInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(ProSubscriptionCheckoutInputActionEnum),
          ) as ProSubscriptionCheckoutInputActionEnum;
          result.action = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(ProSubscriptionCheckoutInputProviderEnum),
          ) as ProSubscriptionCheckoutInputProviderEnum;
          result.provider = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProSubscriptionCheckoutInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSubscriptionCheckoutInputBuilder();
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

class ProSubscriptionCheckoutInputActionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'upgrade')
  static const ProSubscriptionCheckoutInputActionEnum upgrade =
      _$proSubscriptionCheckoutInputActionEnum_upgrade;
  @BuiltValueEnumConst(wireName: r'renewal')
  static const ProSubscriptionCheckoutInputActionEnum renewal =
      _$proSubscriptionCheckoutInputActionEnum_renewal;

  static Serializer<ProSubscriptionCheckoutInputActionEnum> get serializer =>
      _$proSubscriptionCheckoutInputActionEnumSerializer;

  const ProSubscriptionCheckoutInputActionEnum._(String name) : super(name);

  static BuiltSet<ProSubscriptionCheckoutInputActionEnum> get values =>
      _$proSubscriptionCheckoutInputActionEnumValues;
  static ProSubscriptionCheckoutInputActionEnum valueOf(String name) =>
      _$proSubscriptionCheckoutInputActionEnumValueOf(name);
}

class ProSubscriptionCheckoutInputProviderEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'wave')
  static const ProSubscriptionCheckoutInputProviderEnum wave =
      _$proSubscriptionCheckoutInputProviderEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const ProSubscriptionCheckoutInputProviderEnum orangeMoney =
      _$proSubscriptionCheckoutInputProviderEnum_orangeMoney;

  static Serializer<ProSubscriptionCheckoutInputProviderEnum> get serializer =>
      _$proSubscriptionCheckoutInputProviderEnumSerializer;

  const ProSubscriptionCheckoutInputProviderEnum._(String name) : super(name);

  static BuiltSet<ProSubscriptionCheckoutInputProviderEnum> get values =>
      _$proSubscriptionCheckoutInputProviderEnumValues;
  static ProSubscriptionCheckoutInputProviderEnum valueOf(String name) =>
      _$proSubscriptionCheckoutInputProviderEnumValueOf(name);
}
