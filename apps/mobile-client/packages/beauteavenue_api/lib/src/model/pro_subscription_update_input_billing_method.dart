//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_subscription_update_input_billing_method.g.dart';

/// ProSubscriptionUpdateInputBillingMethod
///
/// Properties:
/// * [provider]
/// * [accountNumber]
@BuiltValue()
abstract class ProSubscriptionUpdateInputBillingMethod
    implements
        Built<ProSubscriptionUpdateInputBillingMethod,
            ProSubscriptionUpdateInputBillingMethodBuilder> {
  @BuiltValueField(wireName: r'provider')
  ProSubscriptionUpdateInputBillingMethodProviderEnum get provider;
  // enum providerEnum {  wave,  orange_money,  };

  @BuiltValueField(wireName: r'accountNumber')
  String get accountNumber;

  ProSubscriptionUpdateInputBillingMethod._();

  factory ProSubscriptionUpdateInputBillingMethod(
          [void updates(ProSubscriptionUpdateInputBillingMethodBuilder b)]) =
      _$ProSubscriptionUpdateInputBillingMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSubscriptionUpdateInputBillingMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSubscriptionUpdateInputBillingMethod> get serializer =>
      _$ProSubscriptionUpdateInputBillingMethodSerializer();
}

class _$ProSubscriptionUpdateInputBillingMethodSerializer
    implements PrimitiveSerializer<ProSubscriptionUpdateInputBillingMethod> {
  @override
  final Iterable<Type> types = const [
    ProSubscriptionUpdateInputBillingMethod,
    _$ProSubscriptionUpdateInputBillingMethod
  ];

  @override
  final String wireName = r'ProSubscriptionUpdateInputBillingMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSubscriptionUpdateInputBillingMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType:
          const FullType(ProSubscriptionUpdateInputBillingMethodProviderEnum),
    );
    yield r'accountNumber';
    yield serializers.serialize(
      object.accountNumber,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSubscriptionUpdateInputBillingMethod object, {
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
    required ProSubscriptionUpdateInputBillingMethodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                ProSubscriptionUpdateInputBillingMethodProviderEnum),
          ) as ProSubscriptionUpdateInputBillingMethodProviderEnum;
          result.provider = valueDes;
          break;
        case r'accountNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProSubscriptionUpdateInputBillingMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSubscriptionUpdateInputBillingMethodBuilder();
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

class ProSubscriptionUpdateInputBillingMethodProviderEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'wave')
  static const ProSubscriptionUpdateInputBillingMethodProviderEnum wave =
      _$proSubscriptionUpdateInputBillingMethodProviderEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const ProSubscriptionUpdateInputBillingMethodProviderEnum orangeMoney =
      _$proSubscriptionUpdateInputBillingMethodProviderEnum_orangeMoney;

  static Serializer<ProSubscriptionUpdateInputBillingMethodProviderEnum>
      get serializer =>
          _$proSubscriptionUpdateInputBillingMethodProviderEnumSerializer;

  const ProSubscriptionUpdateInputBillingMethodProviderEnum._(String name)
      : super(name);

  static BuiltSet<ProSubscriptionUpdateInputBillingMethodProviderEnum>
      get values => _$proSubscriptionUpdateInputBillingMethodProviderEnumValues;
  static ProSubscriptionUpdateInputBillingMethodProviderEnum valueOf(
          String name) =>
      _$proSubscriptionUpdateInputBillingMethodProviderEnumValueOf(name);
}
