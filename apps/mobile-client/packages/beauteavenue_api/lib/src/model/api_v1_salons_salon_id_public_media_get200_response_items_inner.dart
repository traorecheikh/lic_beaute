//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_salons_salon_id_public_media_get200_response_items_inner.g.dart';

/// ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner
///
/// Properties:
/// * [id] 
/// * [publicUrl] 
/// * [purpose] 
/// * [mimeType] 
/// * [displayOrder] 
/// * [createdAt] 
@BuiltValue()
abstract class ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner implements Built<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner, ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'publicUrl')
  String get publicUrl;

  @BuiltValueField(wireName: r'purpose')
  String get purpose;

  @BuiltValueField(wireName: r'mimeType')
  String get mimeType;

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner._();

  factory ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner([void updates(ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder b)]) = _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner> get serializer => _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerSerializer();
}

class _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerSerializer implements PrimitiveSerializer<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner, _$ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner];

  @override
  final String wireName = r'ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'publicUrl';
    yield serializers.serialize(
      object.publicUrl,
      specifiedType: const FullType(String),
    );
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(String),
    );
    yield r'mimeType';
    yield serializers.serialize(
      object.mimeType,
      specifiedType: const FullType(String),
    );
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
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
    ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder result,
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
        case r'publicUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publicUrl = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.purpose = valueDes;
          break;
        case r'mimeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mimeType = valueDes;
          break;
        case r'displayOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.displayOrder = valueDes;
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
  ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInnerBuilder();
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

