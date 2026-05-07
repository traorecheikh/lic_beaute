//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/pro_subscription_billing_method.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_subscription.g.dart';

/// ProSubscription
///
/// Properties:
/// * [id] 
/// * [tier] 
/// * [status] 
/// * [renewsAt] 
/// * [expiresAt] 
/// * [isComplimentary] 
/// * [autoRenew] 
/// * [billingMethod] 
@BuiltValue()
abstract class ProSubscription implements Built<ProSubscription, ProSubscriptionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'tier')
  ProSubscriptionTierEnum get tier;
  // enum tierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'status')
  ProSubscriptionStatusEnum get status;
  // enum statusEnum {  inactive,  active,  past_due,  cancelled,  expired,  paused,  };

  @BuiltValueField(wireName: r'renewsAt')
  DateTime? get renewsAt;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'isComplimentary')
  bool get isComplimentary;

  @BuiltValueField(wireName: r'autoRenew')
  bool get autoRenew;

  @BuiltValueField(wireName: r'billingMethod')
  ProSubscriptionBillingMethod? get billingMethod;

  ProSubscription._();

  factory ProSubscription([void updates(ProSubscriptionBuilder b)]) = _$ProSubscription;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSubscriptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSubscription> get serializer => _$ProSubscriptionSerializer();
}

class _$ProSubscriptionSerializer implements PrimitiveSerializer<ProSubscription> {
  @override
  final Iterable<Type> types = const [ProSubscription, _$ProSubscription];

  @override
  final String wireName = r'ProSubscription';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSubscription object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(ProSubscriptionTierEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProSubscriptionStatusEnum),
    );
    yield r'renewsAt';
    yield object.renewsAt == null ? null : serializers.serialize(
      object.renewsAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'isComplimentary';
    yield serializers.serialize(
      object.isComplimentary,
      specifiedType: const FullType(bool),
    );
    yield r'autoRenew';
    yield serializers.serialize(
      object.autoRenew,
      specifiedType: const FullType(bool),
    );
    yield r'billingMethod';
    yield object.billingMethod == null ? null : serializers.serialize(
      object.billingMethod,
      specifiedType: const FullType.nullable(ProSubscriptionBillingMethod),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSubscription object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProSubscriptionBuilder result,
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
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProSubscriptionTierEnum),
          ) as ProSubscriptionTierEnum;
          result.tier = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProSubscriptionStatusEnum),
          ) as ProSubscriptionStatusEnum;
          result.status = valueDes;
          break;
        case r'renewsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.renewsAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'isComplimentary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isComplimentary = valueDes;
          break;
        case r'autoRenew':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.autoRenew = valueDes;
          break;
        case r'billingMethod':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProSubscriptionBillingMethod),
          ) as ProSubscriptionBillingMethod?;
          if (valueDes == null) continue;
          result.billingMethod.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProSubscription deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSubscriptionBuilder();
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

class ProSubscriptionTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const ProSubscriptionTierEnum standard = _$proSubscriptionTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const ProSubscriptionTierEnum premium = _$proSubscriptionTierEnum_premium;

  static Serializer<ProSubscriptionTierEnum> get serializer => _$proSubscriptionTierEnumSerializer;

  const ProSubscriptionTierEnum._(String name): super(name);

  static BuiltSet<ProSubscriptionTierEnum> get values => _$proSubscriptionTierEnumValues;
  static ProSubscriptionTierEnum valueOf(String name) => _$proSubscriptionTierEnumValueOf(name);
}

class ProSubscriptionStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'inactive')
  static const ProSubscriptionStatusEnum inactive = _$proSubscriptionStatusEnum_inactive;
  @BuiltValueEnumConst(wireName: r'active')
  static const ProSubscriptionStatusEnum active = _$proSubscriptionStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'past_due')
  static const ProSubscriptionStatusEnum pastDue = _$proSubscriptionStatusEnum_pastDue;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ProSubscriptionStatusEnum cancelled = _$proSubscriptionStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'expired')
  static const ProSubscriptionStatusEnum expired = _$proSubscriptionStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'paused')
  static const ProSubscriptionStatusEnum paused = _$proSubscriptionStatusEnum_paused;

  static Serializer<ProSubscriptionStatusEnum> get serializer => _$proSubscriptionStatusEnumSerializer;

  const ProSubscriptionStatusEnum._(String name): super(name);

  static BuiltSet<ProSubscriptionStatusEnum> get values => _$proSubscriptionStatusEnumValues;
  static ProSubscriptionStatusEnum valueOf(String name) => _$proSubscriptionStatusEnumValueOf(name);
}

