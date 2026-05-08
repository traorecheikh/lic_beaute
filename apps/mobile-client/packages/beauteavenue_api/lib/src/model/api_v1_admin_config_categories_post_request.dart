//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_config_categories_post_request.g.dart';

/// ApiV1AdminConfigCategoriesPostRequest
///
/// Properties:
/// * [name] 
/// * [slug] 
/// * [enabled] 
@BuiltValue()
abstract class ApiV1AdminConfigCategoriesPostRequest implements Built<ApiV1AdminConfigCategoriesPostRequest, ApiV1AdminConfigCategoriesPostRequestBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  ApiV1AdminConfigCategoriesPostRequest._();

  factory ApiV1AdminConfigCategoriesPostRequest([void updates(ApiV1AdminConfigCategoriesPostRequestBuilder b)]) = _$ApiV1AdminConfigCategoriesPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminConfigCategoriesPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminConfigCategoriesPostRequest> get serializer => _$ApiV1AdminConfigCategoriesPostRequestSerializer();
}

class _$ApiV1AdminConfigCategoriesPostRequestSerializer implements PrimitiveSerializer<ApiV1AdminConfigCategoriesPostRequest> {
  @override
  final Iterable<Type> types = const [ApiV1AdminConfigCategoriesPostRequest, _$ApiV1AdminConfigCategoriesPostRequest];

  @override
  final String wireName = r'ApiV1AdminConfigCategoriesPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminConfigCategoriesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminConfigCategoriesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminConfigCategoriesPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminConfigCategoriesPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminConfigCategoriesPostRequestBuilder();
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

