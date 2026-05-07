//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'health_get200_response_database.g.dart';

/// HealthGet200ResponseDatabase
///
/// Properties:
/// * [driver] 
/// * [mode] 
/// * [attempts] 
@BuiltValue()
abstract class HealthGet200ResponseDatabase implements Built<HealthGet200ResponseDatabase, HealthGet200ResponseDatabaseBuilder> {
  @BuiltValueField(wireName: r'driver')
  String? get driver;

  @BuiltValueField(wireName: r'mode')
  String? get mode;

  @BuiltValueField(wireName: r'attempts')
  int? get attempts;

  HealthGet200ResponseDatabase._();

  factory HealthGet200ResponseDatabase([void updates(HealthGet200ResponseDatabaseBuilder b)]) = _$HealthGet200ResponseDatabase;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HealthGet200ResponseDatabaseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HealthGet200ResponseDatabase> get serializer => _$HealthGet200ResponseDatabaseSerializer();
}

class _$HealthGet200ResponseDatabaseSerializer implements PrimitiveSerializer<HealthGet200ResponseDatabase> {
  @override
  final Iterable<Type> types = const [HealthGet200ResponseDatabase, _$HealthGet200ResponseDatabase];

  @override
  final String wireName = r'HealthGet200ResponseDatabase';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HealthGet200ResponseDatabase object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.driver != null) {
      yield r'driver';
      yield serializers.serialize(
        object.driver,
        specifiedType: const FullType(String),
      );
    }
    if (object.mode != null) {
      yield r'mode';
      yield serializers.serialize(
        object.mode,
        specifiedType: const FullType(String),
      );
    }
    if (object.attempts != null) {
      yield r'attempts';
      yield serializers.serialize(
        object.attempts,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    HealthGet200ResponseDatabase object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HealthGet200ResponseDatabaseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'driver':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.driver = valueDes;
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mode = valueDes;
          break;
        case r'attempts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attempts = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HealthGet200ResponseDatabase deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HealthGet200ResponseDatabaseBuilder();
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

