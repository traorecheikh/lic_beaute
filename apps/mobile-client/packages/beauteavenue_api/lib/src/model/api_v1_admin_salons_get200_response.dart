//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/api_v1_admin_salons_get200_response_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_salons_get200_response.g.dart';

/// ApiV1AdminSalonsGet200Response
///
/// Properties:
/// * [items] 
/// * [total] 
@BuiltValue()
abstract class ApiV1AdminSalonsGet200Response implements Built<ApiV1AdminSalonsGet200Response, ApiV1AdminSalonsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ApiV1AdminSalonsGet200ResponseItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  ApiV1AdminSalonsGet200Response._();

  factory ApiV1AdminSalonsGet200Response([void updates(ApiV1AdminSalonsGet200ResponseBuilder b)]) = _$ApiV1AdminSalonsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminSalonsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminSalonsGet200Response> get serializer => _$ApiV1AdminSalonsGet200ResponseSerializer();
}

class _$ApiV1AdminSalonsGet200ResponseSerializer implements PrimitiveSerializer<ApiV1AdminSalonsGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1AdminSalonsGet200Response, _$ApiV1AdminSalonsGet200Response];

  @override
  final String wireName = r'ApiV1AdminSalonsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminSalonsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ApiV1AdminSalonsGet200ResponseItemsInner)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminSalonsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminSalonsGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiV1AdminSalonsGet200ResponseItemsInner)]),
          ) as BuiltList<ApiV1AdminSalonsGet200ResponseItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminSalonsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminSalonsGet200ResponseBuilder();
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

