//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_client_detail_recent_bookings_inner.g.dart';

/// ProClientDetailRecentBookingsInner
///
/// Properties:
/// * [bookingId] 
/// * [startsAt] 
/// * [serviceName] 
/// * [amountXof] 
/// * [status] 
@BuiltValue()
abstract class ProClientDetailRecentBookingsInner implements Built<ProClientDetailRecentBookingsInner, ProClientDetailRecentBookingsInnerBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'serviceName')
  String get serviceName;

  @BuiltValueField(wireName: r'amountXof')
  int get amountXof;

  @BuiltValueField(wireName: r'status')
  ProClientDetailRecentBookingsInnerStatusEnum get status;
  // enum statusEnum {  pending,  confirmed,  in_progress,  completed,  cancelled,  };

  ProClientDetailRecentBookingsInner._();

  factory ProClientDetailRecentBookingsInner([void updates(ProClientDetailRecentBookingsInnerBuilder b)]) = _$ProClientDetailRecentBookingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProClientDetailRecentBookingsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProClientDetailRecentBookingsInner> get serializer => _$ProClientDetailRecentBookingsInnerSerializer();
}

class _$ProClientDetailRecentBookingsInnerSerializer implements PrimitiveSerializer<ProClientDetailRecentBookingsInner> {
  @override
  final Iterable<Type> types = const [ProClientDetailRecentBookingsInner, _$ProClientDetailRecentBookingsInner];

  @override
  final String wireName = r'ProClientDetailRecentBookingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProClientDetailRecentBookingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'serviceName';
    yield serializers.serialize(
      object.serviceName,
      specifiedType: const FullType(String),
    );
    yield r'amountXof';
    yield serializers.serialize(
      object.amountXof,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProClientDetailRecentBookingsInnerStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProClientDetailRecentBookingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProClientDetailRecentBookingsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'serviceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serviceName = valueDes;
          break;
        case r'amountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountXof = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProClientDetailRecentBookingsInnerStatusEnum),
          ) as ProClientDetailRecentBookingsInnerStatusEnum;
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
  ProClientDetailRecentBookingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProClientDetailRecentBookingsInnerBuilder();
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

class ProClientDetailRecentBookingsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending')
  static const ProClientDetailRecentBookingsInnerStatusEnum pending = _$proClientDetailRecentBookingsInnerStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const ProClientDetailRecentBookingsInnerStatusEnum confirmed = _$proClientDetailRecentBookingsInnerStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const ProClientDetailRecentBookingsInnerStatusEnum inProgress = _$proClientDetailRecentBookingsInnerStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const ProClientDetailRecentBookingsInnerStatusEnum completed = _$proClientDetailRecentBookingsInnerStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ProClientDetailRecentBookingsInnerStatusEnum cancelled = _$proClientDetailRecentBookingsInnerStatusEnum_cancelled;

  static Serializer<ProClientDetailRecentBookingsInnerStatusEnum> get serializer => _$proClientDetailRecentBookingsInnerStatusEnumSerializer;

  const ProClientDetailRecentBookingsInnerStatusEnum._(String name): super(name);

  static BuiltSet<ProClientDetailRecentBookingsInnerStatusEnum> get values => _$proClientDetailRecentBookingsInnerStatusEnumValues;
  static ProClientDetailRecentBookingsInnerStatusEnum valueOf(String name) => _$proClientDetailRecentBookingsInnerStatusEnumValueOf(name);
}

