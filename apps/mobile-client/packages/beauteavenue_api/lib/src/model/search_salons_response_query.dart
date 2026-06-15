//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/search_suggestions_response_entity_hints_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_salons_response_query.g.dart';

/// SearchSalonsResponseQuery
///
/// Properties:
/// * [normalized] 
/// * [corrected] 
/// * [interpretedEntities] 
@BuiltValue()
abstract class SearchSalonsResponseQuery implements Built<SearchSalonsResponseQuery, SearchSalonsResponseQueryBuilder> {
  @BuiltValueField(wireName: r'normalized')
  String get normalized;

  @BuiltValueField(wireName: r'corrected')
  String? get corrected;

  @BuiltValueField(wireName: r'interpretedEntities')
  BuiltList<SearchSuggestionsResponseEntityHintsInner> get interpretedEntities;

  SearchSalonsResponseQuery._();

  factory SearchSalonsResponseQuery([void updates(SearchSalonsResponseQueryBuilder b)]) = _$SearchSalonsResponseQuery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchSalonsResponseQueryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchSalonsResponseQuery> get serializer => _$SearchSalonsResponseQuerySerializer();
}

class _$SearchSalonsResponseQuerySerializer implements PrimitiveSerializer<SearchSalonsResponseQuery> {
  @override
  final Iterable<Type> types = const [SearchSalonsResponseQuery, _$SearchSalonsResponseQuery];

  @override
  final String wireName = r'SearchSalonsResponseQuery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchSalonsResponseQuery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'normalized';
    yield serializers.serialize(
      object.normalized,
      specifiedType: const FullType(String),
    );
    yield r'corrected';
    yield object.corrected == null ? null : serializers.serialize(
      object.corrected,
      specifiedType: const FullType.nullable(String),
    );
    yield r'interpretedEntities';
    yield serializers.serialize(
      object.interpretedEntities,
      specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseEntityHintsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchSalonsResponseQuery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchSalonsResponseQueryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'normalized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.normalized = valueDes;
          break;
        case r'corrected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.corrected = valueDes;
          break;
        case r'interpretedEntities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SearchSuggestionsResponseEntityHintsInner)]),
          ) as BuiltList<SearchSuggestionsResponseEntityHintsInner>;
          result.interpretedEntities.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchSalonsResponseQuery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchSalonsResponseQueryBuilder();
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

