//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/search_suggestions_response_entity_hints_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/search_suggestions_response_suggestions_inner.dart';
import 'package:beauteavenue_api/src/model/search_suggestions_response_top_matches_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_suggestions_response.g.dart';

/// SearchSuggestionsResponse
///
/// Properties:
/// * [normalizedQuery] 
/// * [didYouMean] 
/// * [suggestions] 
/// * [entityHints] 
/// * [topMatches] 
@BuiltValue()
abstract class SearchSuggestionsResponse implements Built<SearchSuggestionsResponse, SearchSuggestionsResponseBuilder> {
  @BuiltValueField(wireName: r'normalizedQuery')
  String get normalizedQuery;

  @BuiltValueField(wireName: r'didYouMean')
  String? get didYouMean;

  @BuiltValueField(wireName: r'suggestions')
  BuiltList<SearchSuggestionsResponseSuggestionsInner> get suggestions;

  @BuiltValueField(wireName: r'entityHints')
  BuiltList<SearchSuggestionsResponseEntityHintsInner> get entityHints;

  @BuiltValueField(wireName: r'topMatches')
  BuiltList<SearchSuggestionsResponseTopMatchesInner> get topMatches;

  SearchSuggestionsResponse._();

  factory SearchSuggestionsResponse([void updates(SearchSuggestionsResponseBuilder b)]) = _$SearchSuggestionsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchSuggestionsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchSuggestionsResponse> get serializer => _$SearchSuggestionsResponseSerializer();
}

class _$SearchSuggestionsResponseSerializer implements PrimitiveSerializer<SearchSuggestionsResponse> {
  @override
  final Iterable<Type> types = const [SearchSuggestionsResponse, _$SearchSuggestionsResponse];

  @override
  final String wireName = r'SearchSuggestionsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchSuggestionsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'normalizedQuery';
    yield serializers.serialize(
      object.normalizedQuery,
      specifiedType: const FullType(String),
    );
    yield r'didYouMean';
    yield object.didYouMean == null ? null : serializers.serialize(
      object.didYouMean,
      specifiedType: const FullType.nullable(String),
    );
    yield r'suggestions';
    yield serializers.serialize(
      object.suggestions,
      specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseSuggestionsInner)]),
    );
    yield r'entityHints';
    yield serializers.serialize(
      object.entityHints,
      specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseEntityHintsInner)]),
    );
    yield r'topMatches';
    yield serializers.serialize(
      object.topMatches,
      specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseTopMatchesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchSuggestionsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchSuggestionsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'normalizedQuery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.normalizedQuery = valueDes;
          break;
        case r'didYouMean':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.didYouMean = valueDes;
          break;
        case r'suggestions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseSuggestionsInner)]),
          ) as BuiltList<SearchSuggestionsResponseSuggestionsInner>;
          result.suggestions.replace(valueDes);
          break;
        case r'entityHints':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseEntityHintsInner)]),
          ) as BuiltList<SearchSuggestionsResponseEntityHintsInner>;
          result.entityHints.replace(valueDes);
          break;
        case r'topMatches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseTopMatchesInner)]),
          ) as BuiltList<SearchSuggestionsResponseTopMatchesInner>;
          result.topMatches.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchSuggestionsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchSuggestionsResponseBuilder();
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

