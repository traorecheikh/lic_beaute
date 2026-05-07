//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_top_growth_salons_inner.g.dart';

/// AdminDashboardTopGrowthSalonsInner
///
/// Properties:
/// * [salonId] 
/// * [salonName] 
/// * [bookingDeltaPercent] 
/// * [bookingsThisWeek] 
/// * [city] 
@BuiltValue()
abstract class AdminDashboardTopGrowthSalonsInner implements Built<AdminDashboardTopGrowthSalonsInner, AdminDashboardTopGrowthSalonsInnerBuilder> {
  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'bookingDeltaPercent')
  num get bookingDeltaPercent;

  @BuiltValueField(wireName: r'bookingsThisWeek')
  int get bookingsThisWeek;

  @BuiltValueField(wireName: r'city')
  String get city;

  AdminDashboardTopGrowthSalonsInner._();

  factory AdminDashboardTopGrowthSalonsInner([void updates(AdminDashboardTopGrowthSalonsInnerBuilder b)]) = _$AdminDashboardTopGrowthSalonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardTopGrowthSalonsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardTopGrowthSalonsInner> get serializer => _$AdminDashboardTopGrowthSalonsInnerSerializer();
}

class _$AdminDashboardTopGrowthSalonsInnerSerializer implements PrimitiveSerializer<AdminDashboardTopGrowthSalonsInner> {
  @override
  final Iterable<Type> types = const [AdminDashboardTopGrowthSalonsInner, _$AdminDashboardTopGrowthSalonsInner];

  @override
  final String wireName = r'AdminDashboardTopGrowthSalonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardTopGrowthSalonsInner object, {
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
    yield r'bookingDeltaPercent';
    yield serializers.serialize(
      object.bookingDeltaPercent,
      specifiedType: const FullType(num),
    );
    yield r'bookingsThisWeek';
    yield serializers.serialize(
      object.bookingsThisWeek,
      specifiedType: const FullType(int),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardTopGrowthSalonsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardTopGrowthSalonsInnerBuilder result,
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
        case r'bookingDeltaPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.bookingDeltaPercent = valueDes;
          break;
        case r'bookingsThisWeek':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookingsThisWeek = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardTopGrowthSalonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardTopGrowthSalonsInnerBuilder();
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

