//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_dashboard.g.dart';

/// ProDashboard
///
/// Properties:
/// * [pendingBookingCount] 
/// * [todayBookingCount] 
/// * [totalRevenueXof] 
@BuiltValue()
abstract class ProDashboard implements Built<ProDashboard, ProDashboardBuilder> {
  @BuiltValueField(wireName: r'pendingBookingCount')
  int get pendingBookingCount;

  @BuiltValueField(wireName: r'todayBookingCount')
  int get todayBookingCount;

  @BuiltValueField(wireName: r'totalRevenueXof')
  int? get totalRevenueXof;

  ProDashboard._();

  factory ProDashboard([void updates(ProDashboardBuilder b)]) = _$ProDashboard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProDashboardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProDashboard> get serializer => _$ProDashboardSerializer();
}

class _$ProDashboardSerializer implements PrimitiveSerializer<ProDashboard> {
  @override
  final Iterable<Type> types = const [ProDashboard, _$ProDashboard];

  @override
  final String wireName = r'ProDashboard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pendingBookingCount';
    yield serializers.serialize(
      object.pendingBookingCount,
      specifiedType: const FullType(int),
    );
    yield r'todayBookingCount';
    yield serializers.serialize(
      object.todayBookingCount,
      specifiedType: const FullType(int),
    );
    yield r'totalRevenueXof';
    yield object.totalRevenueXof == null ? null : serializers.serialize(
      object.totalRevenueXof,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProDashboardBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pendingBookingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingBookingCount = valueDes;
          break;
        case r'todayBookingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.todayBookingCount = valueDes;
          break;
        case r'totalRevenueXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalRevenueXof = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProDashboard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProDashboardBuilder();
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

