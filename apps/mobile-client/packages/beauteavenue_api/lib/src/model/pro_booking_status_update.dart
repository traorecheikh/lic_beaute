//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_booking_status_update.g.dart';

/// ProBookingStatusUpdate
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class ProBookingStatusUpdate
    implements Built<ProBookingStatusUpdate, ProBookingStatusUpdateBuilder> {
  @BuiltValueField(wireName: r'status')
  ProBookingStatusUpdateStatusEnum get status;
  // enum statusEnum {  pending,  confirmed,  in_progress,  completed,  cancelled,  };

  ProBookingStatusUpdate._();

  factory ProBookingStatusUpdate(
          [void updates(ProBookingStatusUpdateBuilder b)]) =
      _$ProBookingStatusUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProBookingStatusUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProBookingStatusUpdate> get serializer =>
      _$ProBookingStatusUpdateSerializer();
}

class _$ProBookingStatusUpdateSerializer
    implements PrimitiveSerializer<ProBookingStatusUpdate> {
  @override
  final Iterable<Type> types = const [
    ProBookingStatusUpdate,
    _$ProBookingStatusUpdate
  ];

  @override
  final String wireName = r'ProBookingStatusUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProBookingStatusUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProBookingStatusUpdateStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProBookingStatusUpdate object, {
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
    required ProBookingStatusUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProBookingStatusUpdateStatusEnum),
          ) as ProBookingStatusUpdateStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProBookingStatusUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProBookingStatusUpdateBuilder();
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

class ProBookingStatusUpdateStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const ProBookingStatusUpdateStatusEnum pending =
      _$proBookingStatusUpdateStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const ProBookingStatusUpdateStatusEnum confirmed =
      _$proBookingStatusUpdateStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const ProBookingStatusUpdateStatusEnum inProgress =
      _$proBookingStatusUpdateStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const ProBookingStatusUpdateStatusEnum completed =
      _$proBookingStatusUpdateStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ProBookingStatusUpdateStatusEnum cancelled =
      _$proBookingStatusUpdateStatusEnum_cancelled;

  static Serializer<ProBookingStatusUpdateStatusEnum> get serializer =>
      _$proBookingStatusUpdateStatusEnumSerializer;

  const ProBookingStatusUpdateStatusEnum._(String name) : super(name);

  static BuiltSet<ProBookingStatusUpdateStatusEnum> get values =>
      _$proBookingStatusUpdateStatusEnumValues;
  static ProBookingStatusUpdateStatusEnum valueOf(String name) =>
      _$proBookingStatusUpdateStatusEnumValueOf(name);
}
