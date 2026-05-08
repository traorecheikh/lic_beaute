//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_config_settings_get200_response_inner.g.dart';

/// ApiV1AdminConfigSettingsGet200ResponseInner
///
/// Properties:
/// * [id] 
/// * [group] 
/// * [key] 
/// * [value] 
/// * [description] 
/// * [updatedAt] 
@BuiltValue()
abstract class ApiV1AdminConfigSettingsGet200ResponseInner implements Built<ApiV1AdminConfigSettingsGet200ResponseInner, ApiV1AdminConfigSettingsGet200ResponseInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'group')
  String get group;

  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'value')
  String get value;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  ApiV1AdminConfigSettingsGet200ResponseInner._();

  factory ApiV1AdminConfigSettingsGet200ResponseInner([void updates(ApiV1AdminConfigSettingsGet200ResponseInnerBuilder b)]) = _$ApiV1AdminConfigSettingsGet200ResponseInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminConfigSettingsGet200ResponseInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminConfigSettingsGet200ResponseInner> get serializer => _$ApiV1AdminConfigSettingsGet200ResponseInnerSerializer();
}

class _$ApiV1AdminConfigSettingsGet200ResponseInnerSerializer implements PrimitiveSerializer<ApiV1AdminConfigSettingsGet200ResponseInner> {
  @override
  final Iterable<Type> types = const [ApiV1AdminConfigSettingsGet200ResponseInner, _$ApiV1AdminConfigSettingsGet200ResponseInner];

  @override
  final String wireName = r'ApiV1AdminConfigSettingsGet200ResponseInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminConfigSettingsGet200ResponseInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'group';
    yield serializers.serialize(
      object.group,
      specifiedType: const FullType(String),
    );
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminConfigSettingsGet200ResponseInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminConfigSettingsGet200ResponseInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.group = valueDes;
          break;
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminConfigSettingsGet200ResponseInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminConfigSettingsGet200ResponseInnerBuilder();
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

