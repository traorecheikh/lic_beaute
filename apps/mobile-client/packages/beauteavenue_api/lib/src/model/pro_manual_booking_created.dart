//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_manual_booking_created.g.dart';

/// ProManualBookingCreated
///
/// Properties:
/// * [id]
/// * [startsAt]
/// * [endsAt]
/// * [status]
/// * [source_]
@BuiltValue()
abstract class ProManualBookingCreated
    implements Built<ProManualBookingCreated, ProManualBookingCreatedBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'status')
  ProManualBookingCreatedStatusEnum get status;
  // enum statusEnum {  pending,  confirmed,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'source')
  String get source_;

  ProManualBookingCreated._();

  factory ProManualBookingCreated(
          [void updates(ProManualBookingCreatedBuilder b)]) =
      _$ProManualBookingCreated;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProManualBookingCreatedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProManualBookingCreated> get serializer =>
      _$ProManualBookingCreatedSerializer();
}

class _$ProManualBookingCreatedSerializer
    implements PrimitiveSerializer<ProManualBookingCreated> {
  @override
  final Iterable<Type> types = const [
    ProManualBookingCreated,
    _$ProManualBookingCreated
  ];

  @override
  final String wireName = r'ProManualBookingCreated';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProManualBookingCreated object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProManualBookingCreatedStatusEnum),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProManualBookingCreated object, {
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
    required ProManualBookingCreatedBuilder result,
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
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endsAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProManualBookingCreatedStatusEnum),
          ) as ProManualBookingCreatedStatusEnum;
          result.status = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProManualBookingCreated deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProManualBookingCreatedBuilder();
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

class ProManualBookingCreatedStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const ProManualBookingCreatedStatusEnum pending =
      _$proManualBookingCreatedStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const ProManualBookingCreatedStatusEnum confirmed =
      _$proManualBookingCreatedStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const ProManualBookingCreatedStatusEnum inProgress =
      _$proManualBookingCreatedStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const ProManualBookingCreatedStatusEnum completed =
      _$proManualBookingCreatedStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ProManualBookingCreatedStatusEnum cancelled =
      _$proManualBookingCreatedStatusEnum_cancelled;

  static Serializer<ProManualBookingCreatedStatusEnum> get serializer =>
      _$proManualBookingCreatedStatusEnumSerializer;

  const ProManualBookingCreatedStatusEnum._(String name) : super(name);

  static BuiltSet<ProManualBookingCreatedStatusEnum> get values =>
      _$proManualBookingCreatedStatusEnumValues;
  static ProManualBookingCreatedStatusEnum valueOf(String name) =>
      _$proManualBookingCreatedStatusEnumValueOf(name);
}
