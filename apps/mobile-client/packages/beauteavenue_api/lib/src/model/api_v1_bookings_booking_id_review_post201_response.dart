//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_bookings_booking_id_review_post201_response.g.dart';

/// ApiV1BookingsBookingIdReviewPost201Response
///
/// Properties:
/// * [id] 
/// * [rating] 
/// * [comment] 
/// * [createdAt] 
/// * [responseText] 
/// * [responseAt] 
@BuiltValue()
abstract class ApiV1BookingsBookingIdReviewPost201Response implements Built<ApiV1BookingsBookingIdReviewPost201Response, ApiV1BookingsBookingIdReviewPost201ResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'rating')
  int get rating;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'responseText')
  String? get responseText;

  @BuiltValueField(wireName: r'responseAt')
  DateTime? get responseAt;

  ApiV1BookingsBookingIdReviewPost201Response._();

  factory ApiV1BookingsBookingIdReviewPost201Response([void updates(ApiV1BookingsBookingIdReviewPost201ResponseBuilder b)]) = _$ApiV1BookingsBookingIdReviewPost201Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1BookingsBookingIdReviewPost201ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1BookingsBookingIdReviewPost201Response> get serializer => _$ApiV1BookingsBookingIdReviewPost201ResponseSerializer();
}

class _$ApiV1BookingsBookingIdReviewPost201ResponseSerializer implements PrimitiveSerializer<ApiV1BookingsBookingIdReviewPost201Response> {
  @override
  final Iterable<Type> types = const [ApiV1BookingsBookingIdReviewPost201Response, _$ApiV1BookingsBookingIdReviewPost201Response];

  @override
  final String wireName = r'ApiV1BookingsBookingIdReviewPost201Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1BookingsBookingIdReviewPost201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(int),
    );
    yield r'comment';
    yield object.comment == null ? null : serializers.serialize(
      object.comment,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'responseText';
    yield object.responseText == null ? null : serializers.serialize(
      object.responseText,
      specifiedType: const FullType.nullable(String),
    );
    yield r'responseAt';
    yield object.responseAt == null ? null : serializers.serialize(
      object.responseAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1BookingsBookingIdReviewPost201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1BookingsBookingIdReviewPost201ResponseBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'responseText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.responseText = valueDes;
          break;
        case r'responseAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.responseAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1BookingsBookingIdReviewPost201Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1BookingsBookingIdReviewPost201ResponseBuilder();
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

