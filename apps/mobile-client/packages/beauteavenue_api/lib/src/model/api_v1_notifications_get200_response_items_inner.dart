//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_notifications_get200_response_items_inner.g.dart';

/// ApiV1NotificationsGet200ResponseItemsInner
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [body] 
/// * [channel] 
/// * [readAt] 
/// * [createdAt] 
@BuiltValue()
abstract class ApiV1NotificationsGet200ResponseItemsInner implements Built<ApiV1NotificationsGet200ResponseItemsInner, ApiV1NotificationsGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'channel')
  String get channel;

  @BuiltValueField(wireName: r'readAt')
  String? get readAt;

  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  ApiV1NotificationsGet200ResponseItemsInner._();

  factory ApiV1NotificationsGet200ResponseItemsInner([void updates(ApiV1NotificationsGet200ResponseItemsInnerBuilder b)]) = _$ApiV1NotificationsGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1NotificationsGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1NotificationsGet200ResponseItemsInner> get serializer => _$ApiV1NotificationsGet200ResponseItemsInnerSerializer();
}

class _$ApiV1NotificationsGet200ResponseItemsInnerSerializer implements PrimitiveSerializer<ApiV1NotificationsGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [ApiV1NotificationsGet200ResponseItemsInner, _$ApiV1NotificationsGet200ResponseItemsInner];

  @override
  final String wireName = r'ApiV1NotificationsGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1NotificationsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(String),
    );
    yield r'readAt';
    yield object.readAt == null ? null : serializers.serialize(
      object.readAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1NotificationsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1NotificationsGet200ResponseItemsInnerBuilder result,
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
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channel = valueDes;
          break;
        case r'readAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.readAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  ApiV1NotificationsGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1NotificationsGet200ResponseItemsInnerBuilder();
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

