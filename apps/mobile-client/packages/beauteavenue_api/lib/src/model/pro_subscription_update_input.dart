//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/pro_subscription_update_input_billing_method.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_subscription_update_input.g.dart';

/// ProSubscriptionUpdateInput
///
/// Properties:
/// * [autoRenew] 
/// * [billingMethod] 
@BuiltValue()
abstract class ProSubscriptionUpdateInput implements Built<ProSubscriptionUpdateInput, ProSubscriptionUpdateInputBuilder> {
  @BuiltValueField(wireName: r'autoRenew')
  bool? get autoRenew;

  @BuiltValueField(wireName: r'billingMethod')
  ProSubscriptionUpdateInputBillingMethod? get billingMethod;

  ProSubscriptionUpdateInput._();

  factory ProSubscriptionUpdateInput([void updates(ProSubscriptionUpdateInputBuilder b)]) = _$ProSubscriptionUpdateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSubscriptionUpdateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSubscriptionUpdateInput> get serializer => _$ProSubscriptionUpdateInputSerializer();
}

class _$ProSubscriptionUpdateInputSerializer implements PrimitiveSerializer<ProSubscriptionUpdateInput> {
  @override
  final Iterable<Type> types = const [ProSubscriptionUpdateInput, _$ProSubscriptionUpdateInput];

  @override
  final String wireName = r'ProSubscriptionUpdateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSubscriptionUpdateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.autoRenew != null) {
      yield r'autoRenew';
      yield serializers.serialize(
        object.autoRenew,
        specifiedType: const FullType(bool),
      );
    }
    if (object.billingMethod != null) {
      yield r'billingMethod';
      yield serializers.serialize(
        object.billingMethod,
        specifiedType: const FullType.nullable(ProSubscriptionUpdateInputBillingMethod),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSubscriptionUpdateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProSubscriptionUpdateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(ProSubscriptionUpdateInputBillingMethod),
          ) as ProSubscriptionUpdateInputBillingMethod?;
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
  ProSubscriptionUpdateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSubscriptionUpdateInputBuilder();
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

