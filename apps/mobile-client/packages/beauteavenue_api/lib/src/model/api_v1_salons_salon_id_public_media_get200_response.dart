//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/api_v1_salons_salon_id_public_media_get200_response_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_salons_salon_id_public_media_get200_response.g.dart';

/// ApiV1SalonsSalonIdPublicMediaGet200Response
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class ApiV1SalonsSalonIdPublicMediaGet200Response implements Built<ApiV1SalonsSalonIdPublicMediaGet200Response, ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner> get items;

  ApiV1SalonsSalonIdPublicMediaGet200Response._();

  factory ApiV1SalonsSalonIdPublicMediaGet200Response([void updates(ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder b)]) = _$ApiV1SalonsSalonIdPublicMediaGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SalonsSalonIdPublicMediaGet200Response> get serializer => _$ApiV1SalonsSalonIdPublicMediaGet200ResponseSerializer();
}

class _$ApiV1SalonsSalonIdPublicMediaGet200ResponseSerializer implements PrimitiveSerializer<ApiV1SalonsSalonIdPublicMediaGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1SalonsSalonIdPublicMediaGet200Response, _$ApiV1SalonsSalonIdPublicMediaGet200Response];

  @override
  final String wireName = r'ApiV1SalonsSalonIdPublicMediaGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SalonsSalonIdPublicMediaGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1SalonsSalonIdPublicMediaGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner)]),
          ) as BuiltList<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1SalonsSalonIdPublicMediaGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder();
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

