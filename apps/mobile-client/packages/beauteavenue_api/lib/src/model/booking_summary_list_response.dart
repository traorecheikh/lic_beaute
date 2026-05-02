//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/booking_summary_list_response_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'booking_summary_list_response.g.dart';

/// BookingSummaryListResponse
///
/// Properties:
/// * [items]
/// * [total]
@BuiltValue()
abstract class BookingSummaryListResponse
    implements
        Built<BookingSummaryListResponse, BookingSummaryListResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<BookingSummaryListResponseItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  BookingSummaryListResponse._();

  factory BookingSummaryListResponse(
          [void updates(BookingSummaryListResponseBuilder b)]) =
      _$BookingSummaryListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookingSummaryListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookingSummaryListResponse> get serializer =>
      _$BookingSummaryListResponseSerializer();
}

class _$BookingSummaryListResponseSerializer
    implements PrimitiveSerializer<BookingSummaryListResponse> {
  @override
  final Iterable<Type> types = const [
    BookingSummaryListResponse,
    _$BookingSummaryListResponse
  ];

  @override
  final String wireName = r'BookingSummaryListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookingSummaryListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(
          BuiltList, [FullType(BookingSummaryListResponseItemsInner)]),
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
    BookingSummaryListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BookingSummaryListResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(BookingSummaryListResponseItemsInner)]),
          ) as BuiltList<BookingSummaryListResponseItemsInner>;
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
  BookingSummaryListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookingSummaryListResponseBuilder();
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
