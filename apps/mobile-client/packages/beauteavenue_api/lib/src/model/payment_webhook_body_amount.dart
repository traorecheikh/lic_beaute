//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:core';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'payment_webhook_body_amount.g.dart';

/// PaymentWebhookBodyAmount
@BuiltValue()
abstract class PaymentWebhookBodyAmount implements Built<PaymentWebhookBodyAmount, PaymentWebhookBodyAmountBuilder> {
  /// Any Of [String], [num]
  AnyOf get anyOf;

  PaymentWebhookBodyAmount._();

  factory PaymentWebhookBodyAmount([void updates(PaymentWebhookBodyAmountBuilder b)]) = _$PaymentWebhookBodyAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentWebhookBodyAmountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentWebhookBodyAmount> get serializer => _$PaymentWebhookBodyAmountSerializer();
}

class _$PaymentWebhookBodyAmountSerializer implements PrimitiveSerializer<PaymentWebhookBodyAmount> {
  @override
  final Iterable<Type> types = const [PaymentWebhookBodyAmount, _$PaymentWebhookBodyAmount];

  @override
  final String wireName = r'PaymentWebhookBodyAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentWebhookBodyAmount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentWebhookBodyAmount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.valueTypes.map((type) => FullType(type)).toList()))!;
  }

  @override
  PaymentWebhookBodyAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentWebhookBodyAmountBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(num), FullType(String), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}

