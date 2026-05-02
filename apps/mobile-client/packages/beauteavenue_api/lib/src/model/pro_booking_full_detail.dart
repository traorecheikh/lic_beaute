//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/pro_booking_full_detail_payments_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/pro_booking_full_detail_events_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_booking_full_detail.g.dart';

/// ProBookingFullDetail
///
/// Properties:
/// * [id]
/// * [salonId]
/// * [serviceId]
/// * [serviceName]
/// * [employeeId]
/// * [employeeName]
/// * [clientId]
/// * [clientName]
/// * [clientPhone]
/// * [startsAt]
/// * [endsAt]
/// * [status]
/// * [source_]
/// * [depositAmountXof]
/// * [createdAt]
/// * [payments]
/// * [events]
@BuiltValue()
abstract class ProBookingFullDetail
    implements Built<ProBookingFullDetail, ProBookingFullDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'serviceId')
  String get serviceId;

  @BuiltValueField(wireName: r'serviceName')
  String get serviceName;

  @BuiltValueField(wireName: r'employeeId')
  String? get employeeId;

  @BuiltValueField(wireName: r'employeeName')
  String? get employeeName;

  @BuiltValueField(wireName: r'clientId')
  String? get clientId;

  @BuiltValueField(wireName: r'clientName')
  String? get clientName;

  @BuiltValueField(wireName: r'clientPhone')
  String? get clientPhone;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'status')
  ProBookingFullDetailStatusEnum get status;
  // enum statusEnum {  pending,  confirmed,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'depositAmountXof')
  num get depositAmountXof;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'payments')
  BuiltList<ProBookingFullDetailPaymentsInner> get payments;

  @BuiltValueField(wireName: r'events')
  BuiltList<ProBookingFullDetailEventsInner> get events;

  ProBookingFullDetail._();

  factory ProBookingFullDetail([void updates(ProBookingFullDetailBuilder b)]) =
      _$ProBookingFullDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProBookingFullDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProBookingFullDetail> get serializer =>
      _$ProBookingFullDetailSerializer();
}

class _$ProBookingFullDetailSerializer
    implements PrimitiveSerializer<ProBookingFullDetail> {
  @override
  final Iterable<Type> types = const [
    ProBookingFullDetail,
    _$ProBookingFullDetail
  ];

  @override
  final String wireName = r'ProBookingFullDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProBookingFullDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'salonId';
    yield serializers.serialize(
      object.salonId,
      specifiedType: const FullType(String),
    );
    yield r'serviceId';
    yield serializers.serialize(
      object.serviceId,
      specifiedType: const FullType(String),
    );
    yield r'serviceName';
    yield serializers.serialize(
      object.serviceName,
      specifiedType: const FullType(String),
    );
    yield r'employeeId';
    yield object.employeeId == null
        ? null
        : serializers.serialize(
            object.employeeId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'employeeName';
    yield object.employeeName == null
        ? null
        : serializers.serialize(
            object.employeeName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'clientId';
    yield object.clientId == null
        ? null
        : serializers.serialize(
            object.clientId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'clientName';
    yield object.clientName == null
        ? null
        : serializers.serialize(
            object.clientName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'clientPhone';
    yield object.clientPhone == null
        ? null
        : serializers.serialize(
            object.clientPhone,
            specifiedType: const FullType.nullable(String),
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
      specifiedType: const FullType(ProBookingFullDetailStatusEnum),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(String),
    );
    yield r'depositAmountXof';
    yield serializers.serialize(
      object.depositAmountXof,
      specifiedType: const FullType(num),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'payments';
    yield serializers.serialize(
      object.payments,
      specifiedType: const FullType(
          BuiltList, [FullType(ProBookingFullDetailPaymentsInner)]),
    );
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(
          BuiltList, [FullType(ProBookingFullDetailEventsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProBookingFullDetail object, {
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
    required ProBookingFullDetailBuilder result,
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
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonId = valueDes;
          break;
        case r'serviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serviceId = valueDes;
          break;
        case r'serviceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serviceName = valueDes;
          break;
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.employeeId = valueDes;
          break;
        case r'employeeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.employeeName = valueDes;
          break;
        case r'clientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.clientId = valueDes;
          break;
        case r'clientName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.clientName = valueDes;
          break;
        case r'clientPhone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.clientPhone = valueDes;
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
            specifiedType: const FullType(ProBookingFullDetailStatusEnum),
          ) as ProBookingFullDetailStatusEnum;
          result.status = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.source_ = valueDes;
          break;
        case r'depositAmountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.depositAmountXof = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(ProBookingFullDetailPaymentsInner)]),
          ) as BuiltList<ProBookingFullDetailPaymentsInner>;
          result.payments.replace(valueDes);
          break;
        case r'events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(ProBookingFullDetailEventsInner)]),
          ) as BuiltList<ProBookingFullDetailEventsInner>;
          result.events.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProBookingFullDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProBookingFullDetailBuilder();
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

class ProBookingFullDetailStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const ProBookingFullDetailStatusEnum pending =
      _$proBookingFullDetailStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const ProBookingFullDetailStatusEnum confirmed =
      _$proBookingFullDetailStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const ProBookingFullDetailStatusEnum inProgress =
      _$proBookingFullDetailStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const ProBookingFullDetailStatusEnum completed =
      _$proBookingFullDetailStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ProBookingFullDetailStatusEnum cancelled =
      _$proBookingFullDetailStatusEnum_cancelled;

  static Serializer<ProBookingFullDetailStatusEnum> get serializer =>
      _$proBookingFullDetailStatusEnumSerializer;

  const ProBookingFullDetailStatusEnum._(String name) : super(name);

  static BuiltSet<ProBookingFullDetailStatusEnum> get values =>
      _$proBookingFullDetailStatusEnumValues;
  static ProBookingFullDetailStatusEnum valueOf(String name) =>
      _$proBookingFullDetailStatusEnumValueOf(name);
}
