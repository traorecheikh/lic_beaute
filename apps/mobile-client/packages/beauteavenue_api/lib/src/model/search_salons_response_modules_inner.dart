//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/search_suggestions_response_top_matches_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_salons_response_modules_inner.g.dart';

/// SearchSalonsResponseModulesInner
///
/// Properties:
/// * [type] 
/// * [title] 
/// * [items] 
@BuiltValue()
abstract class SearchSalonsResponseModulesInner implements Built<SearchSalonsResponseModulesInner, SearchSalonsResponseModulesInnerBuilder> {
  @BuiltValueField(wireName: r'type')
  SearchSalonsResponseModulesInnerTypeEnum get type;
  // enum typeEnum {  near_you,  bookable_now,  prestige_for_query,  trending_for_query,  continue_exploring,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'items')
  BuiltList<SearchSuggestionsResponseTopMatchesInner> get items;

  SearchSalonsResponseModulesInner._();

  factory SearchSalonsResponseModulesInner([void updates(SearchSalonsResponseModulesInnerBuilder b)]) = _$SearchSalonsResponseModulesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchSalonsResponseModulesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchSalonsResponseModulesInner> get serializer => _$SearchSalonsResponseModulesInnerSerializer();
}

class _$SearchSalonsResponseModulesInnerSerializer implements PrimitiveSerializer<SearchSalonsResponseModulesInner> {
  @override
  final Iterable<Type> types = const [SearchSalonsResponseModulesInner, _$SearchSalonsResponseModulesInner];

  @override
  final String wireName = r'SearchSalonsResponseModulesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchSalonsResponseModulesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(SearchSalonsResponseModulesInnerTypeEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseTopMatchesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchSalonsResponseModulesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchSalonsResponseModulesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchSalonsResponseModulesInnerTypeEnum),
          ) as SearchSalonsResponseModulesInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseTopMatchesInner)]),
          ) as BuiltList<SearchSuggestionsResponseTopMatchesInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchSalonsResponseModulesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchSalonsResponseModulesInnerBuilder();
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

class SearchSalonsResponseModulesInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'near_you')
  static const SearchSalonsResponseModulesInnerTypeEnum nearYou = _$searchSalonsResponseModulesInnerTypeEnum_nearYou;
  @BuiltValueEnumConst(wireName: r'bookable_now')
  static const SearchSalonsResponseModulesInnerTypeEnum bookableNow = _$searchSalonsResponseModulesInnerTypeEnum_bookableNow;
  @BuiltValueEnumConst(wireName: r'prestige_for_query')
  static const SearchSalonsResponseModulesInnerTypeEnum prestigeForQuery = _$searchSalonsResponseModulesInnerTypeEnum_prestigeForQuery;
  @BuiltValueEnumConst(wireName: r'trending_for_query')
  static const SearchSalonsResponseModulesInnerTypeEnum trendingForQuery = _$searchSalonsResponseModulesInnerTypeEnum_trendingForQuery;
  @BuiltValueEnumConst(wireName: r'continue_exploring')
  static const SearchSalonsResponseModulesInnerTypeEnum continueExploring = _$searchSalonsResponseModulesInnerTypeEnum_continueExploring;

  static Serializer<SearchSalonsResponseModulesInnerTypeEnum> get serializer => _$searchSalonsResponseModulesInnerTypeEnumSerializer;

  const SearchSalonsResponseModulesInnerTypeEnum._(String name): super(name);

  static BuiltSet<SearchSalonsResponseModulesInnerTypeEnum> get values => _$searchSalonsResponseModulesInnerTypeEnumValues;
  static SearchSalonsResponseModulesInnerTypeEnum valueOf(String name) => _$searchSalonsResponseModulesInnerTypeEnumValueOf(name);
}

