//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/search_events_request_events_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_events_request.g.dart';

/// SearchEventsRequest
///
/// Properties:
/// * [events] 
@BuiltValue()
abstract class SearchEventsRequest implements Built<SearchEventsRequest, SearchEventsRequestBuilder> {
  @BuiltValueField(wireName: r'events')
  BuiltList<SearchEventsRequestEventsInner> get events;

  SearchEventsRequest._();

  factory SearchEventsRequest([void updates(SearchEventsRequestBuilder b)]) = _$SearchEventsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchEventsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchEventsRequest> get serializer => _$SearchEventsRequestSerializer();
}

class _$SearchEventsRequestSerializer implements PrimitiveSerializer<SearchEventsRequest> {
  @override
  final Iterable<Type> types = const [SearchEventsRequest, _$SearchEventsRequest];

  @override
  final String wireName = r'SearchEventsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchEventsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [FullType(SearchEventsRequestEventsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchEventsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchEventsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchEventsRequestEventsInner)]),
          ) as BuiltList<SearchEventsRequestEventsInner>;
          result.events.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchEventsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchEventsRequestBuilder();
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

