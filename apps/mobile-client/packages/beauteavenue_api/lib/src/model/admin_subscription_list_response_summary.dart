//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_list_response_summary.g.dart';

/// AdminSubscriptionListResponseSummary
///
/// Properties:
/// * [premiumCount]
/// * [standardCount]
/// * [pausedCount]
@BuiltValue()
abstract class AdminSubscriptionListResponseSummary
    implements
        Built<AdminSubscriptionListResponseSummary,
            AdminSubscriptionListResponseSummaryBuilder> {
  @BuiltValueField(wireName: r'premiumCount')
  int get premiumCount;

  @BuiltValueField(wireName: r'standardCount')
  int get standardCount;

  @BuiltValueField(wireName: r'pausedCount')
  int get pausedCount;

  AdminSubscriptionListResponseSummary._();

  factory AdminSubscriptionListResponseSummary(
          [void updates(AdminSubscriptionListResponseSummaryBuilder b)]) =
      _$AdminSubscriptionListResponseSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionListResponseSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionListResponseSummary> get serializer =>
      _$AdminSubscriptionListResponseSummarySerializer();
}

class _$AdminSubscriptionListResponseSummarySerializer
    implements PrimitiveSerializer<AdminSubscriptionListResponseSummary> {
  @override
  final Iterable<Type> types = const [
    AdminSubscriptionListResponseSummary,
    _$AdminSubscriptionListResponseSummary
  ];

  @override
  final String wireName = r'AdminSubscriptionListResponseSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionListResponseSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'premiumCount';
    yield serializers.serialize(
      object.premiumCount,
      specifiedType: const FullType(int),
    );
    yield r'standardCount';
    yield serializers.serialize(
      object.standardCount,
      specifiedType: const FullType(int),
    );
    yield r'pausedCount';
    yield serializers.serialize(
      object.pausedCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSubscriptionListResponseSummary object, {
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
    required AdminSubscriptionListResponseSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'premiumCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.premiumCount = valueDes;
          break;
        case r'standardCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.standardCount = valueDes;
          break;
        case r'pausedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pausedCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSubscriptionListResponseSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionListResponseSummaryBuilder();
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
