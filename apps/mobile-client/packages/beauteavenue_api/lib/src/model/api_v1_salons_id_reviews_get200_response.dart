//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/api_v1_bookings_booking_id_review_post201_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_salons_id_reviews_get200_response.g.dart';

/// ApiV1SalonsIdReviewsGet200Response
///
/// Properties:
/// * [items] 
/// * [total] 
@BuiltValue()
abstract class ApiV1SalonsIdReviewsGet200Response implements Built<ApiV1SalonsIdReviewsGet200Response, ApiV1SalonsIdReviewsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ApiV1BookingsBookingIdReviewPost201Response> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  ApiV1SalonsIdReviewsGet200Response._();

  factory ApiV1SalonsIdReviewsGet200Response([void updates(ApiV1SalonsIdReviewsGet200ResponseBuilder b)]) = _$ApiV1SalonsIdReviewsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1SalonsIdReviewsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1SalonsIdReviewsGet200Response> get serializer => _$ApiV1SalonsIdReviewsGet200ResponseSerializer();
}

class _$ApiV1SalonsIdReviewsGet200ResponseSerializer implements PrimitiveSerializer<ApiV1SalonsIdReviewsGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1SalonsIdReviewsGet200Response, _$ApiV1SalonsIdReviewsGet200Response];

  @override
  final String wireName = r'ApiV1SalonsIdReviewsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1SalonsIdReviewsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ApiV1BookingsBookingIdReviewPost201Response)]),
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
    ApiV1SalonsIdReviewsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1SalonsIdReviewsGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiV1BookingsBookingIdReviewPost201Response)]),
          ) as BuiltList<ApiV1BookingsBookingIdReviewPost201Response>;
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
  ApiV1SalonsIdReviewsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1SalonsIdReviewsGet200ResponseBuilder();
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

