//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/pro_analytics_top_services_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_analytics.g.dart';

/// ProAnalytics
///
/// Properties:
/// * [period]
/// * [bookingCount]
/// * [completedCount]
/// * [occupancyPercent]
/// * [totalRevenueXof]
/// * [topServices]
@BuiltValue()
abstract class ProAnalytics
    implements Built<ProAnalytics, ProAnalyticsBuilder> {
  @BuiltValueField(wireName: r'period')
  String get period;

  @BuiltValueField(wireName: r'bookingCount')
  int get bookingCount;

  @BuiltValueField(wireName: r'completedCount')
  int get completedCount;

  @BuiltValueField(wireName: r'occupancyPercent')
  num get occupancyPercent;

  @BuiltValueField(wireName: r'totalRevenueXof')
  int get totalRevenueXof;

  @BuiltValueField(wireName: r'topServices')
  BuiltList<ProAnalyticsTopServicesInner> get topServices;

  ProAnalytics._();

  factory ProAnalytics([void updates(ProAnalyticsBuilder b)]) = _$ProAnalytics;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProAnalyticsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProAnalytics> get serializer => _$ProAnalyticsSerializer();
}

class _$ProAnalyticsSerializer implements PrimitiveSerializer<ProAnalytics> {
  @override
  final Iterable<Type> types = const [ProAnalytics, _$ProAnalytics];

  @override
  final String wireName = r'ProAnalytics';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProAnalytics object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(String),
    );
    yield r'bookingCount';
    yield serializers.serialize(
      object.bookingCount,
      specifiedType: const FullType(int),
    );
    yield r'completedCount';
    yield serializers.serialize(
      object.completedCount,
      specifiedType: const FullType(int),
    );
    yield r'occupancyPercent';
    yield serializers.serialize(
      object.occupancyPercent,
      specifiedType: const FullType(num),
    );
    yield r'totalRevenueXof';
    yield serializers.serialize(
      object.totalRevenueXof,
      specifiedType: const FullType(int),
    );
    yield r'topServices';
    yield serializers.serialize(
      object.topServices,
      specifiedType:
          const FullType(BuiltList, [FullType(ProAnalyticsTopServicesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProAnalytics object, {
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
    required ProAnalyticsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.period = valueDes;
          break;
        case r'bookingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookingCount = valueDes;
          break;
        case r'completedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completedCount = valueDes;
          break;
        case r'occupancyPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.occupancyPercent = valueDes;
          break;
        case r'totalRevenueXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalRevenueXof = valueDes;
          break;
        case r'topServices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(ProAnalyticsTopServicesInner)]),
          ) as BuiltList<ProAnalyticsTopServicesInner>;
          result.topServices.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProAnalytics deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProAnalyticsBuilder();
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
