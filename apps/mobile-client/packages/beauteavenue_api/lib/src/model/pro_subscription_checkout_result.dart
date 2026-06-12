//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_subscription_checkout_result.g.dart';

/// ProSubscriptionCheckoutResult
///
/// Properties:
/// * [redirectUrl] 
/// * [chargeId] 
/// * [resumed] 
/// * [downgradeScheduled] 
/// * [effectiveAt] 
@BuiltValue()
abstract class ProSubscriptionCheckoutResult implements Built<ProSubscriptionCheckoutResult, ProSubscriptionCheckoutResultBuilder> {
  @BuiltValueField(wireName: r'redirectUrl')
  String? get redirectUrl;

  @BuiltValueField(wireName: r'chargeId')
  String? get chargeId;

  @BuiltValueField(wireName: r'resumed')
  bool? get resumed;

  @BuiltValueField(wireName: r'downgradeScheduled')
  bool? get downgradeScheduled;

  @BuiltValueField(wireName: r'effectiveAt')
  DateTime? get effectiveAt;

  ProSubscriptionCheckoutResult._();

  factory ProSubscriptionCheckoutResult([void updates(ProSubscriptionCheckoutResultBuilder b)]) = _$ProSubscriptionCheckoutResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSubscriptionCheckoutResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSubscriptionCheckoutResult> get serializer => _$ProSubscriptionCheckoutResultSerializer();
}

class _$ProSubscriptionCheckoutResultSerializer implements PrimitiveSerializer<ProSubscriptionCheckoutResult> {
  @override
  final Iterable<Type> types = const [ProSubscriptionCheckoutResult, _$ProSubscriptionCheckoutResult];

  @override
  final String wireName = r'ProSubscriptionCheckoutResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSubscriptionCheckoutResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.redirectUrl != null) {
      yield r'redirectUrl';
      yield serializers.serialize(
        object.redirectUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.chargeId != null) {
      yield r'chargeId';
      yield serializers.serialize(
        object.chargeId,
        specifiedType: const FullType(String),
      );
    }
    if (object.resumed != null) {
      yield r'resumed';
      yield serializers.serialize(
        object.resumed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.downgradeScheduled != null) {
      yield r'downgradeScheduled';
      yield serializers.serialize(
        object.downgradeScheduled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.effectiveAt != null) {
      yield r'effectiveAt';
      yield serializers.serialize(
        object.effectiveAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSubscriptionCheckoutResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProSubscriptionCheckoutResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'redirectUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.redirectUrl = valueDes;
          break;
        case r'chargeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.chargeId = valueDes;
          break;
        case r'resumed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.resumed = valueDes;
          break;
        case r'downgradeScheduled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.downgradeScheduled = valueDes;
          break;
        case r'effectiveAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.effectiveAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProSubscriptionCheckoutResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSubscriptionCheckoutResultBuilder();
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

