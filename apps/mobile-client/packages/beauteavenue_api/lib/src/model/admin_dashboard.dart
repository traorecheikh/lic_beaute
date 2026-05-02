//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/admin_dashboard_kpis_inner.dart';
import 'package:beauteavenue_api/src/model/admin_dashboard_inactivity_alerts_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/admin_dashboard_quick_links.dart';
import 'package:beauteavenue_api/src/model/admin_dashboard_top_growth_salons_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard.g.dart';

/// AdminDashboard
///
/// Properties:
/// * [kpis]
/// * [topGrowthSalons]
/// * [inactivityAlerts]
/// * [quickLinks]
@BuiltValue()
abstract class AdminDashboard
    implements Built<AdminDashboard, AdminDashboardBuilder> {
  @BuiltValueField(wireName: r'kpis')
  BuiltList<AdminDashboardKpisInner> get kpis;

  @BuiltValueField(wireName: r'topGrowthSalons')
  BuiltList<AdminDashboardTopGrowthSalonsInner> get topGrowthSalons;

  @BuiltValueField(wireName: r'inactivityAlerts')
  BuiltList<AdminDashboardInactivityAlertsInner> get inactivityAlerts;

  @BuiltValueField(wireName: r'quickLinks')
  AdminDashboardQuickLinks get quickLinks;

  AdminDashboard._();

  factory AdminDashboard([void updates(AdminDashboardBuilder b)]) =
      _$AdminDashboard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboard> get serializer =>
      _$AdminDashboardSerializer();
}

class _$AdminDashboardSerializer
    implements PrimitiveSerializer<AdminDashboard> {
  @override
  final Iterable<Type> types = const [AdminDashboard, _$AdminDashboard];

  @override
  final String wireName = r'AdminDashboard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kpis';
    yield serializers.serialize(
      object.kpis,
      specifiedType:
          const FullType(BuiltList, [FullType(AdminDashboardKpisInner)]),
    );
    yield r'topGrowthSalons';
    yield serializers.serialize(
      object.topGrowthSalons,
      specifiedType: const FullType(
          BuiltList, [FullType(AdminDashboardTopGrowthSalonsInner)]),
    );
    yield r'inactivityAlerts';
    yield serializers.serialize(
      object.inactivityAlerts,
      specifiedType: const FullType(
          BuiltList, [FullType(AdminDashboardInactivityAlertsInner)]),
    );
    yield r'quickLinks';
    yield serializers.serialize(
      object.quickLinks,
      specifiedType: const FullType(AdminDashboardQuickLinks),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboard object, {
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
    required AdminDashboardBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kpis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(AdminDashboardKpisInner)]),
          ) as BuiltList<AdminDashboardKpisInner>;
          result.kpis.replace(valueDes);
          break;
        case r'topGrowthSalons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(AdminDashboardTopGrowthSalonsInner)]),
          ) as BuiltList<AdminDashboardTopGrowthSalonsInner>;
          result.topGrowthSalons.replace(valueDes);
          break;
        case r'inactivityAlerts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(AdminDashboardInactivityAlertsInner)]),
          ) as BuiltList<AdminDashboardInactivityAlertsInner>;
          result.inactivityAlerts.replace(valueDes);
          break;
        case r'quickLinks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardQuickLinks),
          ) as AdminDashboardQuickLinks;
          result.quickLinks.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardBuilder();
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
