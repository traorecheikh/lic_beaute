//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'push_token_input.g.dart';

/// PushTokenInput
///
/// Properties:
/// * [token] 
/// * [platform] 
/// * [deviceId] 
@BuiltValue()
abstract class PushTokenInput implements Built<PushTokenInput, PushTokenInputBuilder> {
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'platform')
  PushTokenInputPlatformEnum get platform;
  // enum platformEnum {  ios,  android,  };

  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  PushTokenInput._();

  factory PushTokenInput([void updates(PushTokenInputBuilder b)]) = _$PushTokenInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PushTokenInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PushTokenInput> get serializer => _$PushTokenInputSerializer();
}

class _$PushTokenInputSerializer implements PrimitiveSerializer<PushTokenInput> {
  @override
  final Iterable<Type> types = const [PushTokenInput, _$PushTokenInput];

  @override
  final String wireName = r'PushTokenInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PushTokenInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(PushTokenInputPlatformEnum),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PushTokenInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PushTokenInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PushTokenInputPlatformEnum),
          ) as PushTokenInputPlatformEnum;
          result.platform = valueDes;
          break;
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PushTokenInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PushTokenInputBuilder();
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

class PushTokenInputPlatformEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ios')
  static const PushTokenInputPlatformEnum ios = _$pushTokenInputPlatformEnum_ios;
  @BuiltValueEnumConst(wireName: r'android')
  static const PushTokenInputPlatformEnum android = _$pushTokenInputPlatformEnum_android;

  static Serializer<PushTokenInputPlatformEnum> get serializer => _$pushTokenInputPlatformEnumSerializer;

  const PushTokenInputPlatformEnum._(String name): super(name);

  static BuiltSet<PushTokenInputPlatformEnum> get values => _$pushTokenInputPlatformEnumValues;
  static PushTokenInputPlatformEnum valueOf(String name) => _$pushTokenInputPlatformEnumValueOf(name);
}

