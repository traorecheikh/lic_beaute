//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/search_salons_response_facets_categories_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_salons_response_facets.g.dart';

/// SearchSalonsResponseFacets
///
/// Properties:
/// * [categories] 
/// * [cities] 
/// * [neighborhoods] 
/// * [priceRanges] 
/// * [openNowCount] 
/// * [bookableSoonCount] 
@BuiltValue()
abstract class SearchSalonsResponseFacets implements Built<SearchSalonsResponseFacets, SearchSalonsResponseFacetsBuilder> {
  @BuiltValueField(wireName: r'categories')
  BuiltList<SearchSalonsResponseFacetsCategoriesInner> get categories;

  @BuiltValueField(wireName: r'cities')
  BuiltList<SearchSalonsResponseFacetsCategoriesInner> get cities;

  @BuiltValueField(wireName: r'neighborhoods')
  BuiltList<SearchSalonsResponseFacetsCategoriesInner> get neighborhoods;

  @BuiltValueField(wireName: r'priceRanges')
  BuiltList<SearchSalonsResponseFacetsCategoriesInner> get priceRanges;

  @BuiltValueField(wireName: r'openNowCount')
  int get openNowCount;

  @BuiltValueField(wireName: r'bookableSoonCount')
  int get bookableSoonCount;

  SearchSalonsResponseFacets._();

  factory SearchSalonsResponseFacets([void updates(SearchSalonsResponseFacetsBuilder b)]) = _$SearchSalonsResponseFacets;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchSalonsResponseFacetsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchSalonsResponseFacets> get serializer => _$SearchSalonsResponseFacetsSerializer();
}

class _$SearchSalonsResponseFacetsSerializer implements PrimitiveSerializer<SearchSalonsResponseFacets> {
  @override
  final Iterable<Type> types = const [SearchSalonsResponseFacets, _$SearchSalonsResponseFacets];

  @override
  final String wireName = r'SearchSalonsResponseFacets';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchSalonsResponseFacets object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseFacetsCategoriesInner)]),
    );
    yield r'cities';
    yield serializers.serialize(
      object.cities,
      specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseFacetsCategoriesInner)]),
    );
    yield r'neighborhoods';
    yield serializers.serialize(
      object.neighborhoods,
      specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseFacetsCategoriesInner)]),
    );
    yield r'priceRanges';
    yield serializers.serialize(
      object.priceRanges,
      specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseFacetsCategoriesInner)]),
    );
    yield r'openNowCount';
    yield serializers.serialize(
      object.openNowCount,
      specifiedType: const FullType(int),
    );
    yield r'bookableSoonCount';
    yield serializers.serialize(
      object.bookableSoonCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchSalonsResponseFacets object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchSalonsResponseFacetsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseFacetsCategoriesInner)]),
          ) as BuiltList<SearchSalonsResponseFacetsCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        case r'cities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseFacetsCategoriesInner)]),
          ) as BuiltList<SearchSalonsResponseFacetsCategoriesInner>;
          result.cities.replace(valueDes);
          break;
        case r'neighborhoods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseFacetsCategoriesInner)]),
          ) as BuiltList<SearchSalonsResponseFacetsCategoriesInner>;
          result.neighborhoods.replace(valueDes);
          break;
        case r'priceRanges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSalonsResponseFacetsCategoriesInner)]),
          ) as BuiltList<SearchSalonsResponseFacetsCategoriesInner>;
          result.priceRanges.replace(valueDes);
          break;
        case r'openNowCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.openNowCount = valueDes;
          break;
        case r'bookableSoonCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookableSoonCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchSalonsResponseFacets deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchSalonsResponseFacetsBuilder();
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

