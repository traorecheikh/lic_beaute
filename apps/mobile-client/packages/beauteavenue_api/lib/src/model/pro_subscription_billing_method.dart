//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_subscription_billing_method.g.dart';

/// ProSubscriptionBillingMethod
///
/// Properties:
/// * [provider]
/// * [accountNumberMasked]
@BuiltValue()
abstract class ProSubscriptionBillingMethod
    implements
        Built<ProSubscriptionBillingMethod,
            ProSubscriptionBillingMethodBuilder> {
  @BuiltValueField(wireName: r'provider')
  ProSubscriptionBillingMethodProviderEnum get provider;
  // enum providerEnum {  wave,  orange_money,  };

  @BuiltValueField(wireName: r'accountNumberMasked')
  String get accountNumberMasked;

  ProSubscriptionBillingMethod._();

  factory ProSubscriptionBillingMethod(
          [void updates(ProSubscriptionBillingMethodBuilder b)]) =
      _$ProSubscriptionBillingMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSubscriptionBillingMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSubscriptionBillingMethod> get serializer =>
      _$ProSubscriptionBillingMethodSerializer();
}

class _$ProSubscriptionBillingMethodSerializer
    implements PrimitiveSerializer<ProSubscriptionBillingMethod> {
  @override
  final Iterable<Type> types = const [
    ProSubscriptionBillingMethod,
    _$ProSubscriptionBillingMethod
  ];

  @override
  final String wireName = r'ProSubscriptionBillingMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSubscriptionBillingMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(ProSubscriptionBillingMethodProviderEnum),
    );
    yield r'accountNumberMasked';
    yield serializers.serialize(
      object.accountNumberMasked,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSubscriptionBillingMethod object, {
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
    required ProSubscriptionBillingMethodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(ProSubscriptionBillingMethodProviderEnum),
          ) as ProSubscriptionBillingMethodProviderEnum;
          result.provider = valueDes;
          break;
        case r'accountNumberMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountNumberMasked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProSubscriptionBillingMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSubscriptionBillingMethodBuilder();
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

class ProSubscriptionBillingMethodProviderEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'wave')
  static const ProSubscriptionBillingMethodProviderEnum wave =
      _$proSubscriptionBillingMethodProviderEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const ProSubscriptionBillingMethodProviderEnum orangeMoney =
      _$proSubscriptionBillingMethodProviderEnum_orangeMoney;

  static Serializer<ProSubscriptionBillingMethodProviderEnum> get serializer =>
      _$proSubscriptionBillingMethodProviderEnumSerializer;

  const ProSubscriptionBillingMethodProviderEnum._(String name) : super(name);

  static BuiltSet<ProSubscriptionBillingMethodProviderEnum> get values =>
      _$proSubscriptionBillingMethodProviderEnumValues;
  static ProSubscriptionBillingMethodProviderEnum valueOf(String name) =>
      _$proSubscriptionBillingMethodProviderEnumValueOf(name);
}
