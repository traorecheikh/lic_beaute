//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_config_settings_key_patch_request.g.dart';

/// ApiV1AdminConfigSettingsKeyPatchRequest
///
/// Properties:
/// * [value] 
@BuiltValue()
abstract class ApiV1AdminConfigSettingsKeyPatchRequest implements Built<ApiV1AdminConfigSettingsKeyPatchRequest, ApiV1AdminConfigSettingsKeyPatchRequestBuilder> {
  @BuiltValueField(wireName: r'value')
  String get value;

  ApiV1AdminConfigSettingsKeyPatchRequest._();

  factory ApiV1AdminConfigSettingsKeyPatchRequest([void updates(ApiV1AdminConfigSettingsKeyPatchRequestBuilder b)]) = _$ApiV1AdminConfigSettingsKeyPatchRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminConfigSettingsKeyPatchRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminConfigSettingsKeyPatchRequest> get serializer => _$ApiV1AdminConfigSettingsKeyPatchRequestSerializer();
}

class _$ApiV1AdminConfigSettingsKeyPatchRequestSerializer implements PrimitiveSerializer<ApiV1AdminConfigSettingsKeyPatchRequest> {
  @override
  final Iterable<Type> types = const [ApiV1AdminConfigSettingsKeyPatchRequest, _$ApiV1AdminConfigSettingsKeyPatchRequest];

  @override
  final String wireName = r'ApiV1AdminConfigSettingsKeyPatchRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminConfigSettingsKeyPatchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminConfigSettingsKeyPatchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminConfigSettingsKeyPatchRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminConfigSettingsKeyPatchRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminConfigSettingsKeyPatchRequestBuilder();
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

