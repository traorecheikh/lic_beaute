//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_quick_links.g.dart';

/// AdminDashboardQuickLinks
///
/// Properties:
/// * [pendingSalonApprovals]
/// * [subscriptionsNeedingAction]
/// * [auditEventsToday]
@BuiltValue()
abstract class AdminDashboardQuickLinks
    implements
        Built<AdminDashboardQuickLinks, AdminDashboardQuickLinksBuilder> {
  @BuiltValueField(wireName: r'pendingSalonApprovals')
  int get pendingSalonApprovals;

  @BuiltValueField(wireName: r'subscriptionsNeedingAction')
  int get subscriptionsNeedingAction;

  @BuiltValueField(wireName: r'auditEventsToday')
  int get auditEventsToday;

  AdminDashboardQuickLinks._();

  factory AdminDashboardQuickLinks(
          [void updates(AdminDashboardQuickLinksBuilder b)]) =
      _$AdminDashboardQuickLinks;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardQuickLinksBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardQuickLinks> get serializer =>
      _$AdminDashboardQuickLinksSerializer();
}

class _$AdminDashboardQuickLinksSerializer
    implements PrimitiveSerializer<AdminDashboardQuickLinks> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardQuickLinks,
    _$AdminDashboardQuickLinks
  ];

  @override
  final String wireName = r'AdminDashboardQuickLinks';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardQuickLinks object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pendingSalonApprovals';
    yield serializers.serialize(
      object.pendingSalonApprovals,
      specifiedType: const FullType(int),
    );
    yield r'subscriptionsNeedingAction';
    yield serializers.serialize(
      object.subscriptionsNeedingAction,
      specifiedType: const FullType(int),
    );
    yield r'auditEventsToday';
    yield serializers.serialize(
      object.auditEventsToday,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardQuickLinks object, {
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
    required AdminDashboardQuickLinksBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pendingSalonApprovals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingSalonApprovals = valueDes;
          break;
        case r'subscriptionsNeedingAction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.subscriptionsNeedingAction = valueDes;
          break;
        case r'auditEventsToday':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.auditEventsToday = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardQuickLinks deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardQuickLinksBuilder();
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
