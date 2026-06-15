//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_suggestions_response_suggestions_inner.g.dart';

/// SearchSuggestionsResponseSuggestionsInner
///
/// Properties:
/// * [text] 
/// * [type] 
/// * [salonId] 
/// * [logoUrl] 
/// * [subtitle] 
@BuiltValue()
abstract class SearchSuggestionsResponseSuggestionsInner implements Built<SearchSuggestionsResponseSuggestionsInner, SearchSuggestionsResponseSuggestionsInnerBuilder> {
  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'type')
  SearchSuggestionsResponseSuggestionsInnerTypeEnum get type;
  // enum typeEnum {  salon,  service,  category,  neighborhood,  city,  recent,  };

  @BuiltValueField(wireName: r'salonId')
  String? get salonId;

  @BuiltValueField(wireName: r'logoUrl')
  String? get logoUrl;

  @BuiltValueField(wireName: r'subtitle')
  String? get subtitle;

  SearchSuggestionsResponseSuggestionsInner._();

  factory SearchSuggestionsResponseSuggestionsInner([void updates(SearchSuggestionsResponseSuggestionsInnerBuilder b)]) = _$SearchSuggestionsResponseSuggestionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchSuggestionsResponseSuggestionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchSuggestionsResponseSuggestionsInner> get serializer => _$SearchSuggestionsResponseSuggestionsInnerSerializer();
}

class _$SearchSuggestionsResponseSuggestionsInnerSerializer implements PrimitiveSerializer<SearchSuggestionsResponseSuggestionsInner> {
  @override
  final Iterable<Type> types = const [SearchSuggestionsResponseSuggestionsInner, _$SearchSuggestionsResponseSuggestionsInner];

  @override
  final String wireName = r'SearchSuggestionsResponseSuggestionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchSuggestionsResponseSuggestionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(SearchSuggestionsResponseSuggestionsInnerTypeEnum),
    );
    if (object.salonId != null) {
      yield r'salonId';
      yield serializers.serialize(
        object.salonId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.logoUrl != null) {
      yield r'logoUrl';
      yield serializers.serialize(
        object.logoUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.subtitle != null) {
      yield r'subtitle';
      yield serializers.serialize(
        object.subtitle,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchSuggestionsResponseSuggestionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchSuggestionsResponseSuggestionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchSuggestionsResponseSuggestionsInnerTypeEnum),
          ) as SearchSuggestionsResponseSuggestionsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.salonId = valueDes;
          break;
        case r'logoUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'subtitle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subtitle = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchSuggestionsResponseSuggestionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchSuggestionsResponseSuggestionsInnerBuilder();
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

class SearchSuggestionsResponseSuggestionsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'salon')
  static const SearchSuggestionsResponseSuggestionsInnerTypeEnum salon = _$searchSuggestionsResponseSuggestionsInnerTypeEnum_salon;
  @BuiltValueEnumConst(wireName: r'service')
  static const SearchSuggestionsResponseSuggestionsInnerTypeEnum service = _$searchSuggestionsResponseSuggestionsInnerTypeEnum_service;
  @BuiltValueEnumConst(wireName: r'category')
  static const SearchSuggestionsResponseSuggestionsInnerTypeEnum category = _$searchSuggestionsResponseSuggestionsInnerTypeEnum_category;
  @BuiltValueEnumConst(wireName: r'neighborhood')
  static const SearchSuggestionsResponseSuggestionsInnerTypeEnum neighborhood = _$searchSuggestionsResponseSuggestionsInnerTypeEnum_neighborhood;
  @BuiltValueEnumConst(wireName: r'city')
  static const SearchSuggestionsResponseSuggestionsInnerTypeEnum city = _$searchSuggestionsResponseSuggestionsInnerTypeEnum_city;
  @BuiltValueEnumConst(wireName: r'recent')
  static const SearchSuggestionsResponseSuggestionsInnerTypeEnum recent = _$searchSuggestionsResponseSuggestionsInnerTypeEnum_recent;

  static Serializer<SearchSuggestionsResponseSuggestionsInnerTypeEnum> get serializer => _$searchSuggestionsResponseSuggestionsInnerTypeEnumSerializer;

  const SearchSuggestionsResponseSuggestionsInnerTypeEnum._(String name): super(name);

  static BuiltSet<SearchSuggestionsResponseSuggestionsInnerTypeEnum> get values => _$searchSuggestionsResponseSuggestionsInnerTypeEnumValues;
  static SearchSuggestionsResponseSuggestionsInnerTypeEnum valueOf(String name) => _$searchSuggestionsResponseSuggestionsInnerTypeEnumValueOf(name);
}

