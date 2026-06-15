//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/search_salons_response_modules_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/search_suggestions_response_top_matches_inner.dart';
import 'package:beauteavenue_api/src/model/search_salons_response_facets.dart';
import 'package:beauteavenue_api/src/model/search_salons_response_query.dart';
import 'package:beauteavenue_api/src/model/search_salons_response_page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_salons_response.g.dart';

/// SearchSalonsResponse
///
/// Properties:
/// * [query] 
/// * [facets] 
/// * [results] 
/// * [modules] 
/// * [pageInfo] 
@BuiltValue()
abstract class SearchSalonsResponse implements Built<SearchSalonsResponse, SearchSalonsResponseBuilder> {
  @BuiltValueField(wireName: r'query')
  SearchSalonsResponseQuery get query;

  @BuiltValueField(wireName: r'facets')
  SearchSalonsResponseFacets get facets;

  @BuiltValueField(wireName: r'results')
  BuiltList<SearchSuggestionsResponseTopMatchesInner> get results;

  @BuiltValueField(wireName: r'modules')
  BuiltList<SearchSalonsResponseModulesInner> get modules;

  @BuiltValueField(wireName: r'pageInfo')
  SearchSalonsResponsePageInfo get pageInfo;

  SearchSalonsResponse._();

  factory SearchSalonsResponse([void updates(SearchSalonsResponseBuilder b)]) = _$SearchSalonsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchSalonsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchSalonsResponse> get serializer => _$SearchSalonsResponseSerializer();
}

class _$SearchSalonsResponseSerializer implements PrimitiveSerializer<SearchSalonsResponse> {
  @override
  final Iterable<Type> types = const [SearchSalonsResponse, _$SearchSalonsResponse];

  @override
  final String wireName = r'SearchSalonsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchSalonsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'query';
    yield serializers.serialize(
      object.query,
      specifiedType: const FullType(SearchSalonsResponseQuery),
    );
    yield r'facets';
    yield serializers.serialize(
      object.facets,
      specifiedType: const FullType(SearchSalonsResponseFacets),
    );
    yield r'results';
    yield serializers.serialize(
      object.results,
      specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseTopMatchesInner)]),
    );
    yield r'modules';
    yield serializers.serialize(
      object.modules,
      specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseModulesInner)]),
    );
    yield r'pageInfo';
    yield serializers.serialize(
      object.pageInfo,
      specifiedType: const FullType(SearchSalonsResponsePageInfo),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchSalonsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchSalonsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'query':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchSalonsResponseQuery),
          ) as SearchSalonsResponseQuery;
          result.query.replace(valueDes);
          break;
        case r'facets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchSalonsResponseFacets),
          ) as SearchSalonsResponseFacets;
          result.facets.replace(valueDes);
          break;
        case r'results':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseTopMatchesInner)]),
          ) as BuiltList<SearchSuggestionsResponseTopMatchesInner>;
          result.results.replace(valueDes);
          break;
        case r'modules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseModulesInner)]),
          ) as BuiltList<SearchSalonsResponseModulesInner>;
          result.modules.replace(valueDes);
          break;
        case r'pageInfo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchSalonsResponsePageInfo),
          ) as SearchSalonsResponsePageInfo;
          result.pageInfo.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchSalonsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchSalonsResponseBuilder();
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

