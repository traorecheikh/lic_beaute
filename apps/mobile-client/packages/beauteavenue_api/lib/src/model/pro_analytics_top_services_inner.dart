//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_analytics_top_services_inner.g.dart';

/// ProAnalyticsTopServicesInner
///
/// Properties:
/// * [serviceId] 
/// * [serviceName] 
/// * [bookingCount] 
@BuiltValue()
abstract class ProAnalyticsTopServicesInner implements Built<ProAnalyticsTopServicesInner, ProAnalyticsTopServicesInnerBuilder> {
  @BuiltValueField(wireName: r'serviceId')
  String get serviceId;

  @BuiltValueField(wireName: r'serviceName')
  String get serviceName;

  @BuiltValueField(wireName: r'bookingCount')
  int get bookingCount;

  ProAnalyticsTopServicesInner._();

  factory ProAnalyticsTopServicesInner([void updates(ProAnalyticsTopServicesInnerBuilder b)]) = _$ProAnalyticsTopServicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProAnalyticsTopServicesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProAnalyticsTopServicesInner> get serializer => _$ProAnalyticsTopServicesInnerSerializer();
}

class _$ProAnalyticsTopServicesInnerSerializer implements PrimitiveSerializer<ProAnalyticsTopServicesInner> {
  @override
  final Iterable<Type> types = const [ProAnalyticsTopServicesInner, _$ProAnalyticsTopServicesInner];

  @override
  final String wireName = r'ProAnalyticsTopServicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProAnalyticsTopServicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'bookingCount';
    yield serializers.serialize(
      object.bookingCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProAnalyticsTopServicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProAnalyticsTopServicesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'bookingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookingCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProAnalyticsTopServicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProAnalyticsTopServicesInnerBuilder();
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

