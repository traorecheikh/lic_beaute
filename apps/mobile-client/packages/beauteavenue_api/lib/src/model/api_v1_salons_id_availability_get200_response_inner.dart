//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_salons_id_availability_get200_response_inner.g.dart';

/// ApiV1SalonsIdAvailabilityGet200ResponseInner
///
/// Properties:
/// * [startsAt] 
/// * [endsAt] 
/// * [employeeId] 
@BuiltValue()
abstract class ApiV1SalonsIdAvailabilityGet200ResponseInner implements Built<ApiV1SalonsIdAvailabilityGet200ResponseInner, ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder> {
  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'employeeId')
  String? get employeeId;

  ApiV1SalonsIdAvailabilityGet200ResponseInner._();

  factory ApiV1SalonsIdAvailabilityGet200ResponseInner([void updates(ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder b)]) = _$ApiV1SalonsIdAvailabilityGet200ResponseInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SalonsIdAvailabilityGet200ResponseInner> get serializer => _$ApiV1SalonsIdAvailabilityGet200ResponseInnerSerializer();
}

class _$ApiV1SalonsIdAvailabilityGet200ResponseInnerSerializer implements PrimitiveSerializer<ApiV1SalonsIdAvailabilityGet200ResponseInner> {
  @override
  final Iterable<Type> types = const [ApiV1SalonsIdAvailabilityGet200ResponseInner, _$ApiV1SalonsIdAvailabilityGet200ResponseInner];

  @override
  final String wireName = r'ApiV1SalonsIdAvailabilityGet200ResponseInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SalonsIdAvailabilityGet200ResponseInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'employeeId';
    yield object.employeeId == null ? null : serializers.serialize(
      object.employeeId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1SalonsIdAvailabilityGet200ResponseInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.employeeId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1SalonsIdAvailabilityGet200ResponseInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder();
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

