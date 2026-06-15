//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_salons_response_facets_categories_inner.g.dart';

/// SearchSalonsResponseFacetsCategoriesInner
///
/// Properties:
/// * [value] 
/// * [count] 
/// * [active] 
@BuiltValue()
abstract class SearchSalonsResponseFacetsCategoriesInner implements Built<SearchSalonsResponseFacetsCategoriesInner, SearchSalonsResponseFacetsCategoriesInnerBuilder> {
  @BuiltValueField(wireName: r'value')
  String get value;

  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'active')
  bool? get active;

  SearchSalonsResponseFacetsCategoriesInner._();

  factory SearchSalonsResponseFacetsCategoriesInner([void updates(SearchSalonsResponseFacetsCategoriesInnerBuilder b)]) = _$SearchSalonsResponseFacetsCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchSalonsResponseFacetsCategoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchSalonsResponseFacetsCategoriesInner> get serializer => _$SearchSalonsResponseFacetsCategoriesInnerSerializer();
}

class _$SearchSalonsResponseFacetsCategoriesInnerSerializer implements PrimitiveSerializer<SearchSalonsResponseFacetsCategoriesInner> {
  @override
  final Iterable<Type> types = const [SearchSalonsResponseFacetsCategoriesInner, _$SearchSalonsResponseFacetsCategoriesInner];

  @override
  final String wireName = r'SearchSalonsResponseFacetsCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchSalonsResponseFacetsCategoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.active != null) {
      yield r'active';
      yield serializers.serialize(
        object.active,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchSalonsResponseFacetsCategoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchSalonsResponseFacetsCategoriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.active = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchSalonsResponseFacetsCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchSalonsResponseFacetsCategoriesInnerBuilder();
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

