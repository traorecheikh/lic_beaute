//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_config_documents_post_request.g.dart';

/// ApiV1AdminConfigDocumentsPostRequest
///
/// Properties:
/// * [label] 
/// * [slug] 
/// * [type] 
/// * [isRequired] 
/// * [enabled] 
@BuiltValue()
abstract class ApiV1AdminConfigDocumentsPostRequest implements Built<ApiV1AdminConfigDocumentsPostRequest, ApiV1AdminConfigDocumentsPostRequestBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'isRequired')
  bool get isRequired;

  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  ApiV1AdminConfigDocumentsPostRequest._();

  factory ApiV1AdminConfigDocumentsPostRequest([void updates(ApiV1AdminConfigDocumentsPostRequestBuilder b)]) = _$ApiV1AdminConfigDocumentsPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminConfigDocumentsPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminConfigDocumentsPostRequest> get serializer => _$ApiV1AdminConfigDocumentsPostRequestSerializer();
}

class _$ApiV1AdminConfigDocumentsPostRequestSerializer implements PrimitiveSerializer<ApiV1AdminConfigDocumentsPostRequest> {
  @override
  final Iterable<Type> types = const [ApiV1AdminConfigDocumentsPostRequest, _$ApiV1AdminConfigDocumentsPostRequest];

  @override
  final String wireName = r'ApiV1AdminConfigDocumentsPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminConfigDocumentsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'isRequired';
    yield serializers.serialize(
      object.isRequired,
      specifiedType: const FullType(bool),
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
    ApiV1AdminConfigDocumentsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminConfigDocumentsPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'isRequired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isRequired = valueDes;
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
  ApiV1AdminConfigDocumentsPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminConfigDocumentsPostRequestBuilder();
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

