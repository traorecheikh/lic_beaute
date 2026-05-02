//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_booking_detail.g.dart';

/// ProBookingDetail
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
@BuiltValue()
abstract class ProBookingDetail
    implements Built<ProBookingDetail, ProBookingDetailBuilder> {
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
  ProBookingDetailStatusEnum get status;
  // enum statusEnum {  pending,  confirmed,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'depositAmountXof')
  num get depositAmountXof;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ProBookingDetail._();

  factory ProBookingDetail([void updates(ProBookingDetailBuilder b)]) =
      _$ProBookingDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProBookingDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProBookingDetail> get serializer =>
      _$ProBookingDetailSerializer();
}

class _$ProBookingDetailSerializer
    implements PrimitiveSerializer<ProBookingDetail> {
  @override
  final Iterable<Type> types = const [ProBookingDetail, _$ProBookingDetail];

  @override
  final String wireName = r'ProBookingDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProBookingDetail object, {
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
      specifiedType: const FullType(ProBookingDetailStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ProBookingDetail object, {
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
    required ProBookingDetailBuilder result,
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
            specifiedType: const FullType(ProBookingDetailStatusEnum),
          ) as ProBookingDetailStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProBookingDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProBookingDetailBuilder();
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

class ProBookingDetailStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const ProBookingDetailStatusEnum pending =
      _$proBookingDetailStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const ProBookingDetailStatusEnum confirmed =
      _$proBookingDetailStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const ProBookingDetailStatusEnum inProgress =
      _$proBookingDetailStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const ProBookingDetailStatusEnum completed =
      _$proBookingDetailStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ProBookingDetailStatusEnum cancelled =
      _$proBookingDetailStatusEnum_cancelled;

  static Serializer<ProBookingDetailStatusEnum> get serializer =>
      _$proBookingDetailStatusEnumSerializer;

  const ProBookingDetailStatusEnum._(String name) : super(name);

  static BuiltSet<ProBookingDetailStatusEnum> get values =>
      _$proBookingDetailStatusEnumValues;
  static ProBookingDetailStatusEnum valueOf(String name) =>
      _$proBookingDetailStatusEnumValueOf(name);
}
