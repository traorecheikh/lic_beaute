//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_inactivity_alerts_inner.g.dart';

/// AdminDashboardInactivityAlertsInner
///
/// Properties:
/// * [salonId]
/// * [salonName]
/// * [daysWithoutBookings]
/// * [city]
/// * [status]
@BuiltValue()
abstract class AdminDashboardInactivityAlertsInner
    implements
        Built<AdminDashboardInactivityAlertsInner,
            AdminDashboardInactivityAlertsInnerBuilder> {
  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'daysWithoutBookings')
  int get daysWithoutBookings;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'status')
  AdminDashboardInactivityAlertsInnerStatusEnum get status;
  // enum statusEnum {  pending_review,  needs_info,  approved,  rejected,  };

  AdminDashboardInactivityAlertsInner._();

  factory AdminDashboardInactivityAlertsInner(
          [void updates(AdminDashboardInactivityAlertsInnerBuilder b)]) =
      _$AdminDashboardInactivityAlertsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardInactivityAlertsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardInactivityAlertsInner> get serializer =>
      _$AdminDashboardInactivityAlertsInnerSerializer();
}

class _$AdminDashboardInactivityAlertsInnerSerializer
    implements PrimitiveSerializer<AdminDashboardInactivityAlertsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardInactivityAlertsInner,
    _$AdminDashboardInactivityAlertsInner
  ];

  @override
  final String wireName = r'AdminDashboardInactivityAlertsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardInactivityAlertsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'salonId';
    yield serializers.serialize(
      object.salonId,
      specifiedType: const FullType(String),
    );
    yield r'salonName';
    yield serializers.serialize(
      object.salonName,
      specifiedType: const FullType(String),
    );
    yield r'daysWithoutBookings';
    yield serializers.serialize(
      object.daysWithoutBookings,
      specifiedType: const FullType(int),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType:
          const FullType(AdminDashboardInactivityAlertsInnerStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardInactivityAlertsInner object, {
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
    required AdminDashboardInactivityAlertsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonId = valueDes;
          break;
        case r'salonName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonName = valueDes;
          break;
        case r'daysWithoutBookings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.daysWithoutBookings = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(AdminDashboardInactivityAlertsInnerStatusEnum),
          ) as AdminDashboardInactivityAlertsInnerStatusEnum;
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
  AdminDashboardInactivityAlertsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardInactivityAlertsInnerBuilder();
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

class AdminDashboardInactivityAlertsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending_review')
  static const AdminDashboardInactivityAlertsInnerStatusEnum pendingReview =
      _$adminDashboardInactivityAlertsInnerStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'needs_info')
  static const AdminDashboardInactivityAlertsInnerStatusEnum needsInfo =
      _$adminDashboardInactivityAlertsInnerStatusEnum_needsInfo;
  @BuiltValueEnumConst(wireName: r'approved')
  static const AdminDashboardInactivityAlertsInnerStatusEnum approved =
      _$adminDashboardInactivityAlertsInnerStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminDashboardInactivityAlertsInnerStatusEnum rejected =
      _$adminDashboardInactivityAlertsInnerStatusEnum_rejected;

  static Serializer<AdminDashboardInactivityAlertsInnerStatusEnum>
      get serializer =>
          _$adminDashboardInactivityAlertsInnerStatusEnumSerializer;

  const AdminDashboardInactivityAlertsInnerStatusEnum._(String name)
      : super(name);

  static BuiltSet<AdminDashboardInactivityAlertsInnerStatusEnum> get values =>
      _$adminDashboardInactivityAlertsInnerStatusEnumValues;
  static AdminDashboardInactivityAlertsInnerStatusEnum valueOf(String name) =>
      _$adminDashboardInactivityAlertsInnerStatusEnumValueOf(name);
}
