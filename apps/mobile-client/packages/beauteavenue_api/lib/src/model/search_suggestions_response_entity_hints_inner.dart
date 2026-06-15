//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_suggestions_response_entity_hints_inner.g.dart';

/// SearchSuggestionsResponseEntityHintsInner
///
/// Properties:
/// * [type] 
/// * [value] 
/// * [count] 
@BuiltValue()
abstract class SearchSuggestionsResponseEntityHintsInner implements Built<SearchSuggestionsResponseEntityHintsInner, SearchSuggestionsResponseEntityHintsInnerBuilder> {
  @BuiltValueField(wireName: r'type')
  SearchSuggestionsResponseEntityHintsInnerTypeEnum get type;
  // enum typeEnum {  category,  city,  neighborhood,  };

  @BuiltValueField(wireName: r'value')
  String get value;

  @BuiltValueField(wireName: r'count')
  int get count;

  SearchSuggestionsResponseEntityHintsInner._();

  factory SearchSuggestionsResponseEntityHintsInner([void updates(SearchSuggestionsResponseEntityHintsInnerBuilder b)]) = _$SearchSuggestionsResponseEntityHintsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchSuggestionsResponseEntityHintsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchSuggestionsResponseEntityHintsInner> get serializer => _$SearchSuggestionsResponseEntityHintsInnerSerializer();
}

class _$SearchSuggestionsResponseEntityHintsInnerSerializer implements PrimitiveSerializer<SearchSuggestionsResponseEntityHintsInner> {
  @override
  final Iterable<Type> types = const [SearchSuggestionsResponseEntityHintsInner, _$SearchSuggestionsResponseEntityHintsInner];

  @override
  final String wireName = r'SearchSuggestionsResponseEntityHintsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchSuggestionsResponseEntityHintsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(SearchSuggestionsResponseEntityHintsInnerTypeEnum),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchSuggestionsResponseEntityHintsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchSuggestionsResponseEntityHintsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchSuggestionsResponseEntityHintsInnerTypeEnum),
          ) as SearchSuggestionsResponseEntityHintsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchSuggestionsResponseEntityHintsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchSuggestionsResponseEntityHintsInnerBuilder();
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

class SearchSuggestionsResponseEntityHintsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'category')
  static const SearchSuggestionsResponseEntityHintsInnerTypeEnum category = _$searchSuggestionsResponseEntityHintsInnerTypeEnum_category;
  @BuiltValueEnumConst(wireName: r'city')
  static const SearchSuggestionsResponseEntityHintsInnerTypeEnum city = _$searchSuggestionsResponseEntityHintsInnerTypeEnum_city;
  @BuiltValueEnumConst(wireName: r'neighborhood')
  static const SearchSuggestionsResponseEntityHintsInnerTypeEnum neighborhood = _$searchSuggestionsResponseEntityHintsInnerTypeEnum_neighborhood;

  static Serializer<SearchSuggestionsResponseEntityHintsInnerTypeEnum> get serializer => _$searchSuggestionsResponseEntityHintsInnerTypeEnumSerializer;

  const SearchSuggestionsResponseEntityHintsInnerTypeEnum._(String name): super(name);

  static BuiltSet<SearchSuggestionsResponseEntityHintsInnerTypeEnum> get values => _$searchSuggestionsResponseEntityHintsInnerTypeEnumValues;
  static SearchSuggestionsResponseEntityHintsInnerTypeEnum valueOf(String name) => _$searchSuggestionsResponseEntityHintsInnerTypeEnumValueOf(name);
}

