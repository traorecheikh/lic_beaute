//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_booking_full_detail_events_inner.g.dart';

/// ProBookingFullDetailEventsInner
///
/// Properties:
/// * [eventType]
/// * [fromStatus]
/// * [toStatus]
/// * [createdAt]
@BuiltValue()
abstract class ProBookingFullDetailEventsInner
    implements
        Built<ProBookingFullDetailEventsInner,
            ProBookingFullDetailEventsInnerBuilder> {
  @BuiltValueField(wireName: r'eventType')
  String get eventType;

  @BuiltValueField(wireName: r'fromStatus')
  String? get fromStatus;

  @BuiltValueField(wireName: r'toStatus')
  String? get toStatus;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ProBookingFullDetailEventsInner._();

  factory ProBookingFullDetailEventsInner(
          [void updates(ProBookingFullDetailEventsInnerBuilder b)]) =
      _$ProBookingFullDetailEventsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProBookingFullDetailEventsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProBookingFullDetailEventsInner> get serializer =>
      _$ProBookingFullDetailEventsInnerSerializer();
}

class _$ProBookingFullDetailEventsInnerSerializer
    implements PrimitiveSerializer<ProBookingFullDetailEventsInner> {
  @override
  final Iterable<Type> types = const [
    ProBookingFullDetailEventsInner,
    _$ProBookingFullDetailEventsInner
  ];

  @override
  final String wireName = r'ProBookingFullDetailEventsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProBookingFullDetailEventsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'eventType';
    yield serializers.serialize(
      object.eventType,
      specifiedType: const FullType(String),
    );
    yield r'fromStatus';
    yield object.fromStatus == null
        ? null
        : serializers.serialize(
            object.fromStatus,
            specifiedType: const FullType.nullable(String),
          );
    yield r'toStatus';
    yield object.toStatus == null
        ? null
        : serializers.serialize(
            object.toStatus,
            specifiedType: const FullType.nullable(String),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProBookingFullDetailEventsInner object, {
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
    required ProBookingFullDetailEventsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eventType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.eventType = valueDes;
          break;
        case r'fromStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fromStatus = valueDes;
          break;
        case r'toStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.toStatus = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProBookingFullDetailEventsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProBookingFullDetailEventsInnerBuilder();
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
