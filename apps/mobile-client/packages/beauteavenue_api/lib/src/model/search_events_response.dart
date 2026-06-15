//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_events_response.g.dart';

/// SearchEventsResponse
///
/// Properties:
/// * [accepted] 
@BuiltValue()
abstract class SearchEventsResponse implements Built<SearchEventsResponse, SearchEventsResponseBuilder> {
  @BuiltValueField(wireName: r'accepted')
  int get accepted;

  SearchEventsResponse._();

  factory SearchEventsResponse([void updates(SearchEventsResponseBuilder b)]) = _$SearchEventsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchEventsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchEventsResponse> get serializer => _$SearchEventsResponseSerializer();
}

class _$SearchEventsResponseSerializer implements PrimitiveSerializer<SearchEventsResponse> {
  @override
  final Iterable<Type> types = const [SearchEventsResponse, _$SearchEventsResponse];

  @override
  final String wireName = r'SearchEventsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchEventsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchEventsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchEventsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.accepted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchEventsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchEventsResponseBuilder();
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

