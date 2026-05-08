//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_config_documents_get200_response_inner.g.dart';

/// ApiV1AdminConfigDocumentsGet200ResponseInner
///
/// Properties:
/// * [id] 
/// * [label] 
/// * [slug] 
/// * [type] 
/// * [isRequired] 
/// * [enabled] 
/// * [createdAt] 
@BuiltValue()
abstract class ApiV1AdminConfigDocumentsGet200ResponseInner implements Built<ApiV1AdminConfigDocumentsGet200ResponseInner, ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'isRequired')
  bool get isRequired;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ApiV1AdminConfigDocumentsGet200ResponseInner._();

  factory ApiV1AdminConfigDocumentsGet200ResponseInner([void updates(ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder b)]) = _$ApiV1AdminConfigDocumentsGet200ResponseInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminConfigDocumentsGet200ResponseInner> get serializer => _$ApiV1AdminConfigDocumentsGet200ResponseInnerSerializer();
}

class _$ApiV1AdminConfigDocumentsGet200ResponseInnerSerializer implements PrimitiveSerializer<ApiV1AdminConfigDocumentsGet200ResponseInner> {
  @override
  final Iterable<Type> types = const [ApiV1AdminConfigDocumentsGet200ResponseInner, _$ApiV1AdminConfigDocumentsGet200ResponseInner];

  @override
  final String wireName = r'ApiV1AdminConfigDocumentsGet200ResponseInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminConfigDocumentsGet200ResponseInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminConfigDocumentsGet200ResponseInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder result,
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminConfigDocumentsGet200ResponseInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder();
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

