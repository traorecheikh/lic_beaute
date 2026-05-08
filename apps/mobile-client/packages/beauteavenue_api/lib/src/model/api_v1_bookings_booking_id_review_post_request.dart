//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_bookings_booking_id_review_post_request.g.dart';

/// ApiV1BookingsBookingIdReviewPostRequest
///
/// Properties:
/// * [rating] 
/// * [comment] 
@BuiltValue()
abstract class ApiV1BookingsBookingIdReviewPostRequest implements Built<ApiV1BookingsBookingIdReviewPostRequest, ApiV1BookingsBookingIdReviewPostRequestBuilder> {
  @BuiltValueField(wireName: r'rating')
  int get rating;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  ApiV1BookingsBookingIdReviewPostRequest._();

  factory ApiV1BookingsBookingIdReviewPostRequest([void updates(ApiV1BookingsBookingIdReviewPostRequestBuilder b)]) = _$ApiV1BookingsBookingIdReviewPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1BookingsBookingIdReviewPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1BookingsBookingIdReviewPostRequest> get serializer => _$ApiV1BookingsBookingIdReviewPostRequestSerializer();
}

class _$ApiV1BookingsBookingIdReviewPostRequestSerializer implements PrimitiveSerializer<ApiV1BookingsBookingIdReviewPostRequest> {
  @override
  final Iterable<Type> types = const [ApiV1BookingsBookingIdReviewPostRequest, _$ApiV1BookingsBookingIdReviewPostRequest];

  @override
  final String wireName = r'ApiV1BookingsBookingIdReviewPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1BookingsBookingIdReviewPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(int),
    );
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1BookingsBookingIdReviewPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1BookingsBookingIdReviewPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rating = valueDes;
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.comment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1BookingsBookingIdReviewPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1BookingsBookingIdReviewPostRequestBuilder();
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

